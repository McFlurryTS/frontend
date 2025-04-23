import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:McDonalds/models/product_model.dart';
import 'package:McDonalds/providers/products_provider.dart';
import 'package:McDonalds/utils/rocket_theme.dart';
import 'package:McDonalds/providers/cart_provider.dart';
import 'package:McDonalds/widgets/optimized_image.dart';
import 'package:McDonalds/widgets/cart_button.dart';
import 'package:McDonalds/models/cart_item_model.dart';
import 'package:McDonalds/widgets/confirmation_dialog.dart';
import 'package:McDonalds/widgets/cart_confirmation_dialog.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  final TabController? tabController;
  final ValueNotifier<int>? currentIndexNotifier;
  final CartItem? cartItem; // Nuevo parámetro para edición

  const ProductDetailScreen({
    super.key,
    required this.product,
    this.tabController,
    this.currentIndexNotifier,
    this.cartItem, // Agregar a constructor
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with SingleTickerProviderStateMixin {
  int quantity = 1;
  final Map<String, Set<String>> selectedProducts = {};
  late AnimationController _animationController;
  final GlobalKey _cartIconKey = GlobalKey();
  final GlobalKey _productImageKey = GlobalKey();
  bool get isEditing => widget.cartItem != null;

  final Map<String, List<String>> recommendedCategoriesMap = {
    'BEBIDAS': ['POSTRES_Y_MALTEADAS', 'FAMILY_BOX'],
    'A_LA_CARTA_HAMBURGUESAS': [
      'A_LA_CARTA_PAPAS',
      'BEBIDAS',
      'POSTRES_Y_MALTEADAS',
    ],
    'A_LA_CARTA_NUGGETS': ['A_LA_CARTA_PAPAS', 'BEBIDAS'],
    'A_LA_CARTA_PAPAS': ['BEBIDAS', 'POSTRES_Y_MALTEADAS'],
    'POSTRES_Y_MALTEADAS': ['BEBIDAS'],
    'CAJITA_FELIZ': ['POSTRES_Y_MALTEADAS', 'BEBIDAS'],
    'MCTRIOS_MEDIANOS': ['POSTRES_Y_MALTEADAS', 'A_LA_CARTA_PAPAS'],
    'MCTRIOS_GRANDES': ['POSTRES_Y_MALTEADAS', 'A_LA_CARTA_PAPAS'],
    'MCTRIO_3X3': ['A_LA_CARTA_PAPAS', 'BEBIDAS'],
    'TU_FAV_99': ['BEBIDAS', 'POSTRES_Y_MALTEADAS'],
    'PROMOCIONES': ['A_LA_CARTA_HAMBURGUESAS', 'BEBIDAS'],
    'FAMILY_BOX': ['BEBIDAS', 'POSTRES_Y_MALTEADAS'],
    'DESAYUNOS': ['BEBIDAS', 'POSTRES_Y_MALTEADAS'],
  };

  final Map<String, String> categoryNames = {
    'BEBIDAS': 'Bebidas',
    'POSTRES_Y_MALTEADAS': 'Postres y Malteadas',
    'A_LA_CARTA_PAPAS': 'Papas',
    'A_LA_CARTA_HAMBURGUESAS': 'Hamburguesas',
    'FAMILY_BOX': 'Family Box',
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _loadRecommendedProducts();

    // Inicializar con datos del carrito si estamos editando
    if (isEditing) {
      quantity = widget.cartItem!.quantity;
      selectedProducts.addAll(
        Map<String, Set<String>>.from(widget.cartItem!.selectedExtras),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _loadRecommendedProducts() {
    final provider = Provider.of<ProductsProvider>(context, listen: false);
    if (provider.productsByCategory.isEmpty) {
      provider.fetchMenuCompleto();
    }
  }

  void _handleProductTap(String category, String productId) {
    setState(() {
      selectedProducts[category] ??= {};
      if (selectedProducts[category]!.contains(productId)) {
        selectedProducts[category]!.remove(productId);
        if (selectedProducts[category]!.isEmpty) {
          selectedProducts.remove(category);
        }
      } else {
        selectedProducts[category]!.add(productId);
      }
    });
  }

  void _addToCartWithAnimation() async {
    final RenderBox? productBox =
        _productImageKey.currentContext?.findRenderObject() as RenderBox?;
    final RenderBox? cartBox =
        _cartIconKey.currentContext?.findRenderObject() as RenderBox?;

    if (productBox != null && cartBox != null) {
      final productPos = productBox.localToGlobal(Offset.zero);
      final cartPos = cartBox.localToGlobal(Offset.zero);

      final overlay = OverlayEntry(
        builder: (context) {
          return AnimatedBuilder(
            animation: _animationController,
            builder: (_, child) {
              final curveValue = Curves.easeInOut.transform(
                _animationController.value,
              );
              return Positioned(
                left: productPos.dx + (cartPos.dx - productPos.dx) * curveValue,
                top: productPos.dy + (cartPos.dy - productPos.dy) * curveValue,
                child: Transform.scale(
                  scale: 1.0 - curveValue * 0.7,
                  child: Opacity(
                    opacity: 1.0 - curveValue * 0.5,
                    child: SizedBox(
                      width: 60,
                      height: 60,
                      child: _buildProductImage(
                        widget.product.image,
                        isCircular: true,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      );

      Overlay.of(context).insert(overlay);
      await _animationController.forward();
      overlay.remove();
      _animationController.reset();

      Provider.of<CartProvider>(
        context,
        listen: false,
      ).addItem(widget.product, quantity, selectedProducts);

      if (mounted) {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder:
              (context) => CartConfirmationDialog(
                tabController: widget.tabController,
                currentIndexNotifier: widget.currentIndexNotifier,
              ),
        );
      }
    }
  }

  Future<bool> _confirmSaveChanges(BuildContext context) async {
    return await showConfirmationDialog(
      context: context,
      title: '¿Desea continuar con los cambios?',
      subtitle: 'Los cambios se aplicarán a tu pedido.',
      confirmText: 'Continuar',
      icon: Icons.edit,
    );
  }

  void _handleSaveChanges(BuildContext context) async {
    if (await _confirmSaveChanges(context)) {
      final cartProvider = Provider.of<CartProvider>(context, listen: false);

      // Siempre usar el ID original para actualizar
      if (widget.cartItem != null) {
        final originalItemId = widget.cartItem!.getItemId();
        cartProvider.updateItem(
          originalItemId,
          widget.product,
          quantity,
          selectedProducts,
        );
      } else {
        cartProvider.addItem(widget.product, quantity, selectedProducts);
      }

      // Navegar de vuelta
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  double get totalPrice {
    final provider = Provider.of<ProductsProvider>(context, listen: false);
    return calculateTotal(provider);
  }

  double calculateTotal(ProductsProvider provider) {
    double basePrice = widget.product.price * quantity;
    double extrasTotal = 0.0;

    for (final entry in selectedProducts.entries) {
      final category = entry.key;
      final productIds = entry.value;
      final products = provider.getProductsByCategory(category);

      for (final productId in productIds) {
        final extraProduct = products.firstWhere(
          (p) => p.id == productId,
          orElse: () => widget.product,
        );
        extrasTotal += extraProduct.price;
      }
    }

    return basePrice + (extrasTotal * quantity);
  }

  Widget _buildProductImage(String imageUrl, {bool isCircular = false}) {
    return Container(
      width: isCircular ? 80 : double.infinity,
      height: isCircular ? 80 : 280,
      decoration: BoxDecoration(
        shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: !isCircular ? BorderRadius.circular(12) : null,
      ),
      clipBehavior: Clip.antiAlias,
      child: Center(
        child: OptimizedImage(
          imageUrl: imageUrl,
          fit: BoxFit.contain,
          width: isCircular ? 60 : null,
          height: isCircular ? 60 : null,
          cacheWidth: isCircular ? 160 : 600,
          cacheHeight: isCircular ? 160 : 600,
          enableBlur: true,
          borderRadius: !isCircular ? 12 : null,
          placeholder: Container(
            color: Colors.grey[200],
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.grey[400],
              ),
            ),
          ),
          errorWidget:
              (_, __) => Icon(
                Icons.fastfood,
                size: isCircular ? 32 : 40,
                color: Colors.grey[400],
              ),
        ),
      ),
    );
  }

  Widget buildCircleProductSlider(String category) {
    return Consumer<ProductsProvider>(
      builder: (context, provider, _) {
        final products = provider.getProductsByCategory(category);
        if (products.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                category.toUpperCase(),
                style: RocketTextStyles.headline2.copyWith(fontSize: 16),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 140,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: products.length,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemBuilder: (context, index) {
                  final product = products[index];
                  final selected =
                      selectedProducts[category]?.contains(product.id) ?? false;

                  return Container(
                    width: 100,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () => _handleProductTap(category, product.id),
                          child: Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color:
                                    selected
                                        ? RocketColors.primary
                                        : Colors.grey[400]!,
                                width: selected ? 3 : 1,
                              ),
                            ),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                ClipOval(
                                  child: Center(
                                    child: SizedBox(
                                      width: 60,
                                      height: 60,
                                      child: OptimizedImage(
                                        imageUrl: product.image,
                                        fit: BoxFit.contain,
                                        width: 60,
                                        height: 60,
                                        cacheWidth: 120,
                                        cacheHeight: 120,
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
                                              size: 24,
                                              color: Colors.grey[400],
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                                if (selected)
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Container(
                                      width: 22,
                                      height: 22,
                                      decoration: const BoxDecoration(
                                        color: Colors.yellow,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.check,
                                        size: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          product.name,
                          style: RocketTextStyles.body.copyWith(
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontSize: 12,
                            fontWeight:
                                selected ? FontWeight.w900 : FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '\$${product.price.toStringAsFixed(0)}',
                          style: RocketTextStyles.body.copyWith(
                            fontFamily: GoogleFonts.roboto().fontFamily,
                            fontSize: 12,
                            fontWeight:
                                selected ? FontWeight.w900 : FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final categories = recommendedCategoriesMap[product.category] ?? [];
    final bool hasAnyRelated = categories.any(
      (cat) =>
          Provider.of<ProductsProvider>(
            context,
            listen: false,
          ).getProductsByCategory(cat).isNotEmpty,
    );

    return Scaffold(
      backgroundColor: RocketColors.background,
      appBar: AppBar(
        backgroundColor: RocketColors.secondary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [CartButton(key: _cartIconKey), const SizedBox(width: 8)],
      ),
      body: Consumer<ProductsProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: GoogleFonts.poppins(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${product.price.toStringAsFixed(0)}',
                  style: GoogleFonts.roboto(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.9,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Column(
                    children: [
                      SizedBox(
                        width: 280,
                        height: 280,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: RepaintBoundary(
                            key: _productImageKey,
                            child: _buildProductImage(product.image),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          product.description,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Center(child: _buildQuantitySelector()),
                const SizedBox(height: 32),
                if (!hasAnyRelated)
                  Text(
                    "No hay acompañamientos ni productos relacionados.",
                    style: RocketTextStyles.body.copyWith(color: Colors.grey),
                  ),
                for (final cat in categories) buildCircleProductSlider(cat),
                const SizedBox(height: 16),
                _buildAllergenSection(product),
                const SizedBox(height: 16),
                Text(
                  "Total: \$${totalPrice.toStringAsFixed(0)}",
                  style: RocketTextStyles.headline2.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: RocketColors.primary,
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Material(
        color: RocketColors.primary,
        child: InkWell(
          onTap:
              () =>
                  isEditing
                      ? _handleSaveChanges(context)
                      : _addToCartWithAnimation(),
          splashColor: Colors.black12,
          highlightColor: Colors.black12,
          child: Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isEditing ? 'Guardar cambios' : 'Agregar al carrito',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '\$${totalPrice.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuantitySelector() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[400]!),
        borderRadius: BorderRadius.circular(30),
      ),
      height: 48,
      width: 140,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(
              Icons.remove,
              color: quantity > 1 ? Colors.black : Colors.grey,
            ),
            onPressed: () {
              if (quantity > 1) {
                setState(() => quantity--);
              }
            },
          ),
          const SizedBox(width: 14),
          Text(
            quantity.toString(),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 14),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => setState(() => quantity++),
          ),
        ],
      ),
    );
  }

  Widget _buildAllergenSection(Product product) {
    if (!product.hasAllergens) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Información de alérgenos", style: RocketTextStyles.headline2),
        const SizedBox(height: 6),
        Text('Contiene:', style: RocketTextStyles.body),
        const SizedBox(height: 10),
        if (product.allergens.isEmpty)
          Text(
            'No se encontró información de alérgenos.',
            style: TextStyle(color: Colors.grey[600]),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                product.allergens.map((allergen) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      allergen,
                      style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                    ),
                  );
                }).toList(),
          ),
        const SizedBox(height: 16),
      ],
    );
  }
}
