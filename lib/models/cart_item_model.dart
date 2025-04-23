import 'package:McDonalds/models/product_model.dart';
import 'package:McDonalds/providers/products_provider.dart';
import 'package:flutter/foundation.dart';

class CartItem {
  final Product product;
  final int quantity;
  final Map<String, Set<String>> selectedExtras;
  final String? uniqueIdentifier; // Nuevo campo para identificación única

  CartItem({
    required this.product,
    required this.quantity,
    required this.selectedExtras,
    this.uniqueIdentifier,
  });

  double calculateTotal(ProductsProvider? provider) {
    double basePrice = product.price * quantity;
    double extrasTotal = 0.0;

    if (provider != null) {
      for (final entry in selectedExtras.entries) {
        final category = entry.key;
        final productIds = entry.value;
        final products = provider.getProductsByCategory(category);

        for (final productId in productIds) {
          final extraProduct = products.firstWhere(
            (p) => p.id == productId,
            orElse: () => product,
          );
          extrasTotal += extraProduct.price;
        }
      }
    }

    return basePrice + (extrasTotal * quantity);
  }

  String getItemId() {
    if (uniqueIdentifier != null) {
      return '${product.id}_$uniqueIdentifier';
    }
    return product.id;
  }

  bool hasSameExtras(CartItem other) {
    if (selectedExtras.length != other.selectedExtras.length) return false;

    for (final category in selectedExtras.keys) {
      final thisExtras = selectedExtras[category];
      final otherExtras = other.selectedExtras[category];

      if (thisExtras == null || otherExtras == null) return false;

      final thisSorted = thisExtras.toList()..sort();
      final otherSorted = otherExtras.toList()..sort();

      if (!listEquals(thisSorted, otherSorted)) return false;
    }

    return true;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartItem &&
        other.product.id == product.id &&
        other.getItemId() == getItemId();
  }

  @override
  int get hashCode => getItemId().hashCode;
}
