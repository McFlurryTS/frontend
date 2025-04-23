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
      // notifyListeners(); // Notificar el inicio de la carga

      List<Product> products = [];

      // Intentar cargar desde caché primero
      final storedProducts = StorageService.getProducts();
      if (storedProducts.isNotEmpty) {
        products = storedProducts;
      } else {
        try {
          products = await _fetchFromApi();
        } catch (apiError) {
          debugPrint('Error al cargar desde API: $apiError');
          // Si falla la API, cargar datos de demostración
          products = _getDemoProducts();
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

  List<Product> _getDemoProducts() {
    // Productos de demostración para cuando falla la API
    final now = DateTime.now();
    return [
      Product(
        id: 'demo1',
        name: 'Big Mac',
        description: 'Hamburguesa clásica con dos carnes',
        price: 89.0,
        image: 'assets/images/bigmac_demo.jpg',
        category: 'A_LA_CARTA_HAMBURGUESAS',
        country: 'MX',
        active: true,
        updated_at: now,
        allergens: ['gluten', 'sésamo'],
      ),
      Product(
        id: 'demo2',
        name: 'McNuggets',
        description: 'Nuggets de pollo',
        price: 79.0,
        image: 'assets/images/nuggets_demo.jpg',
        category: 'A_LA_CARTA_NUGGETS',
        country: 'MX',
        active: true,
        updated_at: now,
        allergens: ['gluten'],
      ),
      Product(
        id: 'demo3',
        name: 'McFlurry Oreo',
        description: 'Helado con galletas Oreo',
        price: 49.0,
        image: 'assets/images/mcflurry_demo.jpg',
        category: 'POSTRES_Y_MALTEADAS',
        country: 'MX',
        active: true,
        updated_at: now,
        allergens: ['leche', 'gluten'],
      ),
      // Agregar productos para las categorías faltantes
      Product(
        id: 'demo4',
        name: 'McTrío Mediano Big Mac',
        description: 'Big Mac + Papas Medianas + Refresco Mediano',
        price: 129.0,
        image: 'assets/images/bigmac_demo.jpg',
        category: 'MCTRIOS_MEDIANOS',
        country: 'MX',
        active: true,
        updated_at: now,
        allergens: ['gluten', 'sésamo'],
      ),
      Product(
        id: 'demo5',
        name: 'McTrío Grande Big Mac',
        description: 'Big Mac + Papas Grandes + Refresco Grande',
        price: 149.0,
        image: 'assets/images/bigmac_demo.jpg',
        category: 'MCTRIOS_GRANDES',
        country: 'MX',
        active: true,
        updated_at: now,
        allergens: ['gluten', 'sésamo'],
      ),
      Product(
        id: 'demo6',
        name: 'Big Mac para llevar',
        description: 'Big Mac exclusivo para recoger',
        price: 79.0,
        image: 'assets/images/bigmac_demo.jpg',
        category: 'EXCLUSIVO_PICKUP',
        country: 'MX',
        active: true,
        updated_at: now,
        allergens: ['gluten', 'sésamo'],
      ),
      Product(
        id: 'demo7',
        name: 'Papas Medianas',
        description: 'Papas fritas medianas',
        price: 45.0,
        image: 'assets/images/papas_demo.jpg',
        category: 'A_LA_CARTA_PAPAS',
        country: 'MX',
        active: true,
        updated_at: now,
        allergens: ['gluten'],
      ),
      Product(
        id: 'demo8',
        name: 'Coca-Cola Mediana',
        description: 'Refresco mediano',
        price: 35.0,
        image: 'assets/images/bebida_demo.jpg',
        category: 'BEBIDAS',
        country: 'MX',
        active: true,
        updated_at: now,
        allergens: [],
      ),
    ];
  }
}
