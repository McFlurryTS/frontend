import 'package:McDonalds/screens/confirm_purchase_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:McDonalds/providers/cart_provider.dart';
import 'package:McDonalds/providers/products_provider.dart';
import 'package:McDonalds/utils/rocket_theme.dart';
import 'package:McDonalds/widgets/optimized_image.dart';
import 'package:McDonalds/widgets/confirmation_dialog.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  Future<bool> _confirmDelete(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder:
              (context) => const ConfirmationDialog(
                title: '¿Eliminar este producto?',
                confirmText: 'Eliminar',
                icon: Icons.delete_outline,
                iconColor: Colors.red,
              ),
        ) ??
        false;
  }

  Future<bool> _confirmPurchase(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder:
              (context) => const ConfirmationDialog(
                title: '¿Confirmar pedido?',
                subtitle:
                    'Tu pedido será preparado y enviado a la dirección seleccionada.',
                confirmText: 'Confirmar',
                icon: Icons.shopping_bag_outlined,
                iconColor: Color(0xFFDA291C),
              ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: RocketColors.background,
      appBar: AppBar(
        title: Text(
          'Mi Carrito',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFFDA291C),
        foregroundColor: Colors.white,
      ),
      body: Consumer2<CartProvider, ProductsProvider>(
        builder: (context, cartProvider, productsProvider, _) {
          final items = cartProvider.items;

          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: size.width * 0.15,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: size.height * 0.02),
                  Text(
                    'Tu carrito está vacío',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Agrega productos para comenzar',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pushNamed(context, '/menu'),
                    icon: const Icon(Icons.menu),
                    label: const Text('Ver Menú'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: RocketColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(size.width * 0.04),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final cartItem = items.values.elementAt(index);
                    final total = cartItem.calculateTotal(productsProvider);
                    return Card(
                      margin: EdgeInsets.only(bottom: size.height * 0.015),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        onTap:
                            () => Navigator.pushNamed(
                              context,
                              '/product_detail',
                              arguments: {
                                'product': cartItem.product,
                                'cartItem': cartItem,
                              },
                            ),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: EdgeInsets.all(size.width * 0.03),
                          child: Row(
                            children: [
                              SizedBox(
                                width: size.width * 0.2,
                                height: size.width * 0.2,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: OptimizedImage(
                                    imageUrl: cartItem.product.image,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(width: size.width * 0.03),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      cartItem.product.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Cantidad: ${cartItem.quantity}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    if (cartItem.selectedExtras.isNotEmpty) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        'Extras: ${cartItem.selectedExtras.values.expand((e) => e).length}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '\$${total.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFFDA291C),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      if (await _confirmDelete(context)) {
                                        cartProvider.removeItem(
                                          cartItem.getItemId(),
                                        );
                                      }
                                    },
                                    icon: const Icon(Icons.delete_outline),
                                    color: Colors.grey[600],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.all(size.width * 0.04),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '\$${items.values.fold<double>(0, (sum, item) => sum + item.calculateTotal(productsProvider)).toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFDA291C),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.02),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed:
                                  () => Navigator.of(
                                    context,
                                  ).pushNamedAndRemoveUntil(
                                    '/',
                                    (route) => false,
                                  ),
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  vertical: size.height * 0.02,
                                ),
                                side: const BorderSide(
                                  color: Color(0xFFDA291C),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Seguir comprando',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFFDA291C),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: size.width * 0.03),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                if (await _confirmPurchase(context)) {
                                  // TODO: Implementar lógica de checkout
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ConfirmPurchaseScreen(
                                        orderId: '${(10000 + (99999 - 10000) * (new DateTime.now().millisecondsSinceEpoch % 10000) / 10000).toInt()}',
                                        productName: 'Producto Ejemplo',
                                        totalAmount: 100.00,
                                      ),
                                    ),
                                  );
                                 
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFDA291C),
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                  vertical: size.height * 0.02,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Confirmar pedido',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
