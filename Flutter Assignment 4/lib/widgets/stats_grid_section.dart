import 'package:flutter/material.dart';
import '../models/dashboard_models.dart';
import '../utils/responsive_helper.dart';
import 'stat_card.dart';

class StatsGridSection extends StatelessWidget {
  final List<StatMetric> metrics;

  const StatsGridSection({
    super.key,
    required this.metrics,
  });

  @override
  Widget build(BuildContext context) {
    // Determine crossAxisCount and childAspectRatio using MediaQuery calculations
    final columns = ResponsiveHelper.getStatGridColumns(context);
    final aspectRatio = ResponsiveHelper.getStatGridAspectRatio(context);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: metrics.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: aspectRatio,
      ),
      itemBuilder: (context, index) {
        return StatCard(metric: metrics[index]);
      },
    );
  }
}
