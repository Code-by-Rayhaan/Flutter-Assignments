import 'package:flutter/material.dart';

/// Screen Size Breakpoints
class ResponsiveHelper {
  static const double mobileMaxWidth = 650;
  static const double tabletMaxWidth = 1100;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileMaxWidth;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= mobileMaxWidth &&
      MediaQuery.of(context).size.width < tabletMaxWidth;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= tabletMaxWidth;

  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static Orientation orientation(BuildContext context) =>
      MediaQuery.of(context).orientation;

  static bool isLandscape(BuildContext context) =>
      orientation(context) == Orientation.landscape;

  /// Returns responsive crossAxisCount for Metric KPI Grid
  static int getStatGridColumns(BuildContext context) {
    final width = screenWidth(context);
    if (width >= 1250) return 4;
    if (width >= 850) return 3;
    if (width >= 450) return 2;
    return 2;
  }

  /// Returns dynamic childAspectRatio for Stat Cards
  static double getStatGridAspectRatio(BuildContext context) {
    final width = screenWidth(context);
    if (width >= 1400) return 1.25;
    if (width >= 1200) return 1.15;
    if (width >= 900) return 1.25;
    if (width >= 650) return 1.2;
    if (width >= 480) return 1.15;
    return 1.05; // phone screens
  }

  /// Returns responsive crossAxisCount for Quick Actions Grid
  static int getQuickActionsColumns(BuildContext context) {
    final width = screenWidth(context);
    if (width >= 1400) return 6;
    if (width >= 1100) return 3;
    if (width >= 750) return 3;
    if (width >= 400) return 3;
    return 2;
  }

  /// Adaptive page horizontal padding based on screen size
  static EdgeInsets getResponsivePadding(BuildContext context) {
    final width = screenWidth(context);
    if (width >= 1200) {
      return const EdgeInsets.symmetric(horizontal: 24, vertical: 20);
    } else if (width >= 700) {
      return const EdgeInsets.symmetric(horizontal: 18, vertical: 16);
    } else {
      return const EdgeInsets.symmetric(horizontal: 14, vertical: 12);
    }
  }

  /// Device Category string representation
  static String getDeviceCategory(BuildContext context) {
    if (isDesktop(context)) return 'Desktop / Ultra-Wide';
    if (isTablet(context)) return 'Tablet / Medium';
    return 'Mobile / Compact';
  }
}
