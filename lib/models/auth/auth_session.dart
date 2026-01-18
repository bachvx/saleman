import 'odoo_user.dart';

class AuthSession {
  final OdooUser? user;
  final bool isAuthenticated;
  final DateTime? lastActivity;

  AuthSession({
    this.user,
    required this.isAuthenticated,
    this.lastActivity,
  });

  Map<String, dynamic> toJson() {
    return {
      'user': user?.toJson(),
      'isAuthenticated': isAuthenticated,
      'lastActivity': lastActivity?.toIso8601String(),
    };
  }

  factory AuthSession.fromJson(Map<String, dynamic> json) {
    return AuthSession(
      user: json['user'] != null
          ? OdooUser.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      isAuthenticated: json['isAuthenticated'] as bool,
      lastActivity: json['lastActivity'] != null
          ? DateTime.parse(json['lastActivity'] as String)
          : null,
    );
  }

  AuthSession copyWith({
    OdooUser? user,
    bool? isAuthenticated,
    DateTime? lastActivity,
  }) {
    return AuthSession(
      user: user ?? this.user,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      lastActivity: lastActivity ?? this.lastActivity,
    );
  }

  static AuthSession empty() {
    return AuthSession(
      user: null,
      isAuthenticated: false,
      lastActivity: null,
    );
  }
}
