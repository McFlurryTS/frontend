import 'package:hive_flutter/hive_flutter.dart';

part 'survey_model.g.dart';

@HiveType(typeId: 2)
class Survey extends HiveObject {
  @HiveField(0)
  final List<String> favoriteProducts;

  @HiveField(1)
  final String favoriteDessert;

  @HiveField(2)
  final String preferredGift;

  @HiveField(3)
  final List<String> purchaseFor;

  @HiveField(4)
  final List<String> favoriteFlavors;

  @HiveField(5)
  final String visitObstacle;

  @HiveField(6)
  final List<String> preferredSurprises;

  @HiveField(7)
  final String preferredSide;

  Survey({
    required this.favoriteProducts,
    required this.favoriteDessert,
    required this.preferredGift,
    required this.purchaseFor,
    required this.favoriteFlavors,
    required this.visitObstacle,
    required this.preferredSurprises,
    required this.preferredSide,
  });

  Map<String, dynamic> toJson() {
    return {
      'favoriteProducts': favoriteProducts,
      'favoriteDessert': favoriteDessert,
      'preferredGift': preferredGift,
      'purchaseFor': purchaseFor,
      'favoriteFlavors': favoriteFlavors,
      'visitObstacle': visitObstacle,
      'preferredSurprises': preferredSurprises,
      'preferredSide': preferredSide,
    };
  }
}
