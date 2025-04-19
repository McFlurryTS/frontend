import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:McDonalds/models/product_model.dart';
import 'package:McDonalds/services/storage_service.dart';
import 'package:McDonalds/services/image_cache_service.dart';

class ProductsProvider with ChangeNotifier {
  final String baseUrl = 'http://54.236.59.113';
  final Map<String, List<Product>> _productsByCategory = {};
  bool _isLoading = true; // Cambiado a true por defecto
  String? _error;
  bool _isInitialized = false;
  bool _hasError = false;

  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, List<Product>> get productsByCategory => _productsByCategory;
  bool get isInitialized => _isInitialized;
  bool get hasError => _hasError;

  Future<void> fetchMenuCompleto() async {
    if (_isLoading && _isInitialized) return;

    try {
      _isLoading = true;
      _hasError = false;
      _error = null;
      notifyListeners(); // Notificar el inicio de la carga

      List<Product> products = [];

      if (StorageService.shouldRefreshCache()) {
        products = await _fetchFromApi();
      } else {
        final storedProducts = StorageService.getProducts();
        if (storedProducts.isEmpty) {
          products = await _fetchFromApi();
        } else {
          products = storedProducts;
        }
      }

      _productsByCategory.clear();
      for (var product in products) {
        if (!_productsByCategory.containsKey(product.category)) {
          _productsByCategory[product.category] = [];
        }
        _productsByCategory[product.category]!.add(product);
      }

      await _preloadImages(products);

      _isLoading = false;
      _isInitialized = true;
      _hasError = false;
      _error = null;
    } catch (e) {
      _isLoading = false;
      _hasError = true;
      _error = 'Error al cargar el menú. Por favor, intenta de nuevo.';
      debugPrint('Error en fetchMenuCompleto: $e');
    }
    notifyListeners();
  }

  Future<void> retryLoading() async {
    await fetchMenuCompleto();
  }

  Future<void> _preloadImages(List<Product> products) async {
    try {
      final allImages = products.map((p) => p.image).toList();
      await ImageCacheService.preloadImages(allImages);
    } catch (e) {
      debugPrint('Error precargando imágenes: $e');
    }
  }

  Future<List<Product>> _fetchFromApi() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/menu_completo'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> rawProducts = data['menu'];
        final products =
            rawProducts.map((item) => Product.fromJson(item)).toList();

        await StorageService.saveProducts(products);
        return products;
      } else {
        throw Exception('Error al cargar productos desde la API');
      }
    } catch (e) {
      throw Exception('Error de red: $e');
    }
  }

  List<Product> getProductsByCategory(String category) {
    return _productsByCategory[category] ?? [];
  }
}
