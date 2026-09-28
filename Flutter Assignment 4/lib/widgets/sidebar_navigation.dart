import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class NavigationItemData {
  final String id;
  final String label;
  final IconData icon;
  final int? badgeCount;

  const NavigationItemData({
    required this.id,
    required this.label,
    required this.icon,
    this.badgeCount,
  });
}

class SidebarNavigation extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final bool isRail;

  static const List<NavigationItemData> navItems = [
    NavigationItemData(
      id: 'overview',
      label: 'Overview',
      icon: Icons.dashboard_rounded,
    ),
    NavigationItemData(
      id: 'analytics',
      label: 'Analytics',
      icon: Icons.insights_rounded,
      badgeCount: 3,
    ),
    NavigationItemData(
      id: 'projects',
      label: 'Projects',
      icon: Icons.folder_open_rounded,
    ),
    NavigationItemData(
      id: 'team',
      label: 'Engineering',
      icon: Icons.people_alt_rounded,
    ),
    NavigationItemData(
      id: 'cloud',
      label: 'Cloud Infrastructure',
      icon: Icons.cloud_queue_rounded,
    ),
    NavigationItemData(
      id: 'settings',
      label: 'Settings',
      icon: Icons.tune_rounded,
    ),
  ];

  const SidebarNavigation({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.isRail = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isRail) {
      return _buildNavigationRail(context, isDark);
    }

    return _buildFullSidebar(context, isDark);
  }

  // Collapsed Navigation Rail for Tablet
  Widget _buildNavigationRail(BuildContext context, bool isDark) {
    return Container(
      width: 72,
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
        border: Border(
          right: BorderSide(
            color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          // Logo Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primary.withValues(alpha: 0.35),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.dashboard_customize_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(height: 24),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: navItems.length,
              itemBuilder: (context, index) {
                final item = navItems[index];
                final isSelected = selectedIndex == index;
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  child: Tooltip(
                    message: item.label,
                    preferBelow: false,
                    child: InkWell(
                      onTap: () => onDestinationSelected(index),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.primary.withValues(alpha: 0.15)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          item.icon,
                          color: isSelected
                              ? AppTheme.primary
                              : (isDark
                                  ? AppTheme.darkTextSecondary
                                  : AppTheme.lightTextSecondary),
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Full Sidebar for Desktop
  Widget _buildFullSidebar(BuildContext context, bool isDark) {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
        border: Border(
          right: BorderSide(
            color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Branding Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primary.withValues(alpha: 0.35),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.dashboard_customize_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nexus Engine',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: isDark
                              ? AppTheme.darkTextPrimary
                              : AppTheme.lightTextPrimary,
                          letterSpacing: -0.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Enterprise v3.4',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? AppTheme.darkTextSecondary
                              : AppTheme.lightTextSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(),

          // Navigation Links
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              itemCount: navItems.length,
              separatorBuilder: (context, index) => const SizedBox(height: 4),
              itemBuilder: (context, index) {
                final item = navItems[index];
                final isSelected = selectedIndex == index;

                return InkWell(
                  onTap: () => onDestinationSelected(index),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primary.withValues(alpha: 0.12)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: isSelected
                          ? Border.all(
                              color: AppTheme.primary.withValues(alpha: 0.3),
                              width: 1,
                            )
                          : null,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          item.icon,
                          size: 20,
                          color: isSelected
                              ? AppTheme.primary
                              : (isDark
                                  ? AppTheme.darkTextSecondary
                                  : AppTheme.lightTextSecondary),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            item.label,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: isSelected
                                  ? AppTheme.primary
                                  : (isDark
                                      ? AppTheme.darkTextPrimary
                                      : AppTheme.lightTextPrimary),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (item.badgeCount != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.primary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${item.badgeCount}',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Pro Plan / System Status Box
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
                    : [const Color(0xFFEEF2FF), const Color(0xFFE0E7FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.primary.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppTheme.accentEmerald,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Expanded(
                      child: Text(
                        'All Systems Operational',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.accentEmerald,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'US-East Cluster • 99.98%',
                  style: TextStyle(
                    fontSize: 10,
                    color: isDark
                        ? AppTheme.darkTextSecondary
                        : AppTheme.lightTextSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
