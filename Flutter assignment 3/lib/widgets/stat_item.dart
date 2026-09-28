import 'package:flutter/material.dart';

/// A reusable statistic column item utilizing [Column] and [Text] widgets with custom styling.
class StatItem extends StatelessWidget {
  final String count;
  final String label;
  final Color? countColor;
  final Color? labelColor;

  const StatItem({
    super.key,
    required this.count,
    required this.label,
    this.countColor,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          count,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: countColor ?? theme.colorScheme.onSurface,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: labelColor ?? theme.colorScheme.onSurface.withValues(alpha: 0.6),
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }
}
