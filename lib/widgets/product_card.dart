import 'package:McDonalds/utils/rocket_theme.dart';
import 'package:flutter/material.dart';
import 'package:McDonalds/models/product_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({super.key, required this.product, required this.onTap});

  Widget _buildProductImage(String imageUrl) {
    return Container(
      width: 110,
      height: 90,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Skeletonizer(
            enabled: true,
            containersColor: Colors.grey[300],
            effect: ShimmerEffect(
              baseColor: Colors.grey[400]!,
              highlightColor: Colors.grey[200]!,
            ),
            child: Container(color: Colors.white),
          );
        },
        errorBuilder: (_, __, ___) => const Icon(Icons.fastfood, size: 40),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          SizedBox(
            height: 120,
            width: double.infinity,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: _buildProductImage(product.image),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: RocketTextStyles.headline2.copyWith(
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontSize: 14,
                          letterSpacing: 0.1,
                          fontWeight: FontWeight.w100,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Desde \$${product.price.toStringAsFixed(0)}',
                        style: RocketTextStyles.body.copyWith(
                          fontFamily: GoogleFonts.roboto().fontFamily,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE0E0E0)),
        ],
      ),
    );
  }
}
