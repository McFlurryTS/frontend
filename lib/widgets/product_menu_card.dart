import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:McDonalds/models/product_model.dart';
import 'package:McDonalds/widgets/optimized_image.dart';

class ProductMenuCard extends StatelessWidget {
  final Product product;
  final Color backgroundColor;
  final VoidCallback onTap;

  const ProductMenuCard({
    super.key,
    required this.product,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.grey.withOpacity(0.1), width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 5,
                child: Hero(
                  tag: 'product-${product.id}',
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    child: Container(
                      color: Colors.white,
                      child: OptimizedImage(
                        imageUrl: product.image,
                        fit: BoxFit.cover,
                        cacheWidth: 300, // Optimizar el tamaño de cache
                        cacheHeight: 300,
                        enableBlur: true, // Efecto blur mientras carga
                        placeholder: Container(
                          color: Colors.grey[100],
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.grey[300],
                            ),
                          ),
                        ),
                        errorWidget:
                            (context, error) => Center(
                              child: Icon(
                                Icons.fastfood,
                                size: 40,
                                color: Colors.grey[400],
                              ),
                            ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '\$${product.price.toStringAsFixed(0)}',
                        style: GoogleFonts.roboto(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
