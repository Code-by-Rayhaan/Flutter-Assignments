import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/responsive_helper.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final bool isDarkMode;
  final VoidCallback onThemeToggle;
  final VoidCallback? onMenuPressed;
  final ValueChanged<String>? onSearchChanged;

  const AppHeader({
    super.key,
    required this.isDarkMode,
    required this.onThemeToggle,
    this.onMenuPressed,
    this.onSearchChanged,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isDesktop = ResponsiveHelper.isDesktop(context);

    return Container(
      height: preferredSize.height,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 10 : 16),
      decoration: BoxDecoration(
        color: isDarkMode ? AppTheme.darkSurface : AppTheme.lightSurface,
        border: Border(
          bottom: BorderSide(
            color: isDarkMode ? AppTheme.darkBorder : AppTheme.lightBorder,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Drawer toggle button on mobile & tablet
            if (!isDesktop) ...[
              IconButton(
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.all(6),
                constraints: const BoxConstraints(),
                onPressed: onMenuPressed,
                icon: const Icon(Icons.menu_rounded, size: 22),
                tooltip: 'Open navigation',
              ),
              const SizedBox(width: 8),
            ],

            // Logo & Title
            if (!isDesktop)
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.dashboard_customize_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              )
            else
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back, Rayhaan 👋',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isDarkMode
                          ? AppTheme.darkTextPrimary
                          : AppTheme.lightTextPrimary,
                    ),
                  ),
                  Text(
                    'Here is your executive ecosystem overview',
                    style: TextStyle(
                      fontSize: 11,
                      color: isDarkMode
                          ? AppTheme.darkTextSecondary
                          : AppTheme.lightTextSecondary,
                    ),
                  ),
                ],
              ),

            const SizedBox(width: 12),

            // Search Bar inside Expanded widget
            Expanded(
              child: Container(
                height: 38,
                constraints: const BoxConstraints(maxWidth: 380),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? AppTheme.darkCardElevated
                      : AppTheme.lightCardElevated,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isDarkMode
                        ? AppTheme.darkBorder
                        : AppTheme.lightBorder,
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Icon(
                      Icons.search_rounded,
                      size: 16,
                      color: isDarkMode
                          ? AppTheme.darkTextSecondary
                          : AppTheme.lightTextSecondary,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: TextField(
                        onChanged: onSearchChanged,
                        decoration: InputDecoration(
                          hintText: isDesktop
                              ? 'Search metrics, tasks, team...'
                              : 'Search...',
                          hintStyle: TextStyle(
                            fontSize: 12,
                            color: isDarkMode
                                ? AppTheme.darkTextSecondary
                                : AppTheme.lightTextSecondary,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        style: TextStyle(
                          fontSize: 12,
                          color: isDarkMode
                              ? AppTheme.darkTextPrimary
                              : AppTheme.lightTextPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 8),

            // Action Buttons in Flexible
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Theme Toggle Button
                IconButton(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.all(6),
                  constraints: const BoxConstraints(),
                  onPressed: onThemeToggle,
                  tooltip: isDarkMode
                      ? 'Switch to Light Mode'
                      : 'Switch to Dark Mode',
                  icon: Icon(
                    isDarkMode
                        ? Icons.light_mode_rounded
                        : Icons.dark_mode_rounded,
                    color: isDarkMode
                        ? AppTheme.accentAmber
                        : AppTheme.primaryDark,
                    size: 19,
                  ),
                ),

                const SizedBox(width: 4),

                // Notifications Button with badge
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.all(6),
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('3 new notifications received'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      tooltip: 'Notifications',
                      icon: const Icon(
                        Icons.notifications_none_rounded,
                        size: 20,
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: AppTheme.accentRose,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),

                if (isDesktop) ...[
                  const SizedBox(width: 8),
                  // User Avatar Pill
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? AppTheme.darkCardElevated
                          : AppTheme.lightCardElevated,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: isDarkMode
                            ? AppTheme.darkBorder
                            : AppTheme.lightBorder,
                      ),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 13,
                          backgroundColor: AppTheme.primary,
                          child: Text(
                            'RS',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Rayhaan S.',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDarkMode
                                ? AppTheme.darkTextPrimary
                                : AppTheme.lightTextPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
