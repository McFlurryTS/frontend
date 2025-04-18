import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';

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
    Map<String, String> selectedExtras,
  ) {
    if (_items.containsKey(product.id)) {
      // Actualizar item existente
      _items.update(
        product.id,
        (existingItem) => existingItem.copyWith(
          quantity: existingItem.quantity + quantity,
          extras: selectedExtras,
        ),
      );
    } else {
      // Agregar nuevo item
      _items.putIfAbsent(
        product.id,
        () => CartItem(
          id: const Uuid().v4(),
          productId: product.id,
          name: product.name,
          price: product.price,
          image: product.image,
          quantity: quantity,
          extras: selectedExtras,
        ),
      );
    }
    notifyListeners();
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
