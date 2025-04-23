import 'package:hive/hive.dart';

part 'product_model.g.dart';

@HiveType(typeId: 0)
class Product extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String category;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final String image;

  @HiveField(6)
  final String country;

  @HiveField(7)
  final bool active;

  @HiveField(8)
  final DateTime updated_at;

  @HiveField(9)
  final double price;

  @HiveField(10)
  final List<String> allergens;

  Product({
    required this.id,
    required this.category,
    required this.name,
    required this.description,
    required this.image,
    required this.country,
    required this.active,
    required this.updated_at,
    required this.price,
    this.allergens = const [],
  });

  bool get hasAllergens => allergens.isNotEmpty;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      category: json['category'] as String,
      name: json['name'] as String,
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      country: json['country'] ?? 'MX',
      active: json['active'] ?? true,
      updated_at: DateTime.parse(json['updated_at']),
      price:
          double.tryParse(
            json['price'].toString().replaceAll('\$', '').trim(),
          ) ??
          0.0,
      allergens:
          json['allergens'] != null
              ? List<String>.from(json['allergens'])
              : const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'name': name,
      'description': description,
      'image': image,
      'country': country,
      'active': active,
      'updated_at': updated_at.toIso8601String(),
      'price': price,
      'allergens': allergens,
    };
  }
}
