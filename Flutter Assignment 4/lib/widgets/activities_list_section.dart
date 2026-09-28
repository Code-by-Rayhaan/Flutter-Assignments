import 'package:flutter/material.dart';
import '../models/dashboard_models.dart';
import '../theme/app_theme.dart';

class ActivitiesListSection extends StatefulWidget {
  final List<ActivityItem> activities;

  const ActivitiesListSection({
    super.key,
    required this.activities,
  });

  @override
  State<ActivitiesListSection> createState() => _ActivitiesListSectionState();
}

class _ActivitiesListSectionState extends State<ActivitiesListSection> {
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Finance',
    'DevOps',
    'Design',
    'Security',
    'Infrastructure',
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filteredActivities = _selectedCategory == 'All'
        ? widget.activities
        : widget.activities
            .where((a) => a.category == _selectedCategory)
            .toList();

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkCard : AppTheme.lightCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.history_rounded,
                      size: 20,
                      color: AppTheme.secondary,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Recent Activity Stream',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${filteredActivities.length} Events',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryLight,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Horizontal Categories Filter using ListView
          SizedBox(
            height: 32,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = cat == _selectedCategory;
                return ChoiceChip(
                  label: Text(
                    cat,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : (isDark
                              ? AppTheme.darkTextSecondary
                              : AppTheme.lightTextSecondary),
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: AppTheme.primary,
                  backgroundColor: isDark
                      ? AppTheme.darkCardElevated
                      : AppTheme.lightCardElevated,
                  side: BorderSide(
                    color: isSelected
                        ? AppTheme.primary
                        : (isDark ? AppTheme.darkBorder : AppTheme.lightBorder),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  visualDensity: VisualDensity.compact,
                  showCheckmark: false,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _selectedCategory = cat);
                    }
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 14),

          // Vertical ListView for Activities
          if (filteredActivities.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              alignment: Alignment.center,
              child: Text(
                'No activity found for $_selectedCategory',
                style: TextStyle(
                  color: isDark
                      ? AppTheme.darkTextSecondary
                      : AppTheme.lightTextSecondary,
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredActivities.length,
              separatorBuilder: (context, index) => Divider(
                height: 16,
                color: isDark
                    ? AppTheme.darkBorder.withValues(alpha: 0.5)
                    : AppTheme.lightBorder.withValues(alpha: 0.7),
              ),
              itemBuilder: (context, index) {
                final activity = filteredActivities[index];
                return _buildActivityTile(context, activity, isDark);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildActivityTile(
      BuildContext context, ActivityItem activity, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Category Icon Container
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: activity.iconColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            activity.icon,
            color: activity.iconColor,
            size: 20,
          ),
        ),

        const SizedBox(width: 12),

        // Title and Subtitle in Expanded
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      activity.title,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppTheme.darkTextPrimary
                            : AppTheme.lightTextPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppTheme.darkCardElevated
                          : AppTheme.lightCardElevated,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      activity.category,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppTheme.darkTextSecondary
                            : AppTheme.lightTextSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              Text(
                activity.subtitle,
                style: TextStyle(
                  fontSize: 11,
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

        const SizedBox(width: 8),

        // Amount & Timestamp in Flexible
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (activity.amount != null)
              Text(
                activity.amount!,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: activity.isIncome == true
                      ? AppTheme.accentEmerald
                      : AppTheme.accentRose,
                ),
              ),
            Text(
              activity.timestamp,
              style: TextStyle(
                fontSize: 10,
                color: isDark
                    ? AppTheme.darkTextSecondary.withValues(alpha: 0.8)
                    : AppTheme.lightTextSecondary.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
