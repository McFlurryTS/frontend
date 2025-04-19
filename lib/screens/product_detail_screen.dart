import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:McDonalds/models/product_model.dart';
import 'package:McDonalds/providers/products_provider.dart';
import 'package:McDonalds/utils/rocket_theme.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:McDonalds/providers/cart_provider.dart';
import 'package:McDonalds/widgets/optimized_image.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;
  // Cambiar a Map<String, Set<String>> para permitir múltiples selecciones por categoría
  final Map<String, Set<String>> selectedProducts = {};

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
    _loadRecommendedProducts();
  }

  void _loadRecommendedProducts() {
    final provider = Provider.of<ProductsProvider>(context, listen: false);
    if (provider.productsByCategory.isEmpty) {
      provider.fetchMenuCompleto();
    }
  }

  void _handleProductTap(String category, String productId) {
    setState(() {
      // Inicializar el set si no existe
      selectedProducts[category] ??= {};

      // Toggle: si ya está seleccionado lo quita, si no lo agrega
      if (selectedProducts[category]!.contains(productId)) {
        selectedProducts[category]!.remove(productId);
        // Si el set queda vacío, eliminar la categoría
        if (selectedProducts[category]!.isEmpty) {
          selectedProducts.remove(category);
        }
      } else {
        selectedProducts[category]!.add(productId);
      }
    });
  }

  void _addToCart() {
    if (selectedProducts.isNotEmpty) {
      Provider.of<CartProvider>(
        context,
        listen: false,
      ).addItem(widget.product, quantity, selectedProducts);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Producto agregado al carrito')),
      );
    }
  }

  double get totalPrice {
    double basePrice = widget.product.price;
    double extrasTotal = 0.0;

    for (final entry in selectedProducts.entries) {
      final products = Provider.of<ProductsProvider>(
        context,
        listen: false,
      ).getProductsByCategory(entry.key);

      // Sumar el precio de todos los productos seleccionados en la categoría
      for (final productId in entry.value) {
        final selectedProduct = products.firstWhere(
          (p) => p.id == productId,
          orElse: () => widget.product,
        );
        extrasTotal += selectedProduct.price;
      }
    }

    return (basePrice + extrasTotal) * quantity;
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
              height: 140, // Altura fija para todos los sliders
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: products.length,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemBuilder: (context, index) {
                  final product = products[index];
                  final selected =
                      selectedProducts[category]?.contains(product.id) ?? false;

                  return Container(
                    width: 100, // Ancho fijo para todos los items
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () => _handleProductTap(category, product.id),
                          child: Container(
                            width: 70, // Reducido de 85 a 70
                            height: 70, // Reducido de 85 a 70
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
                              clipBehavior:
                                  Clip.none, // Añadido para controlar overflow
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
                                        cacheWidth:
                                            120, // 2x el tamaño para pantallas de alta densidad
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
                                        size: 14, // Reducido de 16 a 14
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
        backgroundColor: RocketColors.background,
        foregroundColor: RocketColors.text,
        elevation: 0,
      ),
      body: Skeletonizer(
        enabled: false,
        containersColor: Colors.grey[300],
        effect: ShimmerEffect(
          baseColor: Colors.grey[400]!,
          highlightColor: Colors.grey[200]!,
        ),
        child: SingleChildScrollView(
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
                ),
              ),
              const SizedBox(height: 2),
              // Contenedor centrado para imagen, título y controles
              Center(
                child: Column(
                  children: [
                    SizedBox(
                      width: 280, // Ancho fijo para la imagen
                      height: 280, // Alto fijo para la imagen
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: _buildProductImage(product.image),
                      ),
                    ),
                    const SizedBox(height: 2),
                    SizedBox(
                      width: 280, // Mismo ancho que la imagen
                      child: Text(
                        product.name,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildQuantitySelector(),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              if (!hasAnyRelated)
                Text(
                  "No hay acompañamientos ni productos relacionados.",
                  style: RocketTextStyles.body.copyWith(color: Colors.grey),
                ),
              for (final cat in categories) buildCircleProductSlider(cat),
              const SizedBox(height: 16),
              _buildAllergenSection(product),
              Text(
                "Total: \$${totalPrice.toStringAsFixed(0)}",
                style: RocketTextStyles.headline2.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
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
            onPressed: quantity > 1 ? () => setState(() => quantity--) : null,
            icon: const Icon(Icons.remove),
          ),
          const SizedBox(width: 14),
          Text(
            '$quantity',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 14),
          IconButton(
            onPressed: () => setState(() => quantity++),
            icon: const Icon(Icons.add),
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
            "No contiene alérgenos importantes.",
            style: RocketTextStyles.body,
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
                      border: Border.all(color: Colors.grey[400]!),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      allergen,
                      style: RocketTextStyles.body.copyWith(
                        fontSize: 14,
                        color: RocketColors.text,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
          ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Material(
      color: RocketColors.primary,
      child: InkWell(
        onTap: _addToCart,
        splashColor: Colors.black12,
        highlightColor: Colors.black12,
        child: Container(
          width: double.infinity,
          height: 78,
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Añadir al carrito', style: RocketTextStyles.button2),
              Text(
                '\$${totalPrice.toStringAsFixed(0)}',
                style: RocketTextStyles.button2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
