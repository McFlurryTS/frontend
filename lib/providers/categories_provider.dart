import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:McDonalds/models/category_model.dart';
import 'package:McDonalds/models/product_model.dart';

class CategoriesProvider with ChangeNotifier {
  final String baseUrl = 'http://192.168.1.71:3000';
  List<MenuCategory> _categories = [];
  bool _isLoading = false;
  String? _error;

  List<MenuCategory> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Definición estática de categorías disponibles
  static const List<Map<String, String>> categoryDefinitions = [
    {'id': 'desayunos', 'name': 'Desayunos', 'endpoint': 'desayunos'},
    {'id': 'hamburguesas', 'name': 'Hamburguesas', 'endpoint': 'hamburguesas'},
    {'id': 'pollo', 'name': 'Pollo', 'endpoint': 'pollo'},
    {'id': 'postres', 'name': 'Postres', 'endpoint': 'postres'},
    {
      'id': 'acompanamientos',
      'name': 'Complementos',
      'endpoint': 'acompanamientos',
    },
    {'id': 'bebidas', 'name': 'Bebidas', 'endpoint': 'bebidas'},
  ];

  Future<void> fetchCategories() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _categories = [];

      for (final catDef in categoryDefinitions) {
        final response = await http.get(
          Uri.parse('$baseUrl/${catDef['endpoint']}'),
          headers: {'Accept': 'application/json'},
        );

        if (response.statusCode == 200) {
          final List<dynamic> responseData = json.decode(response.body);
          if (responseData.isNotEmpty) {
            // Parsear el primer producto para obtener la imagen
            final firstProduct = Product.fromJson(responseData.first);

            _categories.add(
              MenuCategory(
                id: catDef['id']!,
                name: catDef['name']!,
                imageUrl: firstProduct.image,
                endpoint: catDef['endpoint']!,
              ),
            );
          }
        } else {
          throw Exception(
            'Error al cargar ${catDef['name']}: ${response.statusCode}',
          );
        }
      }
    } catch (e) {
      _error = 'Error al cargar categorías: ${e.toString()}';
      _loadDefaultCategories();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _loadDefaultCategories() {
    _categories =
        categoryDefinitions.map((catDef) {
          return MenuCategory(
            id: catDef['id']!,
            name: catDef['name']!,
            imageUrl:
                'https://cdn.pixabay.com/photo/2014/10/23/18/05/burger-500054_1280.jpg',
            endpoint: catDef['endpoint']!,
          );
        }).toList();
  }

  MenuCategory getCategoryById(String id) {
    return _categories.firstWhere((cat) => cat.id == id);
  }
}
