import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:McDonalds/models/product_model.dart';
import 'package:McDonalds/providers/products_provider.dart';
import 'package:McDonalds/utils/rocket_theme.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:McDonalds/providers/cart_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;
  Map<String, String> selectedProducts = {};

  final Map<String, String> categoryIdToLogical = {
    "HAMBURGUESAS_CATEGORY_ID": "hamburguesas",
    "BEVERAGE_CATEGORY_ID": "bebidas",
    "ACOMPANAR_CATEGORY_ID": "acompanamientos",
    "DESSERT_CATEGORY_ID": "postres",
    "CHICKEN_CATEGORY_ID": "pollo",
    "BREAKFAST_CATEGORY_ID": "desayunos",
  };

  final Map<String, List<String>> relatedCategories = {
    'desayunos': ['bebidas'],
    'hamburguesas': ['bebidas', 'acompanamientos', 'postres', 'pollo'],
    'pollo': ['acompanamientos', 'bebidas', 'postres'],
    'postres': ['bebidas'],
    'bebidas': ['acompanamientos'],
    'acompanamientos': ['bebidas'],
  };

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _fetchComplements());
  }

  void _fetchComplements() {
    final provider = Provider.of<ProductsProvider>(context, listen: false);
    final logicalCategory =
        categoryIdToLogical[widget.product.categoryId] ??
        widget.product.categoryId;
    final categories = relatedCategories[logicalCategory] ?? [];
    for (final category in categories) {
      provider.fetchProductsByCategory(category);
    }
  }

  void _handleProductTap(String category, String productId) {
    setState(() {
      if (selectedProducts[category] == productId) {
        selectedProducts.remove(category);
      } else {
        selectedProducts[category] = productId;
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
      final selectedProduct = products.firstWhere(
        (p) => p.id == entry.value,
        orElse: () => widget.product,
      );
      extrasTotal += selectedProduct.price;
    }

    return (basePrice + extrasTotal) * quantity;
  }

  Widget _buildProductImage(String imageUrl, {bool isCircular = false}) {
    return Container(
      width: isCircular ? 80 : double.infinity,
      height: isCircular ? 80 : 200,
      decoration: BoxDecoration(
        shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: !isCircular ? BorderRadius.circular(12) : null,
      ),
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
        errorBuilder:
            (_, __, ___) => Icon(Icons.fastfood, size: isCircular ? 32 : 40),
      ),
    );
  }

  Widget buildCircleProductSlider(String category) {
    return Consumer<ProductsProvider>(
      builder: (context, provider, _) {
        final isLoading = provider.isLoadingCategory(category);
        final error = provider.getErrorForCategory(category);
        final products = provider.getProductsByCategory(category);
        final isSelected = (String id) => selectedProducts[category] == id;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(category.toUpperCase(), style: RocketTextStyles.headline2),
            const SizedBox(height: 12),
            Skeletonizer(
              enabled: isLoading,
              containersColor: Colors.grey[300],
              effect: ShimmerEffect(
                baseColor: Colors.grey[400]!,
                highlightColor: Colors.grey[200]!,
              ),
              child: SizedBox(
                height: 150,
                child:
                    error != null
                        ? Center(child: Text(error))
                        : products.isEmpty && !isLoading
                        ? Center(child: Text("No hay productos en $category"))
                        : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: isLoading ? 3 : products.length,
                          itemBuilder: (context, index) {
                            if (isLoading) {
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                width: 90,
                                child: Column(
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      height: 12,
                                      width: 40,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              );
                            }

                            final product = products[index];
                            final selected = isSelected(product.id);

                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              width: 90,
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap:
                                        () => _handleProductTap(
                                          category,
                                          product.id,
                                        ),
                                    child: Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color:
                                              selected
                                                  ? RocketColors.primary
                                                  : Colors.grey,
                                          width: selected ? 4 : 1,
                                        ),
                                      ),
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          ClipOval(
                                            child: _buildProductImage(
                                              product.image,
                                              isCircular: true,
                                            ),
                                          ),
                                          if (selected)
                                            Positioned(
                                              top: 0,
                                              right: 0,
                                              child: Container(
                                                width: 20,
                                                height: 20,
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.yellow,
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
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '\$${product.price.toStringAsFixed(0)}',
                                    style: RocketTextStyles.body.copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w900,
                                      color: RocketColors.secondary,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final logicalCategory =
        categoryIdToLogical[product.categoryId] ?? product.categoryId;
    final categories = relatedCategories[logicalCategory] ?? [];
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
        enabled: false, // Se maneja individualmente en cada sección
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
              Column(
                //columna titulo y precio
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${widget.product.price.toStringAsFixed(0)}',
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.9,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
              Center(
                child: Column(
                  //columna hamburguesa
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: _buildProductImage(product.image),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      product.name,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      height: 48,
                      width: 140,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed:
                                quantity > 1
                                    ? () => setState(() => quantity--)
                                    : null,
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
                    ),
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
              Text(
                "Información de alérgenos",
                style: RocketTextStyles.headline2,
              ),
              Text(
                'Contiene:',
                style: RocketTextStyles.body.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 10),
              if (product.allergens.isEmpty)
                Text(
                  "No contiene alérgenos importantes.",
                  style: RocketTextStyles.body,
                )
              else
                Wrap(
                  spacing: 8, // Espacio horizontal entre chips
                  runSpacing: 8, // Espacio vertical entre filas
                  children:
                      product.allergens.map((allergen) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Color(Colors.grey[200]!.value),
                            border: Border.all(
                              color: Color(Colors.grey[400]!.value),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(width: 4),
                              Text(
                                allergen,
                                style: RocketTextStyles.body.copyWith(
                                  fontSize: 14,
                                  color: RocketColors.text,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                ),
              const SizedBox(height: 16),
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
      bottomNavigationBar: Material(
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
      ),
    );
  }
}
