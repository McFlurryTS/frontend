import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:McDonalds/models/product_model.dart';
import 'package:McDonalds/models/cart_item_model.dart';
import 'package:McDonalds/providers/products_provider.dart';
import 'package:McDonalds/services/notification_service.dart';
import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  final BuildContext context;
  final Map<String, CartItem> _items = {};
  final ProductsProvider _productsProvider;
  static const String _cartKey = 'cart_data';
  static const String _cartTimeKey = 'cart_time';
  static const Duration _expirationDuration = Duration(hours: 6);
  static const Duration _notificationBeforeExpiration = Duration(hours: 1);

  CartProvider(this._productsProvider, this.context) {
    _initCart();
  }

  Future<void> _initCart() async {
    await _loadCartFromPrefs();
    await _checkCartExpiration();
  }

  Map<String, CartItem> get items => {..._items};
  int get itemCount => _items.length;

  double get totalAmount {
    return _items.values.fold(
      0.0,
      (sum, item) => sum + item.calculateTotal(_productsProvider),
    );
  }

  Future<void> extendCartTime() async {
    if (_items.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    await prefs.setString(_cartTimeKey, now.toIso8601String());

    // Programar nueva notificación
    await _scheduleExpirationNotification();

    notifyListeners();
  }

  Future<void> _scheduleExpirationNotification() async {
    if (_items.isEmpty) {
      await NotificationService.cancelCartNotifications();
      return;
    }

    final now = DateTime.now();
    final expirationTime = now.add(_expirationDuration);
    final notificationTime = expirationTime.subtract(
      _notificationBeforeExpiration,
    );

    if (now.isBefore(notificationTime)) {
      await NotificationService.scheduleNotification(
        id: 1,
        title: '¡Tu carrito te espera!',
        body: '¿Aún deseas completar tu orden? Tu carrito expirará en 1 hora.',
        scheduledDate: notificationTime,
      );
    }
  }

  Future<void> _checkCartExpiration() async {
    final prefs = await SharedPreferences.getInstance();
    final cartTime = prefs.getString(_cartTimeKey);

    if (cartTime != null) {
      final savedTime = DateTime.parse(cartTime);
      final now = DateTime.now();
      final timeLeft = _expirationDuration - now.difference(savedTime);

      if (timeLeft.isNegative) {
        await _clearStoredCart();
      } else {
        await _scheduleExpirationNotification();
      }
    }
  }

  Future<void> _loadCartFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartTime = prefs.getString(_cartTimeKey);
      final cartData = prefs.getString(_cartKey);

      if (cartTime != null && cartData != null) {
        final savedTime = DateTime.parse(cartTime);
        final now = DateTime.now();

        if (now.difference(savedTime) > _expirationDuration) {
          await _clearStoredCart();
          return;
        }

        final decodedData = json.decode(cartData) as Map<String, dynamic>;
        _items.clear();

        decodedData.forEach((key, value) {
          final itemData = value as Map<String, dynamic>;
          final product = Product.fromJson(
            itemData['product'] as Map<String, dynamic>,
          );
          final quantity = itemData['quantity'] as int;
          final extras =
              (itemData['selectedExtras'] as Map<String, dynamic>).map(
            (key, value) => MapEntry(
              key,
              (value as List<dynamic>).map((e) => e.toString()).toSet(),
            ),
          );

          _items[key] = CartItem(
            product: product,
            quantity: quantity,
            selectedExtras: extras,
          );
        });

        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading cart: $e');
      await _clearStoredCart();
    }
  }

  Future<void> _saveCartToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      if (_items.isEmpty) {
        await _clearStoredCart();
        return;
      }

      final cartData = _items.map(
        (key, item) => MapEntry(key, {
          'product': item.product.toJson(),
          'quantity': item.quantity,
          'selectedExtras': item.selectedExtras.map(
            (key, value) => MapEntry(key, value.toList()),
          ),
        }),
      );

      final now = DateTime.now();
      await prefs.setString(_cartKey, json.encode(cartData));
      await prefs.setString(_cartTimeKey, now.toIso8601String());
      await _scheduleExpirationNotification();
    } catch (e) {
      debugPrint('Error saving cart: $e');
    }
  }

  Future<void> _clearStoredCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cartKey);
    await prefs.remove(_cartTimeKey);
    await NotificationService.cancelCartNotifications();
    _items.clear();
    notifyListeners();
  }

  // CRUD Operations
  Future<void> addItem(
    Product product,
    int quantity,
    Map<String, Set<String>> selectedExtras,
  ) async {
    // Limpiar extras vacíos
    final cleanedExtras = Map<String, Set<String>>.from(selectedExtras)
      ..removeWhere((_, value) => value.isEmpty);

    // Generar un identificador único basado en timestamp
    final uniqueId = DateTime.now().microsecondsSinceEpoch.toString();

    final newItem = CartItem(
      product: product,
      quantity: quantity,
      selectedExtras: cleanedExtras,
      uniqueIdentifier: uniqueId, // Agregar el identificador único
    );

    // Agregar el nuevo item directamente sin buscar duplicados
    _items[newItem.getItemId()] = newItem;

    await _saveCartToPrefs();
    notifyListeners();
  }

  Future<void> updateItem(
    String oldItemId,
    Product product,
    int quantity,
    Map<String, Set<String>> selectedExtras,
  ) async {
    // Limpiar extras vacíos
    final cleanedExtras = Map<String, Set<String>>.from(selectedExtras)
      ..removeWhere((_, value) => value.isEmpty);

    // Mantener el uniqueIdentifier del item original si existe
    final originalItem = _items[oldItemId];
    final uniqueId = originalItem?.uniqueIdentifier;

    // Actualizar solo el item específico
    final updatedItem = CartItem(
      product: product,
      quantity: quantity,
      selectedExtras: cleanedExtras,
      uniqueIdentifier: uniqueId, // Mantener el mismo identificador si existía
    );

    // Actualizar solo el item específico sin buscar similares
    _items[oldItemId] = updatedItem;

    await _saveCartToPrefs();
    notifyListeners();
  }

  Future<void> removeItem(String itemId) async {
    _items.remove(itemId);
    await _saveCartToPrefs();
    notifyListeners();
  }

  Future<void> clear() async {
    await _clearStoredCart();
  }

  CartItem? getItemById(String itemId) {
    return _items[itemId];
  }
}
