import 'package:google_maps_flutter/google_maps_flutter.dart';

class StoreLocation {
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String? additionalInfo;

  const StoreLocation({
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.additionalInfo,
  });

  LatLng get latLng => LatLng(latitude, longitude);

  Map<String, dynamic> toJson() => {
    'name': name,
    'address': address,
    'latitude': latitude,
    'longitude': longitude,
    'additionalInfo': additionalInfo,
  };

  factory StoreLocation.fromJson(Map<String, dynamic> json) => StoreLocation(
    name: json['name'] as String,
    address: json['address'] as String,
    latitude: json['latitude'] as double,
    longitude: json['longitude'] as double,
    additionalInfo: json['additionalInfo'] as String?,
  );
}

class LocationModel {
  final String? address;
  final String? type;
  final DateTime savedAt;
  final StoreLocation? selectedStore;

  LocationModel({
    this.address,
    this.type,
    required this.savedAt,
    this.selectedStore,
  });

  bool isExpired() {
    final now = DateTime.now();
    final expirationTime = const Duration(hours: 24);
    return now.difference(savedAt) > expirationTime;
  }

  Map<String, dynamic> toJson() => {
    'address': address,
    'type': type,
    'savedAt': savedAt.toIso8601String(),
    'selectedStore': selectedStore?.toJson(),
  };

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
    address: json['address'] as String?,
    type: json['type'] as String?,
    savedAt: DateTime.parse(json['savedAt'] as String),
    selectedStore:
        json['selectedStore'] != null
            ? StoreLocation.fromJson(
              json['selectedStore'] as Map<String, dynamic>,
            )
            : null,
  );

  @override
  String toString() =>
      'LocationModel(address: $address, type: $type, savedAt: $savedAt)';
}
