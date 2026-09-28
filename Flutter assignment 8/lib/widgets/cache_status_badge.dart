import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/fetch_result.dart';

/// A banner widget displaying the data source (Live API vs SharedPreferences)
/// and the last sync timestamp.
class CacheStatusBadge extends StatelessWidget {
  final FetchResult result;
  final int totalCount;
  final int displayedCount;
  final VoidCallback? onRefresh;

  const CacheStatusBadge({
    super.key,
    required this.result,
    required this.totalCount,
    required this.displayedCount,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLive = result.isLive;
    final formattedTime =
        DateFormat('MMM d, yyyy • hh:mm:ss a').format(result.timestamp.toLocal());

    final Color badgeColor =
        isLive ? const Color(0xFF00897B) : const Color(0xFFE65100);
    final Color bgColor = isLive
        ? (theme.brightness == Brightness.dark
            ? const Color(0xFF00332C)
            : const Color(0xFFE0F2F1))
        : (theme.brightness == Brightness.dark
            ? const Color(0xFF3E1F00)
            : const Color(0xFFFFF3E0));

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: badgeColor.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isLive ? Icons.cloud_done_rounded : Icons.storage_rounded,
                      size: 14,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isLive ? 'LIVE API' : 'SHARED_PREFS CACHE',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  displayedCount == totalCount
                      ? '$totalCount posts'
                      : '$displayedCount of $totalCount posts',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.access_time_rounded,
                size: 14,
                color: theme.textTheme.bodySmall?.color,
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  'Synced: $formattedTime',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          if (result.noticeMessage != null) ...[
            const SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 14,
                  color: badgeColor,
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    result.noticeMessage!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: badgeColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
