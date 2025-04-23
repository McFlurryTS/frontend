import 'package:flutter/material.dart';
import 'package:McDonalds/models/category_model.dart';
import 'package:McDonalds/providers/products_provider.dart';

class CategoriesProvider with ChangeNotifier {
  final List<MenuCategory> _categories = [];
  bool _isLoading = true; // Cambiado a true por defecto
  String? _error;

  List<MenuCategory> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Categorías desde el JSON
  static const List<Map<String, String>> categoryDefinitions = [
    {'id': 'PROMOCIONES', 'name': 'Promociones'},
    {'id': 'DESAYUNOS', 'name': 'Desayunos'},
    {'id': 'A_LA_CARTA_PAPAS', 'name': 'Papas a la carta'},
    {'id': 'A_LA_CARTA_HAMBURGUESAS', 'name': 'Hamburguesas a la carta'},
    {'id': 'A_LA_CARTA_NUGGETS', 'name': 'Nuggets a la carta'},
    {'id': 'BEBIDAS', 'name': 'Bebidas'},
    {'id': 'CAJITA_FELIZ', 'name': 'Cajita Feliz'},
    {'id': 'EXCLUSIVOS_PICKUP', 'name': 'Exclusivo Pickup'},
    {'id': 'FAMILY_BOX', 'name': 'Family Box'},
    {'id': 'MCTRIO_MEDIANO', 'name': 'McTríos Medianos'},
    {'id': 'MCTRIO_GRANDE', 'name': 'McTríos Grandes'},
    {'id': 'MCTRIO_3X3', 'name': 'McTrío 3x3'},
    {'id': 'POSTRES_Y_MALTEADAS', 'name': 'Postres y Malteadas'},
    {'id': 'TU_FAV_99', 'name': 'Tu Fav x \$99 pesos'},
    {'id': 'A_LA_CARTA_COMIDA', 'name': 'A la Carta Comida'},
  ];

  Future<void> generateCategoriesFromProducts(
    ProductsProvider productsProvider,
  ) async {
    if (_isLoading && _categories.isNotEmpty) return;

    _isLoading = true;
    _error = null;
    notifyListeners(); // Notificar el inicio de la carga

    try {
      final List<MenuCategory> newCategories = [];

      // Procesar primero las categorías más importantes
      for (final def in categoryDefinitions) {
        final id = def['id']!;
        final name = def['name']!;
        final products = productsProvider.getProductsByCategory(id);

        if (products.isNotEmpty) {
          final imageUrl = products.first.image;
          newCategories.add(
            MenuCategory(id: id, name: name, imageUrl: imageUrl),
          );
        }
      }

      _categories.clear();
      _categories.addAll(newCategories);
    } catch (e) {
      _error = 'Error al generar categorías: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  MenuCategory getCategoryById(String id) {
    return _categories.firstWhere((cat) => cat.id == id);
  }
}
