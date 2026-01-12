class Customer {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String city;
  final double latitude;
  final double longitude;
  final String customerType; // Retail, Wholesale, Distributor
  final double creditLimit;
  final double outstandingBalance;
  final DateTime lastVisitDate;
  final String notes;
  final bool isActive;
  final DateTime createdAt;

  Customer({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.customerType,
    required this.creditLimit,
    required this.outstandingBalance,
    required this.lastVisitDate,
    required this.notes,
    this.isActive = true,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'city': city,
      'latitude': latitude,
      'longitude': longitude,
      'customerType': customerType,
      'creditLimit': creditLimit,
      'outstandingBalance': outstandingBalance,
      'lastVisitDate': lastVisitDate.toIso8601String(),
      'notes': notes,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
      city: json['city'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      customerType: json['customerType'] as String,
      creditLimit: (json['creditLimit'] as num).toDouble(),
      outstandingBalance: (json['outstandingBalance'] as num).toDouble(),
      lastVisitDate: DateTime.parse(json['lastVisitDate'] as String),
      notes: json['notes'] as String,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Customer copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? address,
    String? city,
    double? latitude,
    double? longitude,
    String? customerType,
    double? creditLimit,
    double? outstandingBalance,
    DateTime? lastVisitDate,
    String? notes,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return Customer(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      city: city ?? this.city,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      customerType: customerType ?? this.customerType,
      creditLimit: creditLimit ?? this.creditLimit,
      outstandingBalance: outstandingBalance ?? this.outstandingBalance,
      lastVisitDate: lastVisitDate ?? this.lastVisitDate,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
