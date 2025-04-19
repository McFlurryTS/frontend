import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:McDonalds/models/product_model.dart';
import 'package:McDonalds/services/storage_service.dart';
import 'package:McDonalds/services/image_cache_service.dart';

class ProductsProvider with ChangeNotifier {
  final String baseUrl = 'http://192.168.1.71:3000';
  final Map<String, List<Product>> _productsByCategory = {};
  bool _isLoading = false;
  String? _error;
  bool _isInitialized = false;

  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, List<Product>> get productsByCategory => _productsByCategory;
  bool get isInitialized => _isInitialized;

  Future<void> fetchMenuCompleto() async {
    if (_isLoading) return; // Evitar múltiples cargas simultáneas

    try {
      _isLoading = true;
      // Solo notificar al inicio si no tenemos datos
      if (_productsByCategory.isEmpty) {
        // notifyListeners();
      }

      // Intentar obtener datos locales primero
      List<Product> products = [];

      if (StorageService.shouldRefreshCache()) {
        products = await _fetchFromApi();
      } else {
        products = StorageService.getProducts() ?? await _fetchFromApi();
      }

      // Organizar productos por categoría
      _productsByCategory.clear();
      for (var product in products) {
        if (!_productsByCategory.containsKey(product.category)) {
          _productsByCategory[product.category] = [];
        }
        _productsByCategory[product.category]!.add(product);
      }

      // Precarga de imágenes en segundo plano
      _preloadImages(products);

      _isLoading = false;
      _isInitialized = true;
      _error = null;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
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
      final response = await http.get(Uri.parse('$baseUrl/menu_completo'));
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
