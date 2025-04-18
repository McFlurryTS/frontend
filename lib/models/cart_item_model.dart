class CartItem {
  final String id;
  final String productId;
  final String name;
  final double price;
  final String image;
  final int quantity;
  final Map<String, String> extras;

  CartItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
    required this.image,
    required this.quantity,
    required this.extras,
  });

  double get total => price * quantity;

  CartItem copyWith({
    String? id,
    String? productId,
    String? name,
    double? price,
    String? image,
    int? quantity,
    Map<String, String>? extras,
  }) {
    return CartItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      price: price ?? this.price,
      image: image ?? this.image,
      quantity: quantity ?? this.quantity,
      extras: extras ?? this.extras,
    );
  }
}
