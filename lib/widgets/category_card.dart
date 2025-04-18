import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:McDonalds/models/category_model.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CategoryCard extends StatelessWidget {
  final MenuCategory category;
  final VoidCallback? onTap;

  const CategoryCard({super.key, required this.category, this.onTap});

  Widget _buildImageWithSkeleton({
    required String imageUrl,
    required double width,
    required double height,
    Color? color,
    BlendMode? colorBlendMode,
    double opacity = 1.0,
  }) {
    return Container(
      width: width,
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Opacity(
            opacity: opacity,
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
              color: color,
              colorBlendMode: colorBlendMode,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape:
                        width == height ? BoxShape.circle : BoxShape.rectangle,
                  ),
                  child: Skeletonizer(
                    enabled: true,
                    effect: ShimmerEffect(
                      baseColor: Colors.grey[400]!,
                      highlightColor: Colors.grey[200]!,
                    ),
                    child: Container(color: Colors.white),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/category',
          arguments: {'id': category.id, 'endpoint': category.endpoint},
        );
      },
      child: Container(
        width: 168,
        height: 180,
        decoration: BoxDecoration(
          color: category.color,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2), // Color de la sombra
              blurRadius: 10, // Difuminado
              offset: const Offset(0, 5), // Desplazamiento
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Sombra con tamaño fijo
                  Positioned(
                    bottom: -19,
                    left: 0.8,
                    child: SizedBox(
                      width: 175,
                      height: 175,
                      child: Opacity(
                        opacity: 0.08,
                        child: _buildImageWithSkeleton(
                          imageUrl: category.imageUrl,
                          width: 175,
                          height: 175,
                          color: Colors.black,
                          colorBlendMode: BlendMode.srcATop,
                        ),
                      ),
                    ),
                  ),
                  // Imagen principal con tamaño fijo
                  SizedBox(
                    width: 180,
                    height: 180,
                    child: _buildImageWithSkeleton(
                      imageUrl: category.imageUrl,
                      width: 180,
                      height: 180,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                category.name,
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
