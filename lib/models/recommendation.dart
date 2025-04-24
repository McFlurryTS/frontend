class Recommendation {
  final String id;
  final String message;
  final String category;
  final List<ProductOption> options;

  Recommendation({
    required this.id,
    required this.message,
    required this.category,
    required this.options,
  });

  factory Recommendation.fromJson(Map<String, dynamic> json) {
    return Recommendation(
      id: json['id']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      options:
          (json['options'] as List?)
              ?.map(
                (option) =>
                    ProductOption.fromJson(option as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }
}

class ProductOption {
  final String id;
  final String name;
  final String description;
  final String image;
  final double price;

  ProductOption({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
  });

  factory ProductOption.fromJson(Map<String, dynamic> json) {
    return ProductOption(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
    );
  }
}
