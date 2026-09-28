import 'package:flutter/material.dart';
import '../models/todo_item.dart';
import '../widgets/add_edit_todo_sheet.dart';
import '../widgets/todo_item_tile.dart';
import '../widgets/todo_stats_card.dart';

enum FilterOption { all, pending, completed }

class TodoListScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool isDarkMode;

  const TodoListScreen({
    super.key,
    required this.onToggleTheme,
    required this.isDarkMode,
  });

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  // Main list of Todos stored in state
  final List<TodoItem> _todos = [];

  // Filter and Search states
  FilterOption _selectedFilter = FilterOption.all;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize with a few helpful starter tasks for instant interactive testing
    _loadSampleTasks();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadSampleTasks() {
    final now = DateTime.now();
    _todos.addAll([
      TodoItem(
        id: '1',
        title: 'Review Flutter StatefulWidget concepts',
        description: 'Understand setState lifecycle and state management patterns.',
        isCompleted: true,
        createdAt: now.subtract(const Duration(hours: 3)),
        priority: TodoPriority.high,
        category: TodoCategory.study,
      ),
      TodoItem(
        id: '2',
        title: 'Complete Assignment 5 requirements',
        description: 'Build add, delete, and mark-complete operations with rich UI.',
        isCompleted: false,
        createdAt: now.subtract(const Duration(hours: 1)),
        priority: TodoPriority.high,
        category: TodoCategory.work,
      ),
      TodoItem(
        id: '3',
        title: 'Buy fresh groceries and fruits',
        description: 'Apples, almond milk, whole grain bread, and avocados.',
        isCompleted: false,
        createdAt: now.subtract(const Duration(minutes: 30)),
        priority: TodoPriority.medium,
        category: TodoCategory.shopping,
      ),
      TodoItem(
        id: '4',
        title: 'Go for a 30-minute evening run',
        description: 'Hit the park trail and track running metrics.',
        isCompleted: false,
        createdAt: now.subtract(const Duration(minutes: 10)),
        priority: TodoPriority.low,
        category: TodoCategory.health,
      ),
    ]);
  }

  // --- Core State Mutation Operations using setState() ---

  /// 1. Add new Todo item
  void _addTodo({
    required String title,
    required String description,
    required TodoPriority priority,
    required TodoCategory category,
  }) {
    final newTodo = TodoItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      isCompleted: false,
      createdAt: DateTime.now(),
      priority: priority,
      category: category,
    );

    setState(() {
      _todos.insert(0, newTodo);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Added "$title"',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// 2. Mark complete / toggle completion
  void _toggleTodoStatus(String id) {
    setState(() {
      final index = _todos.indexWhere((t) => t.id == id);
      if (index != -1) {
        final current = _todos[index];
        _todos[index] = current.copyWith(isCompleted: !current.isCompleted);
      }
    });
  }

  /// 3. Delete Todo item with Undo support
  void _deleteTodo(String id) {
    final index = _todos.indexWhere((t) => t.id == id);
    if (index == -1) return;

    final removedItem = _todos[index];

    setState(() {
      _todos.removeAt(index);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Deleted "${removedItem.title}"'),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: Colors.amberAccent,
          onPressed: () {
            setState(() {
              _todos.insert(index, removedItem);
            });
          },
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  /// 4. Edit existing Todo item
  void _editTodo({
    required String id,
    required String title,
    required String description,
    required TodoPriority priority,
    required TodoCategory category,
  }) {
    setState(() {
      final index = _todos.indexWhere((t) => t.id == id);
      if (index != -1) {
        _todos[index] = _todos[index].copyWith(
          title: title,
          description: description,
          priority: priority,
          category: category,
        );
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Updated "$title"'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// 5. Clear all completed tasks
  void _clearCompletedTodos() {
    final completedCount = _todos.where((t) => t.isCompleted).length;
    if (completedCount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No completed tasks to clear.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear Completed Tasks?'),
        content: Text(
          'This will remove all $completedCount completed tasks from your list.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              Navigator.of(ctx).pop();
              final backupList = List<TodoItem>.from(_todos);
              setState(() {
                _todos.removeWhere((t) => t.isCompleted);
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Cleared $completedCount completed tasks'),
                  action: SnackBarAction(
                    label: 'UNDO',
                    textColor: Colors.amberAccent,
                    onPressed: () {
                      setState(() {
                        _todos.clear();
                        _todos.addAll(backupList);
                      });
                    },
                  ),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  /// Opens the Add / Edit Modal Sheet
  void _showAddEditSheet({TodoItem? existingTodo}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => AddEditTodoSheet(
        initialTodo: existingTodo,
        onSave: ({
          required String title,
          required String description,
          required TodoPriority priority,
          required TodoCategory category,
        }) {
          if (existingTodo != null) {
            _editTodo(
              id: existingTodo.id,
              title: title,
              description: description,
              priority: priority,
              category: category,
            );
          } else {
            _addTodo(
              title: title,
              description: description,
              priority: priority,
              category: category,
            );
          }
        },
      ),
    );
  }

  // Filtered todos calculation
  List<TodoItem> get _filteredTodos {
    return _todos.where((todo) {
      // Filter by status
      final matchesFilter = switch (_selectedFilter) {
        FilterOption.all => true,
        FilterOption.pending => !todo.isCompleted,
        FilterOption.completed => todo.isCompleted,
      };

      // Filter by search query
      final matchesSearch = _searchQuery.isEmpty ||
          todo.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          todo.description.toLowerCase().contains(_searchQuery.toLowerCase());

      return matchesFilter && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalCount = _todos.length;
    final completedCount = _todos.where((t) => t.isCompleted).length;
    final pendingCount = totalCount - completedCount;
    final displayedTodos = _filteredTodos;

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.check_circle_outline, size: 28),
            SizedBox(width: 10),
            Text(
              'Task Flow',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            tooltip: 'Toggle Theme',
            onPressed: widget.onToggleTheme,
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'clear_completed') {
                _clearCompletedTodos();
              } else if (value == 'reset_samples') {
                setState(() {
                  _todos.clear();
                  _loadSampleTasks();
                });
              } else if (value == 'clear_all') {
                setState(() {
                  _todos.clear();
                });
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'clear_completed',
                child: Row(
                  children: [
                    Icon(Icons.cleaning_services, size: 20),
                    SizedBox(width: 8),
                    Text('Clear Completed'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'reset_samples',
                child: Row(
                  children: [
                    Icon(Icons.refresh, size: 20),
                    SizedBox(width: 8),
                    Text('Reset Sample Tasks'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'clear_all',
                child: Row(
                  children: [
                    Icon(Icons.delete_forever, size: 20, color: Colors.redAccent),
                    SizedBox(width: 8),
                    Text('Clear All Tasks', style: TextStyle(color: Colors.redAccent)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. Progress Stats Summary Banner
          TodoStatsCard(
            totalCount: totalCount,
            completedCount: completedCount,
          ),

          // 2. Search Box
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search tasks...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
            ),
          ),

          // 3. Filter Segment Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              children: [
                _buildFilterChip(FilterOption.all, 'All ($totalCount)'),
                const SizedBox(width: 8),
                _buildFilterChip(FilterOption.pending, 'Pending ($pendingCount)'),
                const SizedBox(width: 8),
                _buildFilterChip(FilterOption.completed, 'Done ($completedCount)'),
              ],
            ),
          ),

          const SizedBox(height: 4),

          // 4. Todo List or Empty State View
          Expanded(
            child: displayedTodos.isEmpty
                ? _buildEmptyState(theme)
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80, top: 4),
                    itemCount: displayedTodos.length,
                    itemBuilder: (context, index) {
                      final todo = displayedTodos[index];
                      return TodoItemTile(
                        key: ValueKey(todo.id),
                        todo: todo,
                        onToggle: (_) => _toggleTodoStatus(todo.id),
                        onDelete: () => _deleteTodo(todo.id),
                        onEdit: () => _showAddEditSheet(existingTodo: todo),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEditSheet(),
        icon: const Icon(Icons.add),
        label: const Text(
          'Add Task',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildFilterChip(FilterOption filter, String label) {
    final isSelected = _selectedFilter == filter;
    final theme = Theme.of(context);

    return Expanded(
      child: FilterChip(
        selected: isSelected,
        label: Center(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSurface,
              fontSize: 12.5,
            ),
          ),
        ),
        selectedColor: theme.colorScheme.primary,
        backgroundColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        showCheckmark: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        onSelected: (selected) {
          if (selected) {
            setState(() {
              _selectedFilter = filter;
            });
          }
        },
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    final bool hasSearchOrFilter = _searchQuery.isNotEmpty || _selectedFilter != FilterOption.all;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                hasSearchOrFilter ? Icons.search_off : Icons.task_alt,
                size: 64,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              hasSearchOrFilter
                  ? 'No matching tasks found'
                  : 'All caught up!',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              hasSearchOrFilter
                  ? 'Try adjusting your search query or filter chips.'
                  : 'You have completed all your tasks or haven\'t added any yet.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            if (!hasSearchOrFilter)
              FilledButton.tonalIcon(
                onPressed: () => _showAddEditSheet(),
                icon: const Icon(Icons.add),
                label: const Text('Add a task'),
              )
            else
              TextButton.icon(
                onPressed: () {
                  _searchController.clear();
                  setState(() {
                    _searchQuery = '';
                    _selectedFilter = FilterOption.all;
                  });
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Reset filters'),
              ),
          ],
        ),
      ),
    );
  }
}
