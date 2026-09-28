import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/responsive_helper.dart';

class ResponsiveInfoBanner extends StatelessWidget {
  const ResponsiveInfoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = ResponsiveHelper.screenWidth(context);
    final height = ResponsiveHelper.screenHeight(context);
    final orientation = ResponsiveHelper.orientation(context);
    final isDesktop = ResponsiveHelper.isDesktop(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final statCols = ResponsiveHelper.getStatGridColumns(context);
    final actionCols = ResponsiveHelper.getQuickActionsColumns(context);

    Color badgeColor;
    String layoutMode;
    if (isDesktop) {
      badgeColor = AppTheme.primary;
      layoutMode = 'Split (7:3)';
    } else if (isTablet) {
      badgeColor = AppTheme.secondary;
      layoutMode = 'Rail + Stack';
    } else {
      badgeColor = AppTheme.accentEmerald;
      layoutMode = 'Single Column';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkCard : AppTheme.lightCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: badgeColor.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: badgeColor.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header of Banner
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.devices_rounded,
                  size: 16,
                  color: badgeColor,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Responsive MediaQuery Inspector',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppTheme.darkTextPrimary
                        : AppTheme.lightTextPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: badgeColor.withValues(alpha: 0.4),
                  ),
                ),
                child: Text(
                  isDesktop
                      ? 'DESKTOP'
                      : (isTablet ? 'TABLET' : 'MOBILE'),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: badgeColor,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Responsive Metrics Row using Wrap for adaptability
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _buildMetricChip(
                context,
                icon: Icons.aspect_ratio_rounded,
                label: 'Size',
                value: '${width.toInt()} × ${height.toInt()}',
                isDark: isDark,
              ),
              _buildMetricChip(
                context,
                icon: Icons.screen_rotation_rounded,
                label: 'View',
                value: orientation == Orientation.portrait ? 'Portrait' : 'Landscape',
                isDark: isDark,
              ),
              _buildMetricChip(
                context,
                icon: Icons.grid_view_rounded,
                label: 'Grids',
                value: 'KPI:$statCols | Act:$actionCols',
                isDark: isDark,
              ),
              _buildMetricChip(
                context,
                icon: Icons.view_sidebar_rounded,
                label: 'Layout',
                value: layoutMode,
                isDark: isDark,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricChip(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkCardElevated : AppTheme.lightCardElevated,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 13,
            color: isDark
                ? AppTheme.darkTextSecondary
                : AppTheme.lightTextSecondary,
          ),
          const SizedBox(width: 5),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 11,
              color: isDark
                  ? AppTheme.darkTextSecondary
                  : AppTheme.lightTextSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: isDark
                  ? AppTheme.darkTextPrimary
                  : AppTheme.lightTextPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
