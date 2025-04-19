import 'dart:math' as math;
import 'package:McDonalds/models/category_model.dart';
import 'package:McDonalds/models/product_model.dart';
import 'package:McDonalds/services/storage_service.dart';
import 'package:McDonalds/services/image_cache_service.dart';
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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showLoading = true;
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

    // Obtener los datos primero
    if (!productsProvider.isInitialized) {
      await productsProvider.fetchMenuCompleto();

      if (mounted && categoriesProvider.categories.isEmpty) {
        await categoriesProvider.generateCategoriesFromProducts(
          productsProvider,
        );
      }

      // Precargar las imágenes prioritarias del home
      if (mounted) {
        _preloadImagesForHome(productsProvider, categoriesProvider);
      }

      if (mounted) {
        setState(() {
          _showLoading = false;
          _isFirstLoad = false;
        });
      }
    } else {
      // Si ya están inicializados, precargar imágenes de todos modos
      _preloadImagesForHome(productsProvider, categoriesProvider);

      if (mounted) {
        setState(() {
          _showLoading = false;
          _isFirstLoad = false;
        });
      }
    }
  }

  // Método para precargar imágenes del home con alta prioridad
  void _preloadImagesForHome(
    ProductsProvider productsProvider,
    CategoriesProvider categoriesProvider,
  ) {
    try {
      // Obtener las URLs para precarga prioritaria
      final List<String> priorityUrls = [];

      // Imágenes de promociones (las más importantes)
      final promotions = productsProvider.getProductsByCategory('PROMOCIONES');
      if (promotions.isNotEmpty) {
        final randomPromotions = _getRandomPromotions(promotions);
        priorityUrls.addAll(
          randomPromotions.map((promo) => promo.image).toList(),
        );
      }

      // Las primeras imágenes de categorías
      final categories = categoriesProvider.categories;
      if (categories.isNotEmpty) {
        priorityUrls.addAll(
          categories.take(6).map((cat) => cat.imageUrl).toList(),
        );
      }

      // Precargar las imágenes prioritarias
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
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Scaffold(
            backgroundColor: Colors.grey[100],
            body: Skeletonizer(
              enabled: _showLoading && _isFirstLoad && !StorageService.hasLocalData(),
              containersColor: Colors.grey[300],
              effect: ShimmerEffect(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
              ),
              child: RefreshIndicator(
                onRefresh: () async {
                  setState(() => _showLoading = true);
                  await StorageService.clearCache();
                  await productsProvider.fetchMenuCompleto();
                  await categoriesProvider.generateCategoriesFromProducts(
                    productsProvider,
                  );
                  if (mounted) {
                    setState(() => _showLoading = false);
                  }
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
                      expandedHeight: 170,
                      floating: false,
                      pinned: true,
                      stretch: true,
                      backgroundColor: const Color(0xFFDA291C),
                      flexibleSpace: LayoutBuilder(
                        builder: (BuildContext context, BoxConstraints constraints) {
                          final top = constraints.biggest.height;
                          final collapsedHeight = MediaQuery.of(context).padding.top + kToolbarHeight;
                          final expandedHeight = 170.0;
                          final fraction = ((top - collapsedHeight) / (expandedHeight - collapsedHeight)).clamp(0.0, 1.0);
                          
                          return FlexibleSpaceBar(
                            titlePadding: EdgeInsets.only(
                              left: 16 + (fraction * 9), // Ajusta el padding del título según el scroll
                              bottom: 16,
                            ),
                            centerTitle: false,
                            title: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  'assets/icons/logo/72_logo.png',
                                  height: 24 + (fraction * 8), // El logo se hace más grande cuando está expandido
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'McDonald\'s',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            background: Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Color(0xFFDA291C), Color(0xFFED1C24)],
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
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: const [
                                          Text(
                                            'Welcome Back, Fernanda! 👋',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            'OBTEN UN DESCUENTO EN LO QUE MAS TE GUSTA!',
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 14,
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
                                      child: const Text(
                                        'Foto',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
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
            height: 180,
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
              onTap:
                  () => Navigator.pushNamed(
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
                              fontSize: 16,
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
        const SizedBox(height: 12),
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
                children: [
                  _buildFakeCard(
                    icon: Icons.search,
                    text: 'Buscar...',
                    height: 80,
                    routeName: '/search',
                    context: context,
                  ),
                  const SizedBox(height: 20),
                  // Categorías pares
                  ...categories.asMap().entries.where((e) => e.key.isEven).map((
                    entry,
                  ) {
                    return Column(
                      children: [
                        _buildCategoryCard(context, entry.value),
                        const SizedBox(height: 20),
                      ],
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(width: 20),
            // Segunda columna
            Expanded(
              child: Column(
                children: [
                  // Categorías impares
                  ...categories.asMap().entries.where((e) => !e.key.isEven).map(
                    (entry) {
                      if (entry.key == 3) {
                        return Column(
                          children: [
                            _buildFakeCard(
                              icon: Icons.menu,
                              text: 'Menú',
                              height: 80,
                              routeName: '/menu',
                              context: context,
                            ),
                            const SizedBox(height: 20),
                            _buildCategoryCard(context, entry.value),
                            const SizedBox(height: 20),
                          ],
                        );
                      }
                      return Column(
                        children: [
                          _buildCategoryCard(context, entry.value),
                          const SizedBox(height: 20),
                        ],
                      );
                    },
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
        onTap:
            routeName != null
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
