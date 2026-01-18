import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/auth/odoo_user.dart';

class OdooApiService {
  static const String odooIp = '172.167.1.47';
  static const String odooPort = '8069';
  static const String odooDatabase = 'odoo_db'; // Default database name
  
  static String get baseUrl => 'http://$odooIp:$odooPort';

  /// Authenticate user with Odoo
  static Future<OdooUser?> authenticate({
    required String username,
    required String password,
    String? database,
  }) async {
    try {
      final db = database ?? odooDatabase;
      final url = Uri.parse('$baseUrl/web/session/authenticate');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'jsonrpc': '2.0',
          'method': 'call',
          'params': {
            'db': db,
            'login': username,
            'password': password,
          },
        }),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Connection timeout. Please check network and Odoo server.');
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data['result'] != null && data['result']['uid'] != null) {
          final result = data['result'];
          
          // Extract session ID from cookies
          String? sessionId;
          final cookies = response.headers['set-cookie'];
          if (cookies != null) {
            final sessionCookie = cookies.split(';').firstWhere(
              (cookie) => cookie.trim().startsWith('session_id='),
              orElse: () => '',
            );
            if (sessionCookie.isNotEmpty) {
              sessionId = sessionCookie.split('=')[1];
            }
          }

          return OdooUser(
            uid: result['uid'] as int,
            username: result['username'] as String? ?? username,
            name: result['name'] as String? ?? username,
            email: result['username'] as String? ?? '',
            sessionId: sessionId ?? '',
            loginTime: DateTime.now(),
            odooUrl: baseUrl,
            database: db,
          );
        } else {
          throw Exception('Invalid credentials');
        }
      } else {
        throw Exception('Authentication failed: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('timeout')) {
        rethrow;
      }
      throw Exception('Authentication error: $e');
    }
  }

  /// Validate session by checking if user is still authenticated
  static Future<bool> validateSession({
    required String sessionId,
    String? database,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/web/session/get_session_info');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'session_id=$sessionId',
        },
        body: jsonEncode({
          'jsonrpc': '2.0',
          'method': 'call',
          'params': {},
        }),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          // On timeout, consider session valid (offline mode)
          return http.Response('{"result": {"uid": true}}', 200);
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['result'] != null && data['result']['uid'] != null;
      }
      return false;
    } catch (e) {
      // On network error, consider session valid (offline mode)
      return true;
    }
  }

  /// Logout from Odoo
  static Future<bool> logout({required String sessionId}) async {
    try {
      final url = Uri.parse('$baseUrl/web/session/destroy');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'session_id=$sessionId',
        },
        body: jsonEncode({
          'jsonrpc': '2.0',
          'method': 'call',
          'params': {},
        }),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          // On timeout, consider logout successful (will clear local session)
          return http.Response('{"result": true}', 200);
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      // On network error, still return true to clear local session
      return true;
    }
  }

  /// Get user information
  static Future<Map<String, dynamic>?> getUserInfo({
    required String sessionId,
    required int uid,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/web/dataset/call_kw');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'session_id=$sessionId',
        },
        body: jsonEncode({
          'jsonrpc': '2.0',
          'method': 'call',
          'params': {
            'model': 'res.users',
            'method': 'read',
            'args': [[uid], ['name', 'login', 'email']],
            'kwargs': {},
          },
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['result'] != null && (data['result'] as List).isNotEmpty) {
          return data['result'][0] as Map<String, dynamic>;
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
