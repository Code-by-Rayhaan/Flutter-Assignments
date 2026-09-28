import 'package:flutter/material.dart';

enum SortOption {
  featured('Featured', Icons.auto_awesome_rounded),
  priceLowToHigh('Price: Low to High', Icons.arrow_upward_rounded),
  priceHighToLow('Price: High to Low', Icons.arrow_downward_rounded),
  topRated('Top Rated', Icons.star_rounded),
  nameAZ('Name (A-Z)', Icons.sort_by_alpha_rounded);

  final String label;
  final IconData icon;
  const SortOption(this.label, this.icon);
}

class FilterBottomSheet extends StatefulWidget {
  final SortOption currentSort;
  final double currentMaxPrice;
  final double maxPossiblePrice;
  final bool inStockOnly;
  final Function({
    required SortOption sortOption,
    required double maxPrice,
    required bool inStockOnly,
  }) onApplyFilters;
  final VoidCallback onResetFilters;

  const FilterBottomSheet({
    super.key,
    required this.currentSort,
    required this.currentMaxPrice,
    required this.maxPossiblePrice,
    required this.inStockOnly,
    required this.onApplyFilters,
    required this.onResetFilters,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late SortOption _selectedSort;
  late double _maxPrice;
  late bool _inStockOnly;

  @override
  void initState() {
    super.initState();
    _selectedSort = widget.currentSort;
    _maxPrice = widget.currentMaxPrice;
    _inStockOnly = widget.inStockOnly;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filter & Sort',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _selectedSort = SortOption.featured;
                    _maxPrice = widget.maxPossiblePrice;
                    _inStockOnly = false;
                  });
                  widget.onResetFilters();
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Reset All'),
              ),
            ],
          ),
          const Divider(height: 24),

          // Sort Options Section
          Text(
            'Sort By',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: SortOption.values.map((sort) {
              final isSelected = _selectedSort == sort;
              return ChoiceChip(
                avatar: Icon(
                  sort.icon,
                  size: 16,
                  color: isSelected
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.primary,
                ),
                label: Text(sort.label),
                selected: isSelected,
                selectedColor: theme.colorScheme.primary,
                labelStyle: TextStyle(
                  color: isSelected
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurface,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                onSelected: (val) {
                  if (val) {
                    setState(() => _selectedSort = sort);
                  }
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Price Range Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Max Price',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '₹${_maxPrice.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              showValueIndicator: ShowValueIndicator.onDrag,
            ),
            child: Slider(
              value: _maxPrice,
              min: 5000,
              max: widget.maxPossiblePrice,
              divisions: ((widget.maxPossiblePrice - 5000) / 2500).round().clamp(1, 100),
              label: '₹${_maxPrice.toStringAsFixed(0)}',
              onChanged: (val) {
                setState(() => _maxPrice = val);
              },
            ),
          ),
          const SizedBox(height: 8),

          // In-Stock Only Switch
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'In Stock Only',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: const Text(
              'Hide items currently out of stock',
              style: TextStyle(fontSize: 12),
            ),
            value: _inStockOnly,
            onChanged: (val) {
              setState(() => _inStockOnly = val);
            },
          ),
          const SizedBox(height: 20),

          // Action Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton.icon(
              icon: const Icon(Icons.check_rounded),
              label: const Text(
                'Apply Filters',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                widget.onApplyFilters(
                  sortOption: _selectedSort,
                  maxPrice: _maxPrice,
                  inStockOnly: _inStockOnly,
                );
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
