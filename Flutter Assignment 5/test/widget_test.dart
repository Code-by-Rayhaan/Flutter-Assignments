import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/widgets/todo_item_tile.dart';

void main() {
  testWidgets('Todo list renders initial tasks and stats', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const TodoApp());
    await tester.pumpAndSettle();

    // Verify app title and stats
    expect(find.text('Task Flow'), findsOneWidget);
    expect(find.text('Progress Summary'), findsOneWidget);
    expect(find.byType(TodoItemTile), findsWidgets);
  });

  testWidgets('Add new task increases list count and updates state', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const TodoApp());
    await tester.pumpAndSettle();

    // Tap the Floating Action Button 'Add Task'
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // Enter task title
    final titleField = find.widgetWithText(TextFormField, 'Task Title *');
    expect(titleField, findsOneWidget);
    await tester.enterText(titleField, 'New Automated Test Task');

    // Tap 'Create Task' button
    await tester.tap(find.text('Create Task'));
    await tester.pumpAndSettle();

    // Verify task is added
    expect(find.text('New Automated Test Task'), findsOneWidget);
  });

  testWidgets('Mark-complete toggles task completion state', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const TodoApp());
    await tester.pumpAndSettle();

    // Find the first checkbox
    final checkboxFinder = find.byType(Checkbox).first;
    final initialCheckbox = tester.widget<Checkbox>(checkboxFinder);
    final initialValue = initialCheckbox.value;

    // Tap the checkbox to toggle state
    await tester.tap(checkboxFinder);
    await tester.pumpAndSettle();

    final updatedCheckbox = tester.widget<Checkbox>(checkboxFinder);
    expect(updatedCheckbox.value, !initialValue!);
  });

  testWidgets('Delete task removes item from list and supports UNDO', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const TodoApp());
    await tester.pumpAndSettle();

    const targetTitle = 'Review Flutter StatefulWidget concepts';
    expect(find.text(targetTitle), findsOneWidget);

    // Tap the delete button on the first tile
    final deleteButton = find.byIcon(Icons.delete_outline).first;
    await tester.tap(deleteButton);
    await tester.pumpAndSettle();

    // Verify item is removed and SnackBar UNDO is visible
    expect(find.text(targetTitle), findsNothing);
    expect(find.text('UNDO'), findsOneWidget);

    // Tap UNDO to verify restoration
    await tester.tap(find.text('UNDO'));
    await tester.pumpAndSettle();

    expect(find.text(targetTitle), findsOneWidget);
  });

  testWidgets('Filter chips filter tasks by active and completed state', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const TodoApp());
    await tester.pumpAndSettle();

    // Tap 'Done (1)' filter
    await tester.tap(find.widgetWithText(FilterChip, 'Done (1)'));
    await tester.pumpAndSettle();

    // Only completed task should show
    expect(find.text('Review Flutter StatefulWidget concepts'), findsOneWidget);
    expect(find.text('Complete Assignment 5 requirements'), findsNothing);

    // Tap 'Pending (3)' filter
    await tester.tap(find.widgetWithText(FilterChip, 'Pending (3)'));
    await tester.pumpAndSettle();

    expect(find.text('Review Flutter StatefulWidget concepts'), findsNothing);
    expect(find.text('Complete Assignment 5 requirements'), findsOneWidget);
  });
}
