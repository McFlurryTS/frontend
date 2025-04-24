import 'package:hive_flutter/hive_flutter.dart';
import 'package:McDonalds/models/product_model.dart';
import 'package:McDonalds/models/onboarding_form.dart';
import 'package:McDonalds/models/location_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StorageService {
  static late Box<Product> _productsBox;
  static late Box<String> _metaBox;
  static late Box<OnboardingForm> _onboardingBox;
  static const String _lastUpdateKey = 'last_update';
  static const Duration _cacheValidity = Duration(hours: 24);
  static const String _onboardingBoxName = 'onboarding';
  static const String _onboardingFormKey = 'form';
  static const String _locationKey = 'user_location';
  static const String _authKey = 'auth_data';

  static Future<void> init() async {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ProductAdapter());
    }

    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(OnboardingFormAdapter());
    }

    _productsBox = await Hive.openBox<Product>('products');
    _metaBox = await Hive.openBox<String>('meta');
    _onboardingBox = await Hive.openBox<OnboardingForm>(_onboardingBoxName);
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

  // Métodos actualizados para usar SharedPreferences
  static Future<void> saveLocation(LocationModel location) async {
    debugPrint('Guardando ubicación: ${location.toString()}');
    final prefs = await SharedPreferences.getInstance();
    final locationJson = jsonEncode(location.toJson());
    await prefs.setString(_locationKey, locationJson);
  }

  static Future<LocationModel?> getLocation() async {
    debugPrint('Verificando ubicación guardada...');
    final prefs = await SharedPreferences.getInstance();
    final locationJson = prefs.getString(_locationKey);

    if (locationJson != null) {
      final location = LocationModel.fromJson(jsonDecode(locationJson));
      debugPrint('Ubicación encontrada: ${location.toString()}');

      if (location.isExpired()) {
        debugPrint('Ubicación expirada, eliminando...');
        await clearLocation();
        return null;
      }
      return location;
    }
    return null;
  }

  static Future<void> clearLocation() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_locationKey);
  }

  static Future<void> saveAuthData(String token, String tokenType) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _authKey,
      json.encode({
        'token': token,
        'token_type': tokenType,
        'saved_at': DateTime.now().toIso8601String(),
      }),
    );
  }

  static Future<Map<String, String>?> getAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    final authDataString = prefs.getString(_authKey);

    if (authDataString != null) {
      final authData = json.decode(authDataString) as Map<String, dynamic>;
      return {
        'token': authData['token'] as String,
        'token_type': authData['token_type'] as String,
      };
    }
    return null;
  }

  static Future<void> clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_authKey);
  }
}
