import 'package:flutter/material.dart';
import '../models/dashboard_models.dart';
import '../theme/app_theme.dart';

class StorageAnalyticsCard extends StatelessWidget {
  final List<StorageCategory> categories;
  final String totalUsed;
  final String totalCapacity;

  const StorageAnalyticsCard({
    super.key,
    required this.categories,
    this.totalUsed = '101.5 GB',
    this.totalCapacity = '250 GB',
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkCard : AppTheme.lightCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.cloud_done_rounded,
                      size: 20,
                      color: AppTheme.secondary,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Infrastructure Allocation',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                '40.6% Used',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.secondary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Total Capacity Info using Row & Flexible
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                totalUsed,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  color: isDark
                      ? AppTheme.darkTextPrimary
                      : AppTheme.lightTextPrimary,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  'of $totalCapacity provisioned',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? AppTheme.darkTextSecondary
                        : AppTheme.lightTextSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Multi-Segment Progress Bar demonstrating EXPANDED flex weights
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              height: 12,
              decoration: BoxDecoration(
                color: isDark
                    ? AppTheme.darkCardElevated
                    : AppTheme.lightCardElevated,
              ),
              child: Row(
                children: [
                  // Each segment uses Expanded with flex proportional to percentage
                  ...categories.map((cat) {
                    final flexValue = (cat.percentage * 100).toInt();
                    return Expanded(
                      flex: flexValue > 0 ? flexValue : 1,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 0.5),
                        color: cat.color,
                      ),
                    );
                  }),
                  // Free space filler using Expanded
                  Expanded(
                    flex: 100 -
                        categories
                            .map((c) => (c.percentage * 100).toInt())
                            .fold(0, (a, b) => a + b),
                    child: Container(
                      color: isDark
                          ? AppTheme.darkBorder.withValues(alpha: 0.4)
                          : AppTheme.lightBorder,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Category Breakdown Rows demonstrating Flexible and Expanded
          Column(
            children: categories.map((cat) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  children: [
                    // Color indicator dot
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: cat.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Category Name in Expanded
                    Expanded(
                      child: Text(
                        cat.label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? AppTheme.darkTextPrimary
                              : AppTheme.lightTextPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Percentage & Size string in Flexible
                    Flexible(
                      fit: FlexFit.loose,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${(cat.percentage * 100).toInt()}%',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? AppTheme.darkTextSecondary
                                  : AppTheme.lightTextSecondary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            cat.sizeString,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? AppTheme.darkTextPrimary
                                  : AppTheme.lightTextPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
