class Product {
  final String id;
  final String categoryId;
  final String name;
  final String description;
  final String? weight;
  final String? calories;
  final String? caloriesPercentage;
  final String? proteins;
  final String? proteinsPercentage;
  final String? carbohydrates;
  final String? carbohydratesPercentage;
  final String? lipids;
  final String? lipidsPercentage;
  final String? sodium;
  final String? sodiumPercentage;
  final String? fiber;
  final String? fiberPercentage;
  final String? saturatedFats;
  final String? saturatedFatsPercentage;
  final String? transFats;
  final String? transFatsPercentage;
  final String? sugarTotals;
  final String image;
  final String country;
  final bool hideExtraInfo;
  final String urlPdf;
  final bool active;
  final List<String> allergens;
  final DateTime updatedAt;
  final double price; // Agregar precio base

  Product({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.description,
    this.weight,
    this.calories,
    this.caloriesPercentage,
    this.proteins,
    this.proteinsPercentage,
    this.carbohydrates,
    this.carbohydratesPercentage,
    this.lipids,
    this.lipidsPercentage,
    this.sodium,
    this.sodiumPercentage,
    this.fiber,
    this.fiberPercentage,
    this.saturatedFats,
    this.saturatedFatsPercentage,
    this.transFats,
    this.transFatsPercentage,
    this.sugarTotals,
    required this.image,
    required this.country,
    required this.hideExtraInfo,
    required this.urlPdf,
    required this.active,
    required this.allergens,
    required this.updatedAt,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      categoryId: json['category'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      weight: json['weight']?.toString(),
      calories: json['calories']?.toString(),
      caloriesPercentage: json['caloriesPercentage']?.toString(),
      proteins: json['proteins']?.toString(),
      proteinsPercentage: json['proteinsPercentage']?.toString(),
      carbohydrates: json['carbohydrates']?.toString(),
      carbohydratesPercentage: json['carbohydratesPercentage']?.toString(),
      lipids: json['lipids']?.toString(),
      lipidsPercentage: json['lipidsPercentage']?.toString(),
      sodium: json['sodium']?.toString(),
      sodiumPercentage: json['sodiumPercentage']?.toString(),
      fiber: json['fiber']?.toString(),
      fiberPercentage: json['fiberPercentage']?.toString(),
      saturatedFats: json['saturatedFats']?.toString(),
      saturatedFatsPercentage: json['saturatedFatsPercentage']?.toString(),
      transFats: json['transFats']?.toString(),
      transFatsPercentage: json['transFatsPercentage']?.toString(),
      sugarTotals: json['sugarTotals']?.toString(),
      image: json['image'] as String,
      country: json['country'] as String,
      hideExtraInfo: json['hideExtraInfo'] as bool,
      urlPdf: json['urlPdf'] as String,
      active: json['active'] as bool,
      allergens: List<String>.from(json['allergens'] ?? []),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      price:
          json['price'] != null
              ? (json['price'] as num).toDouble()
              : json['price_base'] != null
              ? (json['price_base'] as num).toDouble()
              : 155.0, // Precio por defecto
    );
  }
}
