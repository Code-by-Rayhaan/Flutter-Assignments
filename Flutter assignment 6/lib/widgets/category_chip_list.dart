import 'package:flutter/material.dart';

class CategoryChipList extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;
  final Map<String, int>? categoryCounts;

  const CategoryChipList({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
    this.categoryCounts,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 48,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == selectedCategory;
          final count = categoryCounts?[category];

          return FilterChip(
            selected: isSelected,
            showCheckmark: false,
            avatar: isSelected
                ? Icon(
                    Icons.check_circle_rounded,
                    size: 16,
                    color: theme.colorScheme.onPrimary,
                  )
                : null,
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  category,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurface,
                  ),
                ),
                if (count != null) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 1.5,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? theme.colorScheme.onPrimary.withValues(alpha: 0.25)
                          : theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$count',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            selectedColor: theme.colorScheme.primary,
            backgroundColor: theme.colorScheme.surfaceContainerLow,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: BorderSide(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outlineVariant,
              ),
            ),
            onSelected: (_) => onCategorySelected(category),
          );
        },
      ),
    );
  }
}
