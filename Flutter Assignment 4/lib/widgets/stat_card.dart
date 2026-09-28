import 'package:flutter/material.dart';
import '../models/dashboard_models.dart';
import '../theme/app_theme.dart';

class StatCard extends StatelessWidget {
  final StatMetric metric;

  const StatCard({
    super.key,
    required this.metric,
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
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Top Row: Icon Container & Trend Pill
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Gradient Icon Badge
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: metric.gradient,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: metric.gradient.colors.first.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(
                  metric.icon,
                  color: Colors.white,
                  size: 19,
                ),
              ),

              const SizedBox(width: 6),

              // Trend Badge
              Flexible(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: metric.isPositive
                        ? AppTheme.accentEmerald.withValues(alpha: 0.12)
                        : AppTheme.accentRose.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: metric.isPositive
                          ? AppTheme.accentEmerald.withValues(alpha: 0.3)
                          : AppTheme.accentRose.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        metric.isPositive
                            ? Icons.trending_up_rounded
                            : Icons.trending_down_rounded,
                        size: 12,
                        color: metric.isPositive
                            ? AppTheme.accentEmerald
                            : AppTheme.accentRose,
                      ),
                      const SizedBox(width: 3),
                      Flexible(
                        child: Text(
                          '${metric.isPositive ? '+' : ''}${metric.changePercentage}%',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: metric.isPositive
                                ? AppTheme.accentEmerald
                                : AppTheme.accentRose,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // Center: Title & Value wrapped in Flexible
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  metric.title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? AppTheme.darkTextSecondary
                        : AppTheme.lightTextSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      metric.value,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                        color: isDark
                            ? AppTheme.darkTextPrimary
                            : AppTheme.lightTextPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 4),

          // Bottom: Progress Bar & Subtitle
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: metric.progress,
                  minHeight: 4,
                  backgroundColor: isDark
                      ? AppTheme.darkBorder
                      : AppTheme.lightBorder.withValues(alpha: 0.6),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    metric.gradient.colors.first,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                metric.subtitle,
                style: TextStyle(
                  fontSize: 10,
                  color: isDark
                      ? AppTheme.darkTextSecondary.withValues(alpha: 0.8)
                      : AppTheme.lightTextSecondary.withValues(alpha: 0.8),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
