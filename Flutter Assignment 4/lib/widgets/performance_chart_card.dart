import 'package:flutter/material.dart';
import '../models/dashboard_models.dart';
import '../theme/app_theme.dart';

class PerformanceChartCard extends StatefulWidget {
  final List<PerformanceDataPoint> dataPoints;

  const PerformanceChartCard({
    super.key,
    required this.dataPoints,
  });

  @override
  State<PerformanceChartCard> createState() => _PerformanceChartCardState();
}

class _PerformanceChartCardState extends State<PerformanceChartCard> {
  int? _hoveredIndex;

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
          // Header Row with Title and Range Selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.insights_rounded,
                      size: 20,
                      color: AppTheme.primary,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Weekly Throughput',
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppTheme.darkCardElevated
                      : AppTheme.lightCardElevated,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Last 7 Days',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppTheme.darkTextSecondary
                            : AppTheme.lightTextSecondary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 14,
                      color: isDark
                          ? AppTheme.darkTextSecondary
                          : AppTheme.lightTextSecondary,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Total Stat Callout
          Row(
            children: [
              Text(
                '\$165,000',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: isDark
                      ? AppTheme.darkTextPrimary
                      : AppTheme.lightTextPrimary,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.accentEmerald.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  '+14.2% peak',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.accentEmerald,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Custom Bar Chart using Row + Expanded & Flexible
          SizedBox(
            height: 140,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(widget.dataPoints.length, (index) {
                final point = widget.dataPoints[index];
                final isHovered = _hoveredIndex == index;

                return Expanded(
                  child: MouseRegion(
                    onEnter: (_) => setState(() => _hoveredIndex = index),
                    onExit: (_) => setState(() => _hoveredIndex = null),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Tooltip on hover
                          if (isHovered)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 2),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppTheme.darkSurface
                                    : AppTheme.lightTextPrimary,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                point.formattedValue,
                                style: const TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          else
                            const SizedBox(height: 16),

                          const SizedBox(height: 4),

                          // Bar container: Flexible proportion
                          Expanded(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: FractionallySizedBox(
                                heightFactor: point.value,
                                widthFactor: 0.65,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: isHovered
                                        ? AppTheme.cyanGradient
                                        : AppTheme.primaryGradient,
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(6),
                                    ),
                                    boxShadow: isHovered
                                        ? [
                                            BoxShadow(
                                              color: AppTheme.primary
                                                  .withValues(alpha: 0.4),
                                              blurRadius: 8,
                                              offset: const Offset(0, -2),
                                            ),
                                          ]
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          // X-Axis Day Label
                          Text(
                            point.label,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: isHovered
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: isHovered
                                  ? AppTheme.primary
                                  : (isDark
                                      ? AppTheme.darkTextSecondary
                                      : AppTheme.lightTextSecondary),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
