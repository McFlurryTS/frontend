import 'package:flutter/material.dart';
import 'package:McDonalds/utils/rocket_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:McDonalds/providers/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:McDonalds/models/product_model.dart';

class HappyMealsScreen extends StatefulWidget {
  const HappyMealsScreen({super.key});

  @override
  State<HappyMealsScreen> createState() => _HappyMealsScreenState();
}

class _HappyMealsScreenState extends State<HappyMealsScreen> {
  int _quantity = 1;
  bool _isLargeSize = false;

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  void _addToCart(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    final product = Product(
      id: _isLargeSize ? 'happy-meal-large' : 'happy-meal-regular',
      name: _isLargeSize ? 'Cajita Feliz Grande' : 'Cajita Feliz',
      description: 'Incluye juguete sorpresa',
      price: _isLargeSize ? 129.0 : 99.0,
      image:
          'assets/happy/${_isLargeSize ? 'happy_meal_grande.png' : 'happy_meal_chica.png'}',
      category: 'CAJITA_FELIZ',
      country: 'MX',
      active: true,
      updated_at: DateTime.now(),
    );

    cartProvider.addItem(product, _quantity, {});

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('¡Cajita Feliz agregada al carrito!'),
        duration: Duration(seconds: 2),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RocketColors.background,
      appBar: AppBar(
        title: Text(
          'Cajita Feliz',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFFDA291C),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Imagen del producto
                    Image.asset(
                      'assets/happy/${_isLargeSize ? 'happy_meal_grande.png' : 'happy_meal_chica.png'}',
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 24),
                    // Selector de tamaño
                    Row(
                      children: [
                        Expanded(
                          child: _buildSizeButton(
                            'Regular',
                            !_isLargeSize,
                            () => setState(() => _isLargeSize = false),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildSizeButton(
                            'Grande',
                            _isLargeSize,
                            () => setState(() => _isLargeSize = true),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Selector de cantidad
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: _decrementQuantity,
                          icon: const Icon(Icons.remove_circle_outline),
                          color: const Color(0xFFDA291C),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          _quantity.toString(),
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          onPressed: _incrementQuantity,
                          icon: const Icon(Icons.add_circle_outline),
                          color: const Color(0xFFDA291C),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Precio
                    Text(
                      '\$${(_isLargeSize ? 129.0 : 99.0).toStringAsFixed(0)}',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFDA291C),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Botón de agregar al carrito
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () => _addToCart(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDA291C),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Agregar al carrito',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSizeButton(String text, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFDA291C) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFDA291C), width: 2),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFFDA291C),
          ),
        ),
      ),
    );
  }
}
