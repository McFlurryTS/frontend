import 'package:McDonalds/models/product_model.dart';
import 'package:McDonalds/providers/products_provider.dart';
import 'package:McDonalds/utils/rocket_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:diacritic/diacritic.dart';
import 'package:McDonalds/widgets/product_menu_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
  bool _isLoading = true;

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

  Future<void> _initializeProducts() async {
    final provider = Provider.of<ProductsProvider>(context, listen: false);
    if (!provider.isInitialized) {
      await provider.fetchMenuCompleto();
    }
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _isSearching = query.isNotEmpty;
        if (_isSearching) {
          _searchProducts(query);
        } else {
          _filteredProducts = [];
        }
      });
    });
  }

  void _searchProducts(String query) {
    final provider = Provider.of<ProductsProvider>(context, listen: false);
    final allProducts =
        provider.productsByCategory.values.expand((e) => e).toList();
    final normalizedQuery = _normalizeText(query);

    setState(() {
      _filteredProducts =
          allProducts.where((product) {
            final normalizedName = _normalizeText(product.name);
            final normalizedDescription = _normalizeText(product.description);
            return normalizedName.contains(normalizedQuery) ||
                normalizedDescription.contains(normalizedQuery);
          }).toList();
    });
  }

  String _normalizeText(String text) {
    return removeDiacritics(text.toLowerCase().trim());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Consumer<ProductsProvider>(
      builder: (context, provider, _) {
        if (provider.hasError) {
          return Scaffold(
            backgroundColor: RocketColors.background,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: BackButton(color: RocketColors.text),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      'Estamos mejorando la app, intenta probar de nuevo más tarde',
                      style: RocketTextStyles.body.copyWith(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() => _isLoading = true);
                      provider.retryLoading();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reintentar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: RocketColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: RocketColors.background,
          body: SafeArea(
            child: Column(
              children: [
                Skeletonizer(
                  enabled: _isLoading,
                  containersColor: Colors.grey[300],
                  effect: ShimmerEffect(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                  ),
                  child: Container(
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
                      enabled: !_isLoading,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: RocketColors.text,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Buscar productos...',
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.grey[400],
                        ),
                        prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child:
                      _isLoading
                          ? Skeletonizer(
                            enabled: true,
                            containersColor: Colors.grey[300],
                            effect: ShimmerEffect(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                            ),
                            child: GridView.builder(
                              padding: const EdgeInsets.all(16),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.75,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                  ),
                              itemCount: 6,
                              itemBuilder: (context, index) {
                                return ProductMenuCard(
                                  product: Product(
                                    id: 'skeleton-$index',
                                    category: 'SKELETON',
                                    name:
                                        'Producto de ejemplo largo con dos líneas',
                                    description: '',
                                    image: '',
                                    country: 'MX',
                                    active: true,
                                    updated_at: DateTime.now(),
                                    price: 99.0,
                                  ),
                                  backgroundColor: Colors.white,
                                  onTap: () {},
                                );
                              },
                            ),
                          )
                          : _isSearching
                          ? _filteredProducts.isEmpty
                              ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.search_off,
                                      size: 64,
                                      color: Colors.grey[400],
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'No encontramos productos que coincidan\ncon tu búsqueda',
                                      style: RocketTextStyles.body.copyWith(
                                        color: Colors.grey[600],
                                        fontSize: 16,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              )
                              : GridView.builder(
                                controller: _scrollController,
                                padding: const EdgeInsets.all(16),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 0.75,
                                      crossAxisSpacing: 12,
                                      mainAxisSpacing: 12,
                                    ),
                                itemCount: _filteredProducts.length,
                                itemBuilder: (context, index) {
                                  return _buildSearchResultCard(
                                    context,
                                    _filteredProducts[index],
                                  );
                                },
                              )
                          : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  '¿Qué estás buscando hoy?',
                                  style: RocketTextStyles.body.copyWith(
                                    color: Colors.grey[600],
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchResultCard(BuildContext context, Product product) {
    return ProductMenuCard(
      key: ValueKey(product.id),
      product: product,
      backgroundColor: Colors.white,
      onTap:
          () => Navigator.pushNamed(
            context,
            '/product_detail',
            arguments: product,
          ),
    );
  }
}
