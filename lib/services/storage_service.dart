import 'package:hive_flutter/hive_flutter.dart';
import 'package:McDonalds/models/product_model.dart';
import 'package:McDonalds/models/onboarding_form.dart';
import 'package:McDonalds/models/location_model.dart';
import 'package:flutter/material.dart';

class StorageService {
  static late Box<Product> _productsBox;
  static late Box<String> _metaBox;
  static late Box<OnboardingForm> _onboardingBox;
  static late Box<LocationModel> _locationBox;
  static const String _lastUpdateKey = 'last_update';
  static const Duration _cacheValidity = Duration(hours: 24);
  static const String _onboardingBoxName = 'onboarding';
  static const String _onboardingFormKey = 'form';
  static const String _locationKey = 'user_location';

  static Future<void> init() async {
    await Hive.initFlutter();

    // Registrar adaptadores solo si no están ya registrados
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ProductAdapter());
    }

    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(OnboardingFormAdapter());
    }

    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(LocationModelAdapter());
    }

    _productsBox = await Hive.openBox<Product>('products');
    _metaBox = await Hive.openBox<String>('meta');
    _onboardingBox = await Hive.openBox<OnboardingForm>(_onboardingBoxName);
    _locationBox = await Hive.openBox<LocationModel>('location_box');
    // Ya no es necesario abrir la caja 'onboarding' dos veces
  }

  static List<Product> getProducts() {
    return _productsBox.values.toList();
  }

  static Future<void> saveProducts(List<Product> products) async {
    await _productsBox.clear();
    await _productsBox.addAll(products);
    await _metaBox.put(_lastUpdateKey, DateTime.now().toIso8601String());
  }

  static bool shouldRefreshCache() {
    final lastUpdate = _metaBox.get(_lastUpdateKey);
    if (lastUpdate == null) return true;

    final lastUpdateTime = DateTime.parse(lastUpdate);
    return DateTime.now().difference(lastUpdateTime) > _cacheValidity;
  }

  static bool hasLocalData() {
    return _productsBox.isNotEmpty;
  }

  static Future<void> clearCache() async {
    await _productsBox.clear();
    await _metaBox.clear();
  }

  static Future<void> saveOnboardingForm(OnboardingForm form) async {
    await _onboardingBox.put(_onboardingFormKey, form);
  }

  static OnboardingForm? getOnboardingForm() {
    return _onboardingBox.get(_onboardingFormKey);
  }

  static Future<void> clearOnboardingForm() async {
    await _onboardingBox.delete(_onboardingFormKey);
  }

  static Future<void> saveLocation(LocationModel location) async {
    debugPrint('Guardando ubicación: ${location.toString()}');
    await _locationBox.put(_locationKey, location);
  }

  static LocationModel? getLocation() {
    debugPrint('Verificando ubicación guardada...');
    final location = _locationBox.get(_locationKey);
    debugPrint('Ubicación encontrada: ${location?.toString()}');

    if (location != null) {
      final isExpired = location.isExpired();
      debugPrint('¿Ubicación expirada?: $isExpired');
      if (isExpired) {
        _locationBox.delete(_locationKey);
        return null;
      }
    }
    return location;
  }

  static Future<void> clearLocation() async {
    await _locationBox.delete(_locationKey);
  }
}
