import 'package:McDonalds/models/product_model.dart';

class CartItem {
  final Product product;
  final int quantity;
  final Map<String, Set<String>> selectedExtras;

  CartItem({
    required this.product,
    required this.quantity,
    required this.selectedExtras,
  });

  double get total {
    double basePrice = product.price * quantity;
    double extrasTotal = 0.0;

    // Calcular el total de los extras seleccionados
    selectedExtras.forEach((category, productIds) {
      for (final productId in productIds) {
        // Aquí deberías obtener el precio del producto extra
        // Por ahora usamos un valor fijo como placeholder
        extrasTotal += 10.0; // Reemplazar con el precio real del extra
      }
    });

    return basePrice + (extrasTotal * quantity);
  }
}
