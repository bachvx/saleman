class Task {
  final String id;
  final String title;
  final String description;
  final String customerId;
  final String customerName;
  final String priority; // High, Medium, Low
  final String status; // Pending, In Progress, Completed, Cancelled
  final DateTime dueDate;
  final DateTime? completedDate;
  final String assignedTo;
  final bool isReminder;
  final DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.customerId,
    required this.customerName,
    required this.priority,
    required this.status,
    required this.dueDate,
    this.completedDate,
    required this.assignedTo,
    this.isReminder = false,
    required this.createdAt,
  });

  bool get isOverdue =>
      status != 'Completed' && DateTime.now().isAfter(dueDate);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'customerId': customerId,
      'customerName': customerName,
      'priority': priority,
      'status': status,
      'dueDate': dueDate.toIso8601String(),
      'completedDate': completedDate?.toIso8601String(),
      'assignedTo': assignedTo,
      'isReminder': isReminder,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      customerId: json['customerId'] as String,
      customerName: json['customerName'] as String,
      priority: json['priority'] as String,
      status: json['status'] as String,
      dueDate: DateTime.parse(json['dueDate'] as String),
      completedDate: json['completedDate'] != null
          ? DateTime.parse(json['completedDate'] as String)
          : null,
      assignedTo: json['assignedTo'] as String,
      isReminder: json['isReminder'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
