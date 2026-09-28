import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/profile_card.dart';

/// The main Profile Screen featuring interactive theme controls,
/// responsive card centering, and visual styling.
class ProfileScreen extends StatelessWidget {
  final CustomColorPreset currentPreset;
  final bool isDarkMode;
  final ValueChanged<CustomColorPreset> onPresetChanged;
  final ValueChanged<bool> onThemeModeChanged;

  const ProfileScreen({
    super.key,
    required this.currentPreset,
    required this.isDarkMode,
    required this.onPresetChanged,
    required this.onThemeModeChanged,
  });

  void _showColorPickerModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final theme = Theme.of(ctx);
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Custom Theme Preset',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(ctx),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...AppTheme.colorPresets.map((preset) {
                final isSelected = preset.name == currentPreset.name;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: InkWell(
                    onTap: () {
                      onPresetChanged(preset);
                      Navigator.pop(ctx);
                    },
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? preset.primary.withValues(alpha: 0.12)
                            : theme.colorScheme.onSurface.withValues(alpha: 0.04),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected ? preset.primary : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              gradient: preset.gradient,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: preset.primary.withValues(alpha: 0.4),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              preset.name,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                color: isSelected
                                    ? preset.primary
                                    : theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check_circle_rounded,
                              color: preset.primary,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: currentPreset.gradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.badge_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Profile Card Showcase',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  'Theme: ${currentPreset.name}',
                  style: TextStyle(
                    fontSize: 12,
                    color: currentPreset.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Theme preset chooser button
          IconButton(
            tooltip: 'Customize Theme Colors',
            onPressed: () => _showColorPickerModal(context),
            icon: Icon(
              Icons.palette_rounded,
              color: currentPreset.primary,
            ),
          ),
          // Dark/Light Mode Toggle Switch
          IconButton(
            tooltip: isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode',
            onPressed: () => onThemeModeChanged(!isDarkMode),
            icon: Icon(
              isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          // Background ambient gradient orb decoration
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    currentPreset.primary.withValues(alpha: 0.18),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -80,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    currentPreset.secondary.withValues(alpha: 0.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Scrollable Profile Card View
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: ProfileCard(
                  currentPreset: currentPreset,
                  onSelectTheme: () => _showColorPickerModal(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
