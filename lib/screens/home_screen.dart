import 'dart:math' as math;
import 'package:McDonalds/models/category_model.dart';
import 'package:McDonalds/models/product_model.dart';
import 'package:McDonalds/services/image_cache_service.dart';
import 'package:McDonalds/services/storage_service.dart';
import 'package:McDonalds/utils/rocket_theme.dart';
import 'package:McDonalds/widgets/optimized_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:McDonalds/providers/categories_provider.dart';
import 'package:McDonalds/providers/products_provider.dart';
import 'package:McDonalds/widgets/category_card.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:McDonalds/widgets/cart_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isFirstLoad = true;
  final ValueNotifier<int> _currentPromotionIndex = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    final productsProvider = Provider.of<ProductsProvider>(
      context,
      listen: false,
    );
    final categoriesProvider = Provider.of<CategoriesProvider>(
      context,
      listen: false,
    );

    try {
      if (!productsProvider.isInitialized) {
        await productsProvider.fetchMenuCompleto();

        if (mounted &&
            !productsProvider.hasError &&
            categoriesProvider.categories.isEmpty) {
          await categoriesProvider.generateCategoriesFromProducts(
            productsProvider,
          );
        }

        if (mounted) {
          _preloadImagesForHome(productsProvider, categoriesProvider);
        }
      }
    } catch (e) {
      debugPrint('Error inicializando datos: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isFirstLoad = false;
        });
      }
    }
  }

  void _preloadImagesForHome(
    ProductsProvider productsProvider,
    CategoriesProvider categoriesProvider,
  ) {
    try {
      final List<String> priorityUrls = [];

      // Solo precargar las primeras imágenes más importantes
      final promotions = productsProvider.getProductsByCategory('PROMOCIONES');
      if (promotions.isNotEmpty) {
        priorityUrls.addAll(promotions.take(2).map((p) => p.image));
      }

      final categories = categoriesProvider.categories;
      if (categories.isNotEmpty) {
        priorityUrls.addAll(categories.take(2).map((c) => c.imageUrl));
      }

      if (priorityUrls.isNotEmpty) {
        ImageCacheService.preloadHomeImages(priorityUrls);
      }
    } catch (e) {
      debugPrint('Error en precarga de imágenes: $e');
    }
  }

  List<Product> _getRandomPromotions(List<Product> promotions) {
    if (promotions.isEmpty) return [];

    final random = math.Random();
    final promotionsList = List<Product>.from(promotions);
    promotionsList.shuffle(random);

    return promotionsList.take(math.min(6, promotionsList.length)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ProductsProvider, CategoriesProvider>(
      builder: (context, productsProvider, categoriesProvider, _) {
        final bool isLoading =
            (productsProvider.isLoading || categoriesProvider.isLoading) &&
                _isFirstLoad;

        if (productsProvider.hasError && !isLoading) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  productsProvider.error ?? 'Error al cargar los datos',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => productsProvider.retryLoading(),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Scaffold(
            backgroundColor: Colors.grey[100],
            body: Skeletonizer(
              enabled: isLoading,
              containersColor: Colors.grey[300],
              effect: ShimmerEffect(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
              ),
              child: RefreshIndicator(
                onRefresh: () async {
                  await StorageService.clearCache();
                  await productsProvider.fetchMenuCompleto();
                  await categoriesProvider.generateCategoriesFromProducts(
                    productsProvider,
                  );
                },
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                    decelerationRate: ScrollDecelerationRate.fast,
                  ),
                  scrollBehavior: ScrollConfiguration.of(context).copyWith(
                    scrollbars: false,
                    overscroll: true,
                    physics: const BouncingScrollPhysics(
                      decelerationRate: ScrollDecelerationRate.fast,
                    ),
                    platform: TargetPlatform.android,
                  ),
                  slivers: [
                    SliverAppBar(
                      expandedHeight: 160, // Reducido de 170 a 160
                      floating: false,
                      pinned: true,
                      stretch: true,
                      backgroundColor: const Color(0xFFDA291C),
                      actions: const [CartButton(), SizedBox(width: 8)],
                      flexibleSpace: LayoutBuilder(
                        builder: (
                          BuildContext context,
                          BoxConstraints constraints,
                        ) {
                          final top = constraints.biggest.height;
                          final collapsedHeight =
                              MediaQuery.of(context).padding.top +
                                  kToolbarHeight;
                          final expandedHeight = 160.0; // Ajustado a 160
                          final fraction = ((top - collapsedHeight) /
                                  (expandedHeight - collapsedHeight))
                              .clamp(0.0, 1.0);

                          return FlexibleSpaceBar(
                            titlePadding: EdgeInsets.only(
                              left: 16 + (fraction * 9),
                              bottom: 16,
                            ),
                            centerTitle: false,
                            title: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  'assets/icons/logo/72_logo.png',
                                  height: 24 + (fraction * 8),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'McDonald\'s',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18, // Reducido de 20 a 18
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            background: Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFDA291C),
                                    Color(0xFFED1C24),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 25,
                                  right: 25,
                                  bottom: 60,
                                  top: 50,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: const [
                                          Text(
                                            'Bienvenida de vuelta! Fernanda',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize:
                                                  22, // Reducido de 24 a 22
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 4,
                                          ), // Reducido de 5 a 4
                                          Text(
                                            'OBTÉN UN DESCUENTO EN LO QUE MÁS TE GUSTA',
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize:
                                                  11, // Reducido de 12 a 11
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 72,
                                      height: 72,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white24,
                                      ),
                                      alignment: Alignment.center,
                                      child: const Icon(
                                        Icons.person,
                                        color: Colors.white,
                                        size: 32,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: _buildCustomMasonryGrid(
                          context,
                          categoriesProvider,
                          productsProvider,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPromotionsSlider(
    BuildContext context,
    List<Product> promotions,
  ) {
    if (promotions.isEmpty) return const SizedBox.shrink();

    final randomPromotions = _getRandomPromotions(promotions);
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: randomPromotions.length,
          options: CarouselOptions(
            height: 170, // Reducido de 180 a 170
            viewportFraction: 1,
            enlargeCenterPage: false,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            onPageChanged: (index, _) => _currentPromotionIndex.value = index,
            scrollPhysics: const BouncingScrollPhysics(),
          ),
          itemBuilder: (context, index, _) {
            final promotion = randomPromotions[index];
            return GestureDetector(
              onTap: () => Navigator.pushNamed(
                context,
                '/product_detail',
                arguments: promotion,
              ),
              child: Container(
                width: screenWidth,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(25),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(25),
                          ),
                          child: OptimizedImage(
                            imageUrl: promotion.image,
                            fit: BoxFit.contain,
                            placeholder: Container(
                              color: Colors.grey[200],
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(25),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            promotion.name,
                            style: const TextStyle(
                              fontSize: 14, // Reducido de 16 a 14
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF333333),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 10), // Reducido de 12 a 10
        ValueListenableBuilder<int>(
          valueListenable: _currentPromotionIndex,
          builder: (context, currentIndex, _) {
            return AnimatedSmoothIndicator(
              activeIndex: currentIndex,
              count: randomPromotions.length,
              effect: ExpandingDotsEffect(
                dotHeight: 6,
                dotWidth: 6,
                expansionFactor: 3,
                activeDotColor: RocketColors.primary,
                dotColor: Colors.grey[300]!,
                spacing: 8,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCustomMasonryGrid(
    BuildContext context,
    CategoriesProvider categoriesProvider,
    ProductsProvider productsProvider,
  ) {
    if (categoriesProvider.error != null) {
      return Center(
        child: Text(
          categoriesProvider.error!,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    final categories = categoriesProvider.categories;
    final promotions = productsProvider.getProductsByCategory('PROMOCIONES');

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (promotions.isNotEmpty) ...[
          _buildPromotionsSlider(context, promotions),
          const SizedBox(height: 20),
        ],
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Primera columna
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildFakeCard(
                    icon: Icons.search,
                    text: 'Buscar...',
                    height: 80,
                    routeName: '/search',
                    context: context,
                  ),
                  const SizedBox(height: 20),
                  ...categories
                      .asMap()
                      .entries
                      .where((e) => e.key % 2 == 0) // Índices pares
                      .map(
                        (entry) => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildCategoryCard(context, entry.value),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            // Segunda columna
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildFakeCard(
                    icon: Icons.menu,
                    text: 'Menú',
                    height: 80,
                    routeName: '/menu',
                    context: context,
                  ),
                  const SizedBox(height: 20),
                  ...categories
                      .asMap()
                      .entries
                      .where((e) => e.key % 2 != 0) // Índices impares
                      .map(
                        (entry) => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildCategoryCard(context, entry.value),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryCard(BuildContext context, MenuCategory category) {
    return CategoryCard(
      category: category,
      onTap: () {
        Navigator.pushNamed(context, '/category', arguments: category.id);
      },
    );
  }

  Widget _buildFakeCard({
    required IconData icon,
    required String text,
    required double height,
    String? routeName,
    required BuildContext context,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: routeName != null
            ? () => Navigator.pushNamed(context, routeName)
            : null,
        borderRadius: BorderRadius.circular(15),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: const LinearGradient(
              colors: [Color(0xFFfceaa2), Color(0xFFfcc29c)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Container(
            height: height,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(icon, color: Colors.grey[600], size: 26),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    text,
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
