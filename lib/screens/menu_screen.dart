import 'dart:math' show Random;
import 'package:McDonalds/models/product_model.dart';
import 'package:McDonalds/providers/products_provider.dart';
import 'package:McDonalds/utils/rocket_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:McDonalds/widgets/product_menu_card.dart';
import 'package:McDonalds/widgets/cart_button.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  // Lista de colores suaves y profesionales para las cards
  static const List<Color> cardColors = [
    Color(0xFFFAFAFA), // Blanco suave
    Color(0xFFF5F5F5), // Gris muy claro
    Color(0xFFFFFFFF), // Blanco puro
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
            decelerationRate: ScrollDecelerationRate.fast,
          ),
          cacheExtent: 1000, // Aumentar el caché para scroll más suave
          slivers: [
            SliverAppBar(
              expandedHeight: 120,
              floating: true,
              pinned: true,
              backgroundColor: RocketColors.secondary,
              actions: const [CartButton(), SizedBox(width: 8)],
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        RocketColors.secondary,
                        RocketColors.secondary.withOpacity(0.95),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                title: Text(
                  'Nuestro Menú',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                centerTitle: true,
              ),
            ),
            Consumer<ProductsProvider>(
              builder: (context, provider, _) {
                final allProducts =
                    provider.productsByCategory.values
                        .expand((products) => products)
                        .toList()
                      ..shuffle(Random());

                return SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index >= allProducts.length) return null;
                        final product = allProducts[index];
                        return RepaintBoundary(
                          child: _buildProductCard(
                            context,
                            product,
                            cardColors[index % cardColors.length],
                          ),
                        );
                      },
                      childCount: allProducts.length,
                      addRepaintBoundaries: true,
                      addAutomaticKeepAlives: true,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(
    BuildContext context,
    Product product,
    Color baseColor,
  ) {
    return ProductMenuCard(
      key: ValueKey(product.id),
      product: product,
      backgroundColor: baseColor,
      onTap:
          () => Navigator.pushNamed(
            context,
            '/product_detail',
            arguments: product,
          ),
    );
  }
}
