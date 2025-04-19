class CartItem {
  final String id;
  final String productId;
  final String name;
  final double price;
  final String imageUrl;
  final int quantity;
  final String farmerName;
  final double weight;
  final String unit;
  final bool isNegotiated;

  CartItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.quantity,
    required this.farmerName,
    required this.weight,
    required this.unit,
    this.isNegotiated = false,
  });

  double get total => price * quantity;
  double get totalWeight => weight * quantity;

  CartItem copyWith({
    String? id,
    String? productId,
    String? name,
    double? price,
    String? imageUrl,
    int? quantity,
    String? farmerName,
    double? weight,
    String? unit,
    bool? isNegotiated,
  }) {
    return CartItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      quantity: quantity ?? this.quantity,
      farmerName: farmerName ?? this.farmerName,
      weight: weight ?? this.weight,
      unit: unit ?? this.unit,
      isNegotiated: isNegotiated ?? this.isNegotiated,
    );
  }
} 