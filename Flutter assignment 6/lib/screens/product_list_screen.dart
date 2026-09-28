import 'package:flutter/material.dart';
import '../data/mock_products.dart';
import '../models/product.dart';
import '../widgets/category_chip_list.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  // Master list of products
  late List<Product> _allProducts;

  // Filtered list displayed in ListView.builder
  List<Product> _filteredProducts = [];

  // Filter & Search state
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'All';
  SortOption _selectedSort = SortOption.featured;
  double _maxPrice = 150000.0;
  final double _maxPossiblePrice = 150000.0;
  bool _inStockOnly = false;
  bool _showFavoritesOnly = false;

  @override
  void initState() {
    super.initState();
    _allProducts = MockProducts.getProducts();
    _applyFilters();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Core setState filtering and sorting logic
  void _applyFilters() {
    setState(() {
      _filteredProducts = _allProducts.where((product) {
        // 1. Search Query Filter (name, brand, category, tags, description)
        if (_searchQuery.isNotEmpty) {
          final query = _searchQuery.toLowerCase().trim();
          final matchesName = product.name.toLowerCase().contains(query);
          final matchesBrand = product.brand.toLowerCase().contains(query);
          final matchesCategory = product.category.toLowerCase().contains(query);
          final matchesTag =
              product.tags.any((tag) => tag.toLowerCase().contains(query));
          final matchesDescription =
              product.description.toLowerCase().contains(query);

          if (!matchesName &&
              !matchesBrand &&
              !matchesCategory &&
              !matchesTag &&
              !matchesDescription) {
            return false;
          }
        }

        // 2. Category Filter
        if (_selectedCategory != 'All' &&
            product.category != _selectedCategory) {
          return false;
        }

        // 3. Price Filter
        if (product.price > _maxPrice) {
          return false;
        }

        // 4. In Stock Filter
        if (_inStockOnly && !product.inStock) {
          return false;
        }

        // 5. Favorites Filter
        if (_showFavoritesOnly && !product.isFavorite) {
          return false;
        }

        return true;
      }).toList();

      // Apply Sorting
      switch (_selectedSort) {
        case SortOption.priceLowToHigh:
          _filteredProducts.sort((a, b) => a.price.compareTo(b.price));
          break;
        case SortOption.priceHighToLow:
          _filteredProducts.sort((a, b) => b.price.compareTo(a.price));
          break;
        case SortOption.topRated:
          _filteredProducts.sort((a, b) => b.rating.compareTo(a.rating));
          break;
        case SortOption.nameAZ:
          _filteredProducts.sort((a, b) => a.name.compareTo(b.name));
          break;
        case SortOption.featured:
          // Keep original order
          break;
      }
    });
  }

  void _onSearchChanged(String value) {
    _searchQuery = value;
    _applyFilters();
  }

  void _onCategorySelected(String category) {
    _selectedCategory = category;
    _applyFilters();
  }

  void _toggleFavorite(Product product) {
    setState(() {
      final index = _allProducts.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        final updated = _allProducts[index].copyWith(
          isFavorite: !_allProducts[index].isFavorite,
        );
        _allProducts[index] = updated;
      }
    });
    _applyFilters();
  }

  void _resetAllFilters() {
    _searchController.clear();
    _searchQuery = '';
    _selectedCategory = 'All';
    _selectedSort = SortOption.featured;
    _maxPrice = _maxPossiblePrice;
    _inStockOnly = false;
    _showFavoritesOnly = false;
    _applyFilters();
  }

  bool get _hasActiveFilters {
    return _searchQuery.isNotEmpty ||
        _selectedCategory != 'All' ||
        _selectedSort != SortOption.featured ||
        _maxPrice < _maxPossiblePrice ||
        _inStockOnly ||
        _showFavoritesOnly;
  }

  Map<String, int> _calculateCategoryCounts() {
    final counts = <String, int>{};
    counts['All'] = _allProducts.length;
    for (final category in MockProducts.categories) {
      if (category == 'All') continue;
      counts[category] =
          _allProducts.where((p) => p.category == category).length;
    }
    return counts;
  }

  void _openFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheet(
        currentSort: _selectedSort,
        currentMaxPrice: _maxPrice,
        maxPossiblePrice: _maxPossiblePrice,
        inStockOnly: _inStockOnly,
        onApplyFilters: ({
          required sortOption,
          required maxPrice,
          required inStockOnly,
        }) {
          _selectedSort = sortOption;
          _maxPrice = maxPrice;
          _inStockOnly = inStockOnly;
          _applyFilters();
        },
        onResetFilters: () {
          _selectedSort = SortOption.featured;
          _maxPrice = _maxPossiblePrice;
          _inStockOnly = false;
          _applyFilters();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categoryCounts = _calculateCategoryCounts();
    final favoriteCount = _allProducts.where((p) => p.isFavorite).length;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Discover Products',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
            ),
            Text(
              '${_filteredProducts.length} of ${_allProducts.length} items available',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          // Favorites filter toggle
          IconButton(
            tooltip: _showFavoritesOnly
                ? 'Show All Products'
                : 'Show Favorites Only ($favoriteCount)',
            icon: Badge(
              isLabelVisible: favoriteCount > 0,
              label: Text('$favoriteCount'),
              child: Icon(
                _showFavoritesOnly
                    ? Icons.favorite_rounded
                    : Icons.favorite_outline_rounded,
                color: _showFavoritesOnly ? Colors.red : null,
              ),
            ),
            onPressed: () {
              setState(() {
                _showFavoritesOnly = !_showFavoritesOnly;
              });
              _applyFilters();
            },
          ),
          IconButton(
            tooltip: 'Cart',
            icon: const Badge(
              label: Text('2'),
              child: Icon(Icons.shopping_cart_outlined),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cart opened (2 items)'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar & Filter Action Button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: SearchBar(
                    controller: _searchController,
                    hintText: 'Search by name, brand, tag...',
                    leading: const Icon(Icons.search_rounded),
                    trailing: [
                      if (_searchQuery.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.clear_rounded, size: 20),
                          onPressed: () {
                            _searchController.clear();
                            _onSearchChanged('');
                          },
                        ),
                    ],
                    onChanged: _onSearchChanged,
                    elevation: const WidgetStatePropertyAll(1),
                    padding: const WidgetStatePropertyAll(
                      EdgeInsets.symmetric(horizontal: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Filter Bottom Sheet Button
                Badge(
                  isLabelVisible: _selectedSort != SortOption.featured ||
                      _maxPrice < _maxPossiblePrice ||
                      _inStockOnly,
                  smallSize: 8,
                  child: IconButton.filledTonal(
                    icon: const Icon(Icons.tune_rounded),
                    tooltip: 'Filter & Sort Options',
                    onPressed: _openFilterBottomSheet,
                  ),
                ),
              ],
            ),
          ),

          // Horizontal Category Filter Chips
          CategoryChipList(
            categories: MockProducts.categories,
            selectedCategory: _selectedCategory,
            categoryCounts: categoryCounts,
            onCategorySelected: _onCategorySelected,
          ),
          const SizedBox(height: 8),

          // Active filter banner (if any active filters exist)
          if (_hasActiveFilters)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.filter_alt_rounded,
                    size: 16,
                    color: theme.colorScheme.onSecondaryContainer,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      _buildActiveFilterDescription(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSecondaryContainer,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  InkWell(
                    onTap: _resetAllFilters,
                    child: Text(
                      'Clear',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Dynamic Product Listing using ListView.builder
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                final messenger = ScaffoldMessenger.of(context);
                await Future.delayed(const Duration(milliseconds: 600));
                if (!mounted) return;
                _applyFilters();
                messenger.showSnackBar(
                  const SnackBar(
                    content: Text('Product catalog updated!'),
                    duration: Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: _filteredProducts.isEmpty
                  ? _buildEmptyState(theme)
                  : ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      padding: const EdgeInsets.only(top: 4, bottom: 24),
                      itemCount: _filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = _filteredProducts[index];
                        return ProductCard(
                          product: product,
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailScreen(
                                  product: product,
                                  onToggleFavorite: (updatedProduct) {
                                    _toggleFavorite(product);
                                  },
                                ),
                              ),
                            );
                            if (!mounted) return;
                            _applyFilters();
                          },
                          onToggleFavorite: () => _toggleFavorite(product),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  String _buildActiveFilterDescription() {
    final parts = <String>[];
    if (_searchQuery.isNotEmpty) parts.add('Search: "$_searchQuery"');
    if (_selectedCategory != 'All') parts.add('Category: $_selectedCategory');
    if (_showFavoritesOnly) parts.add('Favorites Only');
    if (_inStockOnly) parts.add('In Stock');
    if (_maxPrice < _maxPossiblePrice) {
      parts.add('Max: ₹${_maxPrice.toStringAsFixed(0)}');
    }
    if (_selectedSort != SortOption.featured) {
      parts.add('Sort: ${_selectedSort.label}');
    }
    return parts.join(' • ');
  }

  Widget _buildEmptyState(ThemeData theme) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            padding: const EdgeInsets.all(32),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.search_off_rounded,
                    size: 64,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'No products found',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _searchQuery.isNotEmpty
                      ? 'No items matched your query "$_searchQuery". Try checking spelling or relaxing filters.'
                      : 'No items match your active filters.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: _resetAllFilters,
                  icon: const Icon(Icons.filter_alt_off_rounded),
                  label: const Text('Reset All Filters'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
