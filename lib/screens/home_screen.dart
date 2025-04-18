import 'package:McDonalds/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:McDonalds/providers/categories_provider.dart';
import 'package:McDonalds/widgets/category_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categoriesProvider = Provider.of<CategoriesProvider>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (categoriesProvider.categories.isEmpty &&
          !categoriesProvider.isLoading) {
        categoriesProvider.fetchCategories();
      }
    });

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            snap: false,
            pinned: false, // <- este es el cambio clave
            backgroundColor: const Color(0xFFDA291C),
            flexibleSpace: FlexibleSpaceBar(
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
                    bottom: 25,
                    top: 10,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
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
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: _buildCustomMasonryGrid(context, categoriesProvider),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomMasonryGrid(
    BuildContext context,
    CategoriesProvider provider,
  ) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error != null) {
      return Center(
        child: Text(provider.error!, style: const TextStyle(color: Colors.red)),
      );
    }

    final categories = provider.categories;

    final List<Widget> leftColumn = [];
    final List<Widget> rightColumn = [];

    for (int i = 0; i < categories.length; i++) {
      final card = _buildCategoryCard(context, categories[i]);
      if (leftColumn.length == 0) {
        leftColumn.add(
          _buildFakeCard(
            icon: Icons.search,
            text: 'Buscar...',
            height: 80,
            routeName: '/search',
            context: context,
          ),
        );
      }
      if (rightColumn.length == 2) {
        rightColumn.add(
          _buildFakeCard(
            icon: Icons.menu,
            text: 'Menú',
            height: 80,
            routeName: '/menu',
            context: context,
          ),
        );
      }
      if (leftColumn.length <= rightColumn.length) {
        leftColumn.add(card);
      } else {
        rightColumn.add(card);
      }
    }

    return Column(
      children: [
        Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Container(
              color: Colors.grey[200],
              width: double.infinity,
              child: Image.network(
                'https://scontent.fgdl16-1.fna.fbcdn.net/v/t39.30808-6/487507136_1063725395792790_914230062381694866_n.jpg?_nc_cat=101&ccb=1-7&_nc_sid=86c6b0&_nc_ohc=DKE6j9UjwyoQ7kNvwGiuSUt&_nc_oc=AdncQE9Zv6Jc00nVvUqVzSnQUgi6DNcgC8W8PwwU6QrFuJEoina-ld2UzhDLfJNReOAR-F-XKGe7qVUeFPIXdu0g&_nc_zt=23&_nc_ht=scontent.fgdl16-1.fna&_nc_gid=BxK3shrMoOVPulJxNtS3lg&oh=00_AfH_i_NNfjslykzMK62SPHRA0o9j1lPnppZZo5qzBl3sJA&oe=680620B5',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  for (final w in leftColumn) ...[
                    w,
                    const SizedBox(height: 20),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                children: [
                  for (final w in rightColumn) ...[
                    w,
                    const SizedBox(height: 20),
                  ],
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
    return GestureDetector(
      onTap: () {
        if (routeName != null) {
          Navigator.pushNamed(context, routeName);
        }
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(color: Colors.grey[200]!, width: 0),
        ),
        child: Container(
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: const LinearGradient(
              colors: [Color(0xFFfceaa2), Color(0xFFfcc29c)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.grey[600], size: 26),
              const SizedBox(width: 12),
              Text(
                text,
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
