class SalesTarget {
  final String id;
  final String salesRepId;
  final String salesRepName;
  final double monthlyTarget;
  final double currentAchievement;
  final int month;
  final int year;
  final int targetCustomers;
  final int visitedCustomers;
  final DateTime createdAt;

  SalesTarget({
    required this.id,
    required this.salesRepId,
    required this.salesRepName,
    required this.monthlyTarget,
    required this.currentAchievement,
    required this.month,
    required this.year,
    required this.targetCustomers,
    required this.visitedCustomers,
    required this.createdAt,
  });

  double get achievementPercentage =>
      (currentAchievement / monthlyTarget * 100).clamp(0, 100);

  double get customerVisitPercentage =>
      targetCustomers > 0
          ? (visitedCustomers / targetCustomers * 100).clamp(0, 100)
          : 0;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'salesRepId': salesRepId,
      'salesRepName': salesRepName,
      'monthlyTarget': monthlyTarget,
      'currentAchievement': currentAchievement,
      'month': month,
      'year': year,
      'targetCustomers': targetCustomers,
      'visitedCustomers': visitedCustomers,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory SalesTarget.fromJson(Map<String, dynamic> json) {
    return SalesTarget(
      id: json['id'] as String,
      salesRepId: json['salesRepId'] as String,
      salesRepName: json['salesRepName'] as String,
      monthlyTarget: (json['monthlyTarget'] as num).toDouble(),
      currentAchievement: (json['currentAchievement'] as num).toDouble(),
      month: json['month'] as int,
      year: json['year'] as int,
      targetCustomers: json['targetCustomers'] as int,
      visitedCustomers: json['visitedCustomers'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  SalesTarget copyWith({
    String? id,
    String? salesRepId,
    String? salesRepName,
    double? monthlyTarget,
    double? currentAchievement,
    int? month,
    int? year,
    int? targetCustomers,
    int? visitedCustomers,
    DateTime? createdAt,
  }) {
    return SalesTarget(
      id: id ?? this.id,
      salesRepId: salesRepId ?? this.salesRepId,
      salesRepName: salesRepName ?? this.salesRepName,
      monthlyTarget: monthlyTarget ?? this.monthlyTarget,
      currentAchievement: currentAchievement ?? this.currentAchievement,
      month: month ?? this.month,
      year: year ?? this.year,
      targetCustomers: targetCustomers ?? this.targetCustomers,
      visitedCustomers: visitedCustomers ?? this.visitedCustomers,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
