import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:McDonalds/models/category_model.dart';
import 'package:McDonalds/widgets/optimized_image.dart';

class CategoryCard extends StatefulWidget {
  final MenuCategory category;
  final VoidCallback? onTap;

  const CategoryCard({super.key, required this.category, this.onTap});

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    await _controller.forward();
    await Future.delayed(const Duration(milliseconds: 10));
    if (mounted) {
      await _controller.reverse();
      widget.onTap?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _handleTap(),
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _controller,
        builder:
            (context, child) => Transform.scale(
              scale: _scaleAnimation.value,
              child: Opacity(opacity: _fadeAnimation.value, child: child),
            ),
        child: Container(
          width: 168,
          height: 165, // Reducido de 180 a 165
          decoration: BoxDecoration(
            color: widget.category.color,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10), // Reducido de 12 a 10
                  child: OptimizedImage(
                    imageUrl: widget.category.imageUrl,
                    fit: BoxFit.contain,
                    highPriority: true, // Cargar con prioridad alta
                    cacheWidth:
                        336, // 2x el ancho del contenedor para pantallas de alta densidad
                    cacheHeight: 360,
                    enableBlur: true,
                    placeholder: Container(
                      color: Colors.grey[200],
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.grey[300],
                        ),
                      ),
                    ),
                    errorWidget:
                        (_, __) => Icon(
                          Icons.fastfood,
                          size: 40,
                          color: Colors.grey[400],
                        ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  8,
                  0,
                  8,
                  10,
                ), // Reducido padding inferior de 12 a 10
                child: Text(
                  widget.category.name,
                  style: GoogleFonts.inter(
                    fontSize: 20, // Reducido de 22 a 20
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
