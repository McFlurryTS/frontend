import 'package:hive/hive.dart';
import 'package:flutter/foundation.dart';

part 'location_model.g.dart';

@HiveType(typeId: 4)
class LocationModel {
  @HiveField(0)
  final String? address;

  @HiveField(1)
  final String? type;

  @HiveField(2)
  final DateTime savedAt;

  LocationModel({this.address, this.type, required this.savedAt});

  bool isExpired() {
    final now = DateTime.now();
    final difference = now.difference(savedAt);
    debugPrint(
      'Tiempo transcurrido desde que se guardó la ubicación: ${difference.inHours} horas',
    );
    return difference.inHours >= 24;
  }

  @override
  String toString() {
    return 'LocationModel(address: $address, type: $type, savedAt: $savedAt)';
  }
}
