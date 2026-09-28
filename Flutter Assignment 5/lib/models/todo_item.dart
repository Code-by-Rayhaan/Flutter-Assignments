enum TodoPriority {
  low,
  medium,
  high,
}

enum TodoCategory {
  personal,
  work,
  study,
  shopping,
  health,
  other,
}

class TodoItem {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime createdAt;
  final TodoPriority priority;
  final TodoCategory category;

  const TodoItem({
    required this.id,
    required this.title,
    this.description = '',
    this.isCompleted = false,
    required this.createdAt,
    this.priority = TodoPriority.medium,
    this.category = TodoCategory.personal,
  });

  TodoItem copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? createdAt,
    TodoPriority? priority,
    TodoCategory? category,
  }) {
    return TodoItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      priority: priority ?? this.priority,
      category: category ?? this.category,
    );
  }
}
