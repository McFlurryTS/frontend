import 'package:McDonalds/providers/categories_provider.dart';
import 'package:McDonalds/widgets/category_card.dart';
import 'package:McDonalds/widgets/category_card_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoriesProvider>(
      builder: (context, provider, _) {
        final categories = provider.categories;
        final isLoading = provider.isLoading;

        return Skeletonizer(
          enabled: isLoading,
          containersColor: Colors.grey[300],
          effect: ShimmerEffect(
            baseColor: Colors.grey[400]!,
            highlightColor: Colors.grey[200]!,
          ),
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: isLoading ? 6 : categories.length,
            itemBuilder: (context, index) {
              if (isLoading) {
                return const CategoryCardSkeleton();
              }
              final category = categories[index];
              return CategoryCard(category: category);
            },
          ),
        );
      },
    );
  }
}
