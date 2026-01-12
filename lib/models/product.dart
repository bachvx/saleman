class Product {
  final String id;
  final String name;
  final String description;
  final String category;
  final String sku;
  final String barcode;
  final double price;
  final double costPrice;
  final int stockQuantity;
  final String unit; // Piece, Box, Carton, etc.
  final String imageUrl;
  final bool isActive;
  final double discount; // Percentage
  final DateTime createdAt;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.sku,
    required this.barcode,
    required this.price,
    required this.costPrice,
    required this.stockQuantity,
    required this.unit,
    this.imageUrl = '',
    this.isActive = true,
    this.discount = 0.0,
    required this.createdAt,
  });

  double get finalPrice => price - (price * discount / 100);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'sku': sku,
      'barcode': barcode,
      'price': price,
      'costPrice': costPrice,
      'stockQuantity': stockQuantity,
      'unit': unit,
      'imageUrl': imageUrl,
      'isActive': isActive,
      'discount': discount,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      sku: json['sku'] as String,
      barcode: json['barcode'] as String,
      price: (json['price'] as num).toDouble(),
      costPrice: (json['costPrice'] as num).toDouble(),
      stockQuantity: json['stockQuantity'] as int,
      unit: json['unit'] as String,
      imageUrl: json['imageUrl'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? true,
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Product copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    String? sku,
    String? barcode,
    double? price,
    double? costPrice,
    int? stockQuantity,
    String? unit,
    String? imageUrl,
    bool? isActive,
    double? discount,
    DateTime? createdAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      sku: sku ?? this.sku,
      barcode: barcode ?? this.barcode,
      price: price ?? this.price,
      costPrice: costPrice ?? this.costPrice,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      unit: unit ?? this.unit,
      imageUrl: imageUrl ?? this.imageUrl,
      isActive: isActive ?? this.isActive,
      discount: discount ?? this.discount,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
