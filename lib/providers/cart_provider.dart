import 'package:flutter/foundation.dart';
import 'package:McDonalds/models/product_model.dart';
import 'package:McDonalds/models/cart_item_model.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};
  int get itemCount => _items.length;

  double get totalAmount {
    return _items.values.fold(0.0, (sum, item) => sum + item.total);
  }

  void addItem(
    Product product,
    int quantity,
    Map<String, Set<String>> selectedExtras,
  ) {
    // Crear un ID único basado en el producto y sus extras seleccionados
    final String itemId = _generateItemId(product.id, selectedExtras);

    // Si el item ya existe, actualizar cantidad
    if (_items.containsKey(itemId)) {
      _items.update(
        itemId,
        (existingItem) => CartItem(
          product: product,
          quantity: existingItem.quantity + quantity,
          selectedExtras: Map<String, Set<String>>.from(selectedExtras),
        ),
      );
    } else {
      // Si no existe, agregar nuevo item
      _items.putIfAbsent(
        itemId,
        () => CartItem(
          product: product,
          quantity: quantity,
          selectedExtras: Map<String, Set<String>>.from(selectedExtras),
        ),
      );
    }

    notifyListeners();
  }

  String _generateItemId(
    String productId,
    Map<String, Set<String>> selectedExtras,
  ) {
    // Crear un string único basado en el ID del producto y los extras seleccionados
    final buffer = StringBuffer(productId);
    final sortedCategories = selectedExtras.keys.toList()..sort();

    for (final category in sortedCategories) {
      final products = selectedExtras[category]!.toList()..sort();
      buffer.write('_${category}_${products.join('_')}');
    }

    return buffer.toString();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
