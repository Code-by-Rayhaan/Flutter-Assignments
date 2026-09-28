import 'package:flutter/material.dart';
import '../models/dashboard_models.dart';
import '../theme/app_theme.dart';

class TasksListSection extends StatelessWidget {
  final List<TaskItem> tasks;

  const TasksListSection({
    super.key,
    required this.tasks,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(
                      Icons.assignment_turned_in_rounded,
                      size: 20,
                      color: AppTheme.accentPurple,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Sprint Milestones',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? AppTheme.darkTextPrimary
                              : AppTheme.lightTextPrimary,
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
                  color: AppTheme.accentPurple.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${tasks.length} In Flight',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.accentPurple,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ListView.separated for task cards
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: tasks.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final task = tasks[index];
              return _buildTaskCard(context, task, isDark);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(BuildContext context, TaskItem task, bool isDark) {
    Color priorityColor;
    String priorityText;
    switch (task.priority) {
      case TaskPriority.high:
        priorityColor = AppTheme.accentRose;
        priorityText = 'HIGH';
        break;
      case TaskPriority.medium:
        priorityColor = AppTheme.accentAmber;
        priorityText = 'MED';
        break;
      case TaskPriority.low:
        priorityColor = AppTheme.accentEmerald;
        priorityText = 'LOW';
        break;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkCardElevated : AppTheme.lightCardElevated,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row with project tag and priority pill
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Project Pill
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    task.project,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryLight,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Priority Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: priorityColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: priorityColor.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  priorityText,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: priorityColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Title
          Text(
            task.title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppTheme.darkTextPrimary
                  : AppTheme.lightTextPrimary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 10),

          // Progress Bar with Subtask count using Row & Expanded
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: task.progress,
                    minHeight: 6,
                    backgroundColor: isDark
                        ? AppTheme.darkBorder
                        : AppTheme.lightBorder.withValues(alpha: 0.8),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      task.progress >= 0.8
                          ? AppTheme.accentEmerald
                          : AppTheme.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${(task.progress * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? AppTheme.darkTextPrimary
                      : AppTheme.lightTextPrimary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Bottom Details: Assignee & Deadline using Row & Flexible
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.person_outline_rounded,
                      size: 13,
                      color: isDark
                          ? AppTheme.darkTextSecondary
                          : AppTheme.lightTextSecondary,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        task.assignee,
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark
                              ? AppTheme.darkTextSecondary
                              : AppTheme.lightTextSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    size: 12,
                    color: isDark
                        ? AppTheme.darkTextSecondary
                        : AppTheme.lightTextSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    task.deadline,
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark
                          ? AppTheme.darkTextSecondary
                          : AppTheme.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
