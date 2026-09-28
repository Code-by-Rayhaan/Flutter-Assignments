import 'package:flutter/material.dart';
import '../models/todo_item.dart';

class TodoItemTile extends StatelessWidget {
  final TodoItem todo;
  final ValueChanged<bool?> onToggle;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const TodoItemTile({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
  });

  Color _getPriorityColor(TodoPriority priority) {
    switch (priority) {
      case TodoPriority.high:
        return Colors.redAccent;
      case TodoPriority.medium:
        return Colors.orangeAccent;
      case TodoPriority.low:
        return Colors.green;
    }
  }

  IconData _getCategoryIcon(TodoCategory category) {
    switch (category) {
      case TodoCategory.personal:
        return Icons.person_outline;
      case TodoCategory.work:
        return Icons.work_outline;
      case TodoCategory.study:
        return Icons.menu_book_outlined;
      case TodoCategory.shopping:
        return Icons.shopping_bag_outlined;
      case TodoCategory.health:
        return Icons.favorite_border;
      case TodoCategory.other:
        return Icons.bookmark_border;
    }
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inMinutes < 1) {
      return 'Just now';
    } else if (diff.inHours < 1) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inDays < 1 && now.day == dt.day) {
      return 'Today at ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } else if (diff.inDays == 1 || (now.day - dt.day == 1 && diff.inDays < 2)) {
      return 'Yesterday';
    } else {
      return '${dt.day}/${dt.month}/${dt.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final priorityColor = _getPriorityColor(todo.priority);

    return Dismissible(
      key: Key(todo.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.delete_sweep, color: Colors.white, size: 28),
            SizedBox(width: 8),
            Text(
              'Delete',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
      onDismissed: (_) => onDelete(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: todo.isCompleted
              ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5)
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: todo.isCompleted
                ? Colors.transparent
                : theme.colorScheme.outlineVariant.withValues(alpha: 0.6),
            width: 1,
          ),
          boxShadow: todo.isCompleted
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onEdit,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Custom checkbox button
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Transform.scale(
                      scale: 1.15,
                      child: Checkbox(
                        value: todo.isCompleted,
                        onChanged: onToggle,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        activeColor: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Title & Metadata
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          todo.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            decoration: todo.isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            color: todo.isCompleted
                                ? theme.colorScheme.onSurface.withValues(alpha: 0.45)
                                : theme.colorScheme.onSurface,
                          ),
                        ),
                        if (todo.description.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            todo.description,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: todo.isCompleted
                                  ? theme.colorScheme.onSurface.withValues(alpha: 0.35)
                                  : theme.colorScheme.onSurfaceVariant,
                              decoration: todo.isCompleted
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        const SizedBox(height: 8),
                        // Tags & Timestamp
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            // Category Tag
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    _getCategoryIcon(todo.category),
                                    size: 12,
                                    color: theme.colorScheme.primary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    todo.category.name[0].toUpperCase() +
                                        todo.category.name.substring(1),
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Priority Tag
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: priorityColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: priorityColor,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    todo.priority.name[0].toUpperCase() +
                                        todo.priority.name.substring(1),
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: priorityColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Created Date
                            Text(
                              _formatDate(todo.createdAt),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.outline,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Actions (Edit and Delete icons)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, size: 20),
                        color: theme.colorScheme.onSurfaceVariant,
                        tooltip: 'Edit Todo',
                        onPressed: onEdit,
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, size: 20),
                        color: Colors.redAccent.shade200,
                        tooltip: 'Delete Todo',
                        onPressed: onDelete,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
