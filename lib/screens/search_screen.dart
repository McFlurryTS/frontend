import 'package:McDonalds/models/product_model.dart';
import 'package:McDonalds/providers/products_provider.dart';
import 'package:McDonalds/utils/rocket_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:diacritic/diacritic.dart';
import 'package:McDonalds/widgets/product_menu_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with AutomaticKeepAliveClientMixin {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  Timer? _debounce;
  List<Product> _filteredProducts = [];
  bool _isSearching = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _initializeProducts();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _initializeProducts() {
    final products =
        Provider.of<ProductsProvider>(
          context,
          listen: false,
        ).productsByCategory.values.expand((products) => products).toList();
    setState(() => _filteredProducts = products);
  }

  String _normalizeText(String text) {
    return removeDiacritics(text.toLowerCase().trim());
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      setState(() {
        _isSearching = query.isNotEmpty;
        _filterProducts(query);
      });
    });
  }

  void _filterProducts(String query) {
    final allProducts =
        Provider.of<ProductsProvider>(
          context,
          listen: false,
        ).productsByCategory.values.expand((products) => products).toList();

    if (query.isEmpty) {
      _filteredProducts = allProducts;
    } else {
      final normalizedQuery = _normalizeText(query);
      _filteredProducts =
          allProducts.where((product) {
            final normalizedName = _normalizeText(product.name);
            final normalizedDescription = _normalizeText(product.description);
            return normalizedName.contains(normalizedQuery) ||
                normalizedDescription.contains(normalizedQuery);
          }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: RocketColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: RocketColors.text,
                ),
                decoration: InputDecoration(
                  hintText: 'Buscar productos...',
                  hintStyle: GoogleFonts.poppins(color: Colors.grey[400]),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: RocketColors.text,
                  ),
                  suffixIcon:
                      _isSearching
                          ? IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: RocketColors.text,
                            ),
                            onPressed: () {
                              _searchController.clear();
                              _onSearchChanged('');
                            },
                          )
                          : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ),
            Expanded(
              child:
                  _filteredProducts.isEmpty
                      ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _searchController.text.isEmpty
                                  ? Icons.search
                                  : Icons.search_off,
                              size: 64,
                              color: Colors.grey[300],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _searchController.text.isEmpty
                                  ? 'Busca tus productos favoritos'
                                  : 'No se encontraron productos',
                              style: GoogleFonts.poppins(
                                color: Colors.grey[400],
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )
                      : CustomScrollView(
                        controller: _scrollController,
                        physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics(),
                          decelerationRate: ScrollDecelerationRate.fast,
                        ),
                        slivers: [
                          SliverPadding(
                            padding: const EdgeInsets.all(16),
                            sliver: SliverGrid(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.7,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                  ),
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  if (index >= _filteredProducts.length) {
                                    return null;
                                  }
                                  final product = _filteredProducts[index];
                                  return RepaintBoundary(
                                    child: _buildSearchResultCard(
                                      context,
                                      product,
                                    ),
                                  );
                                },
                                childCount: _filteredProducts.length,
                                addRepaintBoundaries: true,
                                addAutomaticKeepAlives: true,
                              ),
                            ),
                          ),
                        ],
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResultCard(BuildContext context, Product product) {
    return ProductMenuCard(
      key: ValueKey(product.id),
      product: product,
      backgroundColor: const Color(0xFFFAFAFA),
      onTap:
          () => Navigator.pushNamed(
            context,
            '/product_detail',
            arguments: product,
          ),
    );
  }
}
