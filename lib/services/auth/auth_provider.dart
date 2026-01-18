import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../../models/auth/odoo_user.dart';
import '../../models/auth/auth_session.dart';
import 'odoo_api_service.dart';
import '../storage_service.dart';

class AuthProvider extends ChangeNotifier {
  AuthSession _session = AuthSession.empty();
  bool _isLoading = false;
  String? _errorMessage;

  AuthSession get session => _session;
  bool get isAuthenticated => _session.isAuthenticated;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  OdooUser? get currentUser => _session.user;

  static const String _sessionKey = 'auth_session';

  /// Initialize authentication state from storage
  Future<void> initialize() async {
    try {
      final sessionJson = await StorageService.getString(_sessionKey);
      if (sessionJson != null && sessionJson.isNotEmpty) {
        final sessionData = AuthSession.fromJson(
          jsonDecode(sessionJson) as Map<String, dynamic>,
        );

        if (sessionData.user != null) {
          // Validate session in background (don't block UI)
          _session = sessionData.copyWith(isAuthenticated: true);
          notifyListeners();

          // Validate session with server if online
          _validateSessionInBackground(sessionData.user!);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to load session: $e');
      }
    }
  }

  /// Validate session in background without blocking UI
  Future<void> _validateSessionInBackground(OdooUser user) async {
    try {
      final isValid = await OdooApiService.validateSession(
        sessionId: user.sessionId,
        database: user.database,
      );

      if (!isValid) {
        // Session is invalid, clear it
        await logout(showMessage: false);
      }
    } catch (e) {
      // Ignore validation errors in background
      if (kDebugMode) {
        debugPrint('Background session validation failed: $e');
      }
    }
  }

  /// Login with Odoo credentials
  Future<bool> login({
    required String username,
    required String password,
    String? database,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await OdooApiService.authenticate(
        username: username,
        password: password,
        database: database,
      );

      if (user != null) {
        _session = AuthSession(
          user: user,
          isAuthenticated: true,
          lastActivity: DateTime.now(),
        );

        // Save session to persistent storage
        await _saveSession();

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Invalid credentials';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = _extractErrorMessage(e.toString());
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Logout user
  Future<void> logout({bool showMessage = true}) async {
    try {
      if (_session.user?.sessionId != null) {
        await OdooApiService.logout(sessionId: _session.user!.sessionId);
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Logout error: $e');
      }
    } finally {
      _session = AuthSession.empty();
      await _clearSession();
      notifyListeners();
    }
  }

  /// Update last activity time
  void updateActivity() {
    if (_session.isAuthenticated) {
      _session = _session.copyWith(lastActivity: DateTime.now());
      _saveSession();
    }
  }

  /// Save session to storage
  Future<void> _saveSession() async {
    try {
      final sessionJson = jsonEncode(_session.toJson());
      await StorageService.saveString(_sessionKey, sessionJson);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to save session: $e');
      }
    }
  }

  /// Clear session from storage
  Future<void> _clearSession() async {
    try {
      await StorageService.saveString(_sessionKey, '');
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to clear session: $e');
      }
    }
  }

  /// Extract user-friendly error message
  String _extractErrorMessage(String error) {
    if (error.contains('timeout')) {
      return 'Connection timeout. Please check your network.';
    } else if (error.contains('Invalid credentials')) {
      return 'Invalid username or password.';
    } else if (error.contains('SocketException')) {
      return 'Cannot connect to Odoo server. Please check network.';
    } else if (error.contains('FormatException')) {
      return 'Server error. Please try again.';
    }
    return 'Login failed. Please try again.';
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
