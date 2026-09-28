import 'package:flutter/material.dart';

/// Defines the custom color palettes and theme configurations for the Profile Card App.
class AppTheme {
  // Custom Color Palettes
  static const Color primaryViolet = Color(0xFF6366F1); // Indigo / Violet
  static const Color secondaryCyan = Color(0xFF06B6D4); // Cyan Accent
  static const Color accentAmber = Color(0xFFF59E0B); // Amber / Gold
  static const Color successGreen = Color(0xFF10B981); // Emerald Green
  
  // Dark Theme Palette
  static const Color darkBg = Color(0xFF0F172A); // Slate 900
  static const Color darkCardBg = Color(0xFF1E293B); // Slate 800
  static const Color darkCardBorder = Color(0xFF334155); // Slate 700
  static const Color darkTextPrimary = Color(0xFFF8FAFC); // Slate 50
  static const Color darkTextSecondary = Color(0xFF94A3B8); // Slate 400
  
  // Light Theme Palette
  static const Color lightBg = Color(0xFFF8FAFC);
  static const Color lightCardBg = Color(0xFFFFFFFF);
  static const Color lightCardBorder = Color(0xFFE2E8F0);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);

  /// Palette Preset Options for live switching
  static final List<CustomColorPreset> colorPresets = [
    CustomColorPreset(
      name: 'Electric Indigo',
      primary: const Color(0xFF6366F1),
      secondary: const Color(0xFF8B5CF6),
      accent: const Color(0xFF06B6D4),
      gradient: const LinearGradient(
        colors: [Color(0xFF6366F1), Color(0xFF8B5CF6), Color(0xFFEC4899)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    CustomColorPreset(
      name: 'Emerald Aurora',
      primary: const Color(0xFF059669),
      secondary: const Color(0xFF10B981),
      accent: const Color(0xFF34D399),
      gradient: const LinearGradient(
        colors: [Color(0xFF047857), Color(0xFF10B981), Color(0xFF06B6D4)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    CustomColorPreset(
      name: 'Sunset Coral',
      primary: const Color(0xFFE11D48),
      secondary: const Color(0xFFF43F5E),
      accent: const Color(0xFFFB923C),
      gradient: const LinearGradient(
        colors: [Color(0xFFE11D48), Color(0xFFF97316), Color(0xFFFBBF24)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    CustomColorPreset(
      name: 'Midnight Cyber',
      primary: const Color(0xFF0284C7),
      secondary: const Color(0xFF38BDF8),
      accent: const Color(0xFFA855F7),
      gradient: const LinearGradient(
        colors: [Color(0xFF0369A1), Color(0xFF0284C7), Color(0xFF7C3AED)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
  ];

  /// Generate light theme
  static ThemeData getLightTheme(CustomColorPreset preset) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightBg,
      colorScheme: ColorScheme.light(
        primary: preset.primary,
        secondary: preset.secondary,
        tertiary: preset.accent,
        surface: lightCardBg,
        onPrimary: Colors.white,
        onSurface: lightTextPrimary,
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: lightTextPrimary,
          letterSpacing: -0.5,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: lightTextSecondary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: lightTextSecondary,
          height: 1.5,
        ),
      ),
    );
  }

  /// Generate dark theme
  static ThemeData getDarkTheme(CustomColorPreset preset) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBg,
      colorScheme: ColorScheme.dark(
        primary: preset.primary,
        secondary: preset.secondary,
        tertiary: preset.accent,
        surface: darkCardBg,
        onPrimary: Colors.white,
        onSurface: darkTextPrimary,
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: darkTextPrimary,
          letterSpacing: -0.5,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: darkTextSecondary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: darkTextSecondary,
          height: 1.5,
        ),
      ),
    );
  }
}

class CustomColorPreset {
  final String name;
  final Color primary;
  final Color secondary;
  final Color accent;
  final LinearGradient gradient;

  CustomColorPreset({
    required this.name,
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.gradient,
  });
}
