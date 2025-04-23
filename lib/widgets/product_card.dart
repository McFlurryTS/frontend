import 'package:McDonalds/utils/rocket_theme.dart';
import 'package:flutter/material.dart';
import 'package:McDonalds/models/product_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:McDonalds/widgets/optimized_image.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({super.key, required this.product, required this.onTap});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with SingleTickerProviderStateMixin {
  final bool _showLoading = true;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Widget _buildProductImage(String imageUrl) {
    return Container(
      width: 110,
      height: 90,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: OptimizedImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          placeholder: Container(color: Colors.grey[200]),
          errorWidget:
              (_, __) => Center(
                child: Icon(Icons.fastfood, size: 40, color: Colors.grey[400]),
              ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Column(
        children: [
          SizedBox(
            height: 120,
            width: double.infinity,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: _buildProductImage(widget.product.image),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.name,
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
                        'Desde \$${widget.product.price.toStringAsFixed(0)}',
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
