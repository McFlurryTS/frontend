import 'package:McDonalds/widgets/product_card_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:McDonalds/providers/products_provider.dart';
import 'package:McDonalds/widgets/product_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CategoryScreen extends StatefulWidget {
  final String categoryId;
  final String? endpoint;

  const CategoryScreen({Key? key, required this.categoryId, this.endpoint})
    : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized && widget.endpoint != null) {
      Provider.of<ProductsProvider>(
        context,
        listen: false,
      ).fetchProductsByCategory(widget.endpoint!);
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Categoría: ${widget.categoryId}')),
      body: Consumer<ProductsProvider>(
        builder: (context, provider, _) {
          final isLoading = provider.isLoadingCategory(widget.endpoint ?? '');
          final products = provider.getProductsByCategory(
            widget.endpoint ?? '',
          );

          return Skeletonizer(
            enabled: isLoading,
            containersColor: Colors.grey[300],
            effect: ShimmerEffect(
              baseColor: Colors.grey[400]!,
              highlightColor: Colors.grey[200]!,
            ),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: isLoading ? 5 : products.length,
              itemBuilder: (context, index) {
                if (isLoading) {
                  return const ProductCardSkeleton();
                }
                return ProductCard(
                  product: products[index],
                  onTap:
                      () => Navigator.pushNamed(
                        context,
                        '/product_detail',
                        arguments: products[index],
                      ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
