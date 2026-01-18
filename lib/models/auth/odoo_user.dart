class OdooUser {
  final int uid;
  final String username;
  final String name;
  final String email;
  final String sessionId;
  final DateTime loginTime;
  final String odooUrl;
  final String database;

  OdooUser({
    required this.uid,
    required this.username,
    required this.name,
    required this.email,
    required this.sessionId,
    required this.loginTime,
    required this.odooUrl,
    required this.database,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'username': username,
      'name': name,
      'email': email,
      'sessionId': sessionId,
      'loginTime': loginTime.toIso8601String(),
      'odooUrl': odooUrl,
      'database': database,
    };
  }

  factory OdooUser.fromJson(Map<String, dynamic> json) {
    return OdooUser(
      uid: json['uid'] as int,
      username: json['username'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      sessionId: json['sessionId'] as String,
      loginTime: DateTime.parse(json['loginTime'] as String),
      odooUrl: json['odooUrl'] as String,
      database: json['database'] as String,
    );
  }

  OdooUser copyWith({
    int? uid,
    String? username,
    String? name,
    String? email,
    String? sessionId,
    DateTime? loginTime,
    String? odooUrl,
    String? database,
  }) {
    return OdooUser(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      name: name ?? this.name,
      email: email ?? this.email,
      sessionId: sessionId ?? this.sessionId,
      loginTime: loginTime ?? this.loginTime,
      odooUrl: odooUrl ?? this.odooUrl,
      database: database ?? this.database,
    );
  }
}
