import 'package:McDonalds/widgets/product_card_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:McDonalds/providers/products_provider.dart';
import 'package:McDonalds/widgets/product_card.dart';
import 'package:McDonalds/utils/rocket_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CategoryScreen extends StatefulWidget {
  final String categoryId;

  const CategoryScreen({super.key, required this.categoryId});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  bool _isFirstLoad = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadProducts() {
    final provider = Provider.of<ProductsProvider>(context, listen: false);
    if (!provider.isInitialized) {
      provider.fetchMenuCompleto();
    } else {
      // Si ya está inicializado, solo actualizar el estado local
      if (mounted) {
        setState(() => _isFirstLoad = false);
      }
    }
  }

  String _getCategoryTitle(String categoryId) {
    return categoryId
        .split('_')
        .map((word) => word.substring(0, 1) + word.substring(1).toLowerCase())
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: RocketColors.background,
      appBar: AppBar(
        title: Text(
          _getCategoryTitle(widget.categoryId),
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFFDA291C),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<ProductsProvider>(
        builder: (context, provider, _) {
          final products = provider.getProductsByCategory(widget.categoryId);
          final shouldShowSkeleton = provider.isLoading && _isFirstLoad;

          if (!provider.isLoading) {
            _isFirstLoad = false;
          }

          return Skeletonizer(
            enabled: shouldShowSkeleton,
            containersColor: Colors.grey[300],
            effect: ShimmerEffect(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
            ),
            child: CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
                decelerationRate: ScrollDecelerationRate.fast,
              ),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (shouldShowSkeleton) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: RepaintBoundary(
                              child: ProductCardSkeleton(),
                            ),
                          );
                        }

                        if (index >= products.length) return null;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: RepaintBoundary(
                            child: ProductCard(
                              key: ValueKey(products[index].id),
                              product: products[index],
                              onTap:
                                  () => Navigator.pushNamed(
                                    context,
                                    '/product_detail',
                                    arguments: products[index],
                                  ),
                            ),
                          ),
                        );
                      },
                      childCount: shouldShowSkeleton ? 5 : products.length,
                      addRepaintBoundaries: true,
                      addAutomaticKeepAlives: true,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
