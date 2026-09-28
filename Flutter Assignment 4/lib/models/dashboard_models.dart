import 'package:flutter/material.dart';

class StatMetric {
  final String title;
  final String value;
  final double changePercentage;
  final bool isPositive;
  final IconData icon;
  final LinearGradient gradient;
  final String subtitle;
  final double progress; // 0.0 to 1.0

  const StatMetric({
    required this.title,
    required this.value,
    required this.changePercentage,
    required this.isPositive,
    required this.icon,
    required this.gradient,
    required this.subtitle,
    required this.progress,
  });
}

enum ActivityStatus { completed, inProgress, pending, alert }

class ActivityItem {
  final String id;
  final String title;
  final String subtitle;
  final String timestamp;
  final String category;
  final String? amount;
  final bool? isIncome;
  final IconData icon;
  final Color iconColor;
  final ActivityStatus status;

  const ActivityItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.timestamp,
    required this.category,
    this.amount,
    this.isIncome,
    required this.icon,
    required this.iconColor,
    required this.status,
  });
}

enum TaskPriority { high, medium, low }

class TaskItem {
  final String id;
  final String title;
  final String project;
  final String deadline;
  final TaskPriority priority;
  final double progress;
  final String assignee;
  final int completedSubtasks;
  final int totalSubtasks;

  const TaskItem({
    required this.id,
    required this.title,
    required this.project,
    required this.deadline,
    required this.priority,
    required this.progress,
    required this.assignee,
    required this.completedSubtasks,
    required this.totalSubtasks,
  });
}

class TeamMember {
  final String id;
  final String name;
  final String role;
  final String initials;
  final Color avatarColor;
  final bool isOnline;
  final String activeTask;

  const TeamMember({
    required this.id,
    required this.name,
    required this.role,
    required this.initials,
    required this.avatarColor,
    required this.isOnline,
    required this.activeTask,
  });
}

class QuickActionItem {
  final String id;
  final String label;
  final IconData icon;
  final Color color;
  final int? badgeCount;

  const QuickActionItem({
    required this.id,
    required this.label,
    required this.icon,
    required this.color,
    this.badgeCount,
  });
}

class StorageCategory {
  final String label;
  final double percentage; // e.g. 0.40 for 40%
  final String sizeString;
  final Color color;
  final IconData icon;

  const StorageCategory({
    required this.label,
    required this.percentage,
    required this.sizeString,
    required this.color,
    required this.icon,
  });
}

class PerformanceDataPoint {
  final String label;
  final double value; // 0.0 to 1.0 (or absolute height)
  final String formattedValue;

  const PerformanceDataPoint({
    required this.label,
    required this.value,
    required this.formattedValue,
  });
}
