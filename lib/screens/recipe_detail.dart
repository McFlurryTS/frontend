/*import 'package:flutter/material.dart';
import 'package:McDonalds/models/product_model.dart';
import 'package:McDonalds/utils/rocket_theme.dart';

class RecipeDetail extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetail({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RocketColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: RocketColors.secondary,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: recipe.id,
                child: Image.network(
                  recipe.imageLink,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder:
                      (_, __, ___) => Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.fastfood, size: 80),
                      ),
                ),
              ),
              title: Text(
                recipe.name,
                style: RocketTextStyles.headline2.copyWith(color: Colors.white),
              ),
              centerTitle: true,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTags(),
                  const SizedBox(height: 16),
                  Text(
                    recipe.description,
                    style: RocketTextStyles.body.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${recipe.price.toStringAsFixed(2)}',
                        style: RocketTextStyles.headline1.copyWith(
                          color: RocketColors.secondary,
                          fontSize: 28,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.local_fire_department,
                            color: RocketColors.warning,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${recipe.calories} kcal',
                            style: RocketTextStyles.body,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.shopping_cart),
                      label: const Text('Agregar al pedido'),
                      style: RocketButtonStyles.primary,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Producto agregado al pedido'),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTags() {
    final tags = <Widget>[];

    if (recipe.isNew) {
      tags.add(_buildTag('Nuevo', RocketColors.success));
    }
    if (recipe.hasDeal) {
      tags.add(_buildTag('En oferta', RocketColors.error));
    }

    return Row(children: tags);
  }

  Widget _buildTag(String label, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: RocketTextStyles.body.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
*/
