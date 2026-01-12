class Order {
  final String id;
  final String customerId;
  final String customerName;
  final List<OrderItem> items;
  final double subtotal;
  final double discount;
  final double tax;
  final double total;
  final String status; // Pending, Confirmed, Shipped, Delivered, Cancelled
  final String paymentStatus; // Unpaid, Partial, Paid
  final String paymentMethod; // Cash, Card, Credit, Online
  final DateTime orderDate;
  final DateTime? deliveryDate;
  final String notes;
  final String salesRepId;
  final bool isSynced;

  Order({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.items,
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.total,
    required this.status,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.orderDate,
    this.deliveryDate,
    required this.notes,
    required this.salesRepId,
    this.isSynced = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'customerName': customerName,
      'items': items.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'discount': discount,
      'tax': tax,
      'total': total,
      'status': status,
      'paymentStatus': paymentStatus,
      'paymentMethod': paymentMethod,
      'orderDate': orderDate.toIso8601String(),
      'deliveryDate': deliveryDate?.toIso8601String(),
      'notes': notes,
      'salesRepId': salesRepId,
      'isSynced': isSynced,
    };
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      customerId: json['customerId'] as String,
      customerName: json['customerName'] as String,
      items: (json['items'] as List)
          .map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      subtotal: (json['subtotal'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      tax: (json['tax'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      status: json['status'] as String,
      paymentStatus: json['paymentStatus'] as String,
      paymentMethod: json['paymentMethod'] as String,
      orderDate: DateTime.parse(json['orderDate'] as String),
      deliveryDate: json['deliveryDate'] != null
          ? DateTime.parse(json['deliveryDate'] as String)
          : null,
      notes: json['notes'] as String,
      salesRepId: json['salesRepId'] as String,
      isSynced: json['isSynced'] as bool? ?? false,
    );
  }
}

class OrderItem {
  final String productId;
  final String productName;
  final int quantity;
  final double unitPrice;
  final double discount;
  final double total;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    this.discount = 0.0,
    required this.total,
  });

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'discount': discount,
      'total': total,
    };
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      quantity: json['quantity'] as int,
      unitPrice: (json['unitPrice'] as num).toDouble(),
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      total: (json['total'] as num).toDouble(),
    );
  }
}
