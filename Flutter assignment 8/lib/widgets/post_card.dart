import 'package:flutter/material.dart';
import '../models/post.dart';
import '../screens/post_detail_sheet.dart';

/// Reusable card component displaying a single post preview.
class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Pick a subtle gradient color based on user ID for visual interest
    final List<Color> userColors = [
      Colors.blue,
      Colors.indigo,
      Colors.deepPurple,
      Colors.teal,
      Colors.cyan,
      Colors.amber.shade800,
      Colors.pink,
      Colors.deepOrange,
      Colors.blueGrey,
      Colors.green,
    ];
    final Color accentColor = userColors[(post.userId - 1) % userColors.length];

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(
          color: theme.dividerColor.withValues(alpha: isDark ? 0.2 : 0.6),
        ),
      ),
      color: isDark
          ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3)
          : theme.colorScheme.surface,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => PostDetailSheet.show(context, post),
        borderRadius: BorderRadius.circular(16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: Avatar ID and User Badge
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: accentColor.withValues(alpha: 0.4),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '#${post.id}',
                      style: TextStyle(
                        color: accentColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'User ${post.userId}',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.textTheme.bodySmall?.color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 20,
                    color: theme.disabledColor,
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Title
              Text(
                post.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 6),

              // Body preview
              Text(
                post.body,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.75),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
