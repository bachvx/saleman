class CheckIn {
  final String id;
  final String customerId;
  final String customerName;
  final DateTime checkInTime;
  final DateTime? checkOutTime;
  final double latitude;
  final double longitude;
  final String address;
  final String purpose; // Sales Visit, Delivery, Collection, Survey
  final String notes;
  final List<String> photos;
  final String salesRepId;
  final bool isSynced;

  CheckIn({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.checkInTime,
    this.checkOutTime,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.purpose,
    required this.notes,
    this.photos = const [],
    required this.salesRepId,
    this.isSynced = false,
  });

  Duration? get duration {
    if (checkOutTime != null) {
      return checkOutTime!.difference(checkInTime);
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'customerName': customerName,
      'checkInTime': checkInTime.toIso8601String(),
      'checkOutTime': checkOutTime?.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'purpose': purpose,
      'notes': notes,
      'photos': photos,
      'salesRepId': salesRepId,
      'isSynced': isSynced,
    };
  }

  factory CheckIn.fromJson(Map<String, dynamic> json) {
    return CheckIn(
      id: json['id'] as String,
      customerId: json['customerId'] as String,
      customerName: json['customerName'] as String,
      checkInTime: DateTime.parse(json['checkInTime'] as String),
      checkOutTime: json['checkOutTime'] != null
          ? DateTime.parse(json['checkOutTime'] as String)
          : null,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      address: json['address'] as String,
      purpose: json['purpose'] as String,
      notes: json['notes'] as String,
      photos: (json['photos'] as List?)?.cast<String>() ?? [],
      salesRepId: json['salesRepId'] as String,
      isSynced: json['isSynced'] as bool? ?? false,
    );
  }
}
