import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:McDonalds/models/product_model.dart';

class ProductsProvider with ChangeNotifier {
  final String baseUrl = 'http://192.168.1.71:3000';
  final Map<String, List<Product>> _productsByCategory = {};
  final Map<String, bool> _loadingStates = {};
  final Map<String, String?> _errorStates = {};

  bool isLoadingCategory(String category) => _loadingStates[category] ?? false;
  String? getErrorForCategory(String category) => _errorStates[category];
  List<Product> getProductsByCategory(String category) =>
      _productsByCategory[category] ?? [];

  Future<void> fetchProductsByCategory(String category) async {
    if (_loadingStates[category] == true) return;

    try {
      _loadingStates[category] = true;
      //notifyListeners();

      // Forzar un mínimo de tiempo de carga para mejor UX
      final results = await Future.wait([
        http.get(Uri.parse('$baseUrl/$category')),
        Future.delayed(
          const Duration(milliseconds: 800),
        ), // Aumentado para mejor efecto visual
      ]);

      final response = results[0] as http.Response;
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _productsByCategory[category] =
            data.map((json) => Product.fromJson(json)).toList();
        _errorStates[category] = null;
      } else {
        _errorStates[category] = 'Error ${response.statusCode}';
      }
    } catch (e) {
      _errorStates[category] = e.toString();
    } finally {
      _loadingStates[category] = false;
      notifyListeners();
    }
  }
}
