import 'package:flutter/material.dart';
import '../models/todo_item.dart';

class AddEditTodoSheet extends StatefulWidget {
  final TodoItem? initialTodo;
  final Function({
    required String title,
    required String description,
    required TodoPriority priority,
    required TodoCategory category,
  }) onSave;

  const AddEditTodoSheet({
    super.key,
    this.initialTodo,
    required this.onSave,
  });

  @override
  State<AddEditTodoSheet> createState() => _AddEditTodoSheetState();
}

class _AddEditTodoSheetState extends State<AddEditTodoSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descController;
  late TodoPriority _selectedPriority;
  late TodoCategory _selectedCategory;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTodo?.title ?? '');
    _descController = TextEditingController(text: widget.initialTodo?.description ?? '');
    _selectedPriority = widget.initialTodo?.priority ?? TodoPriority.medium;
    _selectedCategory = widget.initialTodo?.category ?? TodoCategory.personal;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSave(
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        priority: _selectedPriority,
        category: _selectedCategory,
      );
      Navigator.of(context).pop();
    }
  }

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditing = widget.initialTodo != null;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag Handle & Title
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isEditing ? 'Edit Task' : 'Add New Task',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Title input
              TextFormField(
                controller: _titleController,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: 'Task Title *',
                  hintText: 'e.g. Buy groceries, Prepare slides...',
                  prefixIcon: const Icon(Icons.check_circle_outline),
                  filled: true,
                  fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a task title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),

              // Description input
              TextFormField(
                controller: _descController,
                maxLines: 2,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: 'Description (optional)',
                  hintText: 'Add additional details or notes...',
                  prefixIcon: const Icon(Icons.notes_outlined),
                  filled: true,
                  fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Priority Selector
              Text(
                'Priority',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: TodoPriority.values.map((priority) {
                  final isSelected = _selectedPriority == priority;
                  final pColor = _getPriorityColor(priority);
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ChoiceChip(
                        label: Center(
                          child: Text(
                            priority.name[0].toUpperCase() + priority.name.substring(1),
                            style: TextStyle(
                              color: isSelected ? Colors.white : pColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: pColor,
                        backgroundColor: pColor.withValues(alpha: 0.1),
                        side: BorderSide(
                          color: isSelected ? pColor : pColor.withValues(alpha: 0.3),
                        ),
                        showCheckmark: false,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedPriority = priority;
                            });
                          }
                        },
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Category Selector
              Text(
                'Category',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: TodoCategory.values.map((category) {
                  final isSelected = _selectedCategory == category;
                  return ChoiceChip(
                    label: Text(
                      category.name[0].toUpperCase() + category.name.substring(1),
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedCategory = category;
                        });
                      }
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Action Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton.icon(
                  onPressed: _submitForm,
                  icon: Icon(isEditing ? Icons.save : Icons.add_task),
                  label: Text(
                    isEditing ? 'Save Changes' : 'Create Task',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
