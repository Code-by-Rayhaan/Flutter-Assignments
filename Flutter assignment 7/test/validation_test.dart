import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_assignment_7/main.dart';

void main() {
  group('Comprehensive Validation Unit & UI Tests', () {
    testWidgets('Validates Full Name character constraints and minimum length', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Start Registration'));
      await tester.pumpAndSettle();

      final nameField = find.byKey(const Key('fullNameField'));
      final submitButton = find.byKey(const Key('submitButton'));

      // Test short name (< 3 chars)
      await tester.enterText(nameField, 'Ab');
      await tester.ensureVisible(submitButton);
      await tester.tap(submitButton);
      await tester.pumpAndSettle();
      expect(
        find.text('Name must be at least 3 characters long'),
        findsOneWidget,
      );

      // Test name with invalid special characters/numbers
      await tester.enterText(nameField, 'John123!');
      await tester.pumpAndSettle();
      expect(find.text('Name contains invalid characters'), findsOneWidget);

      // Test valid name
      await tester.enterText(nameField, 'Rayhaan Siledar');
      await tester.pumpAndSettle();
      expect(
        find.text('Name must be at least 3 characters long'),
        findsNothing,
      );
      expect(find.text('Name contains invalid characters'), findsNothing);
    });

    testWidgets('Validates Email regex patterns strictly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Start Registration'));
      await tester.pumpAndSettle();

      final emailField = find.byKey(const Key('emailField'));
      final submitButton = find.byKey(const Key('submitButton'));

      // Trigger validation
      await tester.ensureVisible(submitButton);
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      // Test missing domain
      await tester.enterText(emailField, 'test@');
      await tester.pumpAndSettle();
      expect(
        find.text('Please enter a valid email address (e.g. user@domain.com)'),
        findsOneWidget,
      );

      // Test missing '@'
      await tester.enterText(emailField, 'testexample.com');
      await tester.pumpAndSettle();
      expect(
        find.text('Please enter a valid email address (e.g. user@domain.com)'),
        findsOneWidget,
      );

      // Test valid email
      await tester.enterText(emailField, 'user.name@domain.co.in');
      await tester.pumpAndSettle();
      expect(
        find.text('Please enter a valid email address (e.g. user@domain.com)'),
        findsNothing,
      );
    });

    testWidgets('Validates Phone Number length and digit format', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Start Registration'));
      await tester.pumpAndSettle();

      final phoneField = find.byKey(const Key('phoneField'));
      final submitButton = find.byKey(const Key('submitButton'));

      await tester.ensureVisible(submitButton);
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      // Less than 10 digits
      await tester.enterText(phoneField, '123456789');
      await tester.pumpAndSettle();
      expect(
        find.text('Please enter a valid 10-digit phone number'),
        findsOneWidget,
      );

      // Valid 10 digits
      await tester.enterText(phoneField, '9876543210');
      await tester.pumpAndSettle();
      expect(
        find.text('Please enter a valid 10-digit phone number'),
        findsNothing,
      );
    });

    testWidgets('Validates each password criteria individually', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Start Registration'));
      await tester.pumpAndSettle();

      final passwordField = find.byKey(const Key('passwordField'));
      final submitButton = find.byKey(const Key('submitButton'));

      await tester.ensureVisible(submitButton);
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      // Missing Uppercase
      await tester.enterText(passwordField, 'secret123!');
      await tester.pumpAndSettle();
      expect(
        find.text('Must contain at least 1 uppercase letter (A-Z)'),
        findsOneWidget,
      );

      // Missing Lowercase
      await tester.enterText(passwordField, 'SECRET123!');
      await tester.pumpAndSettle();
      expect(
        find.text('Must contain at least 1 lowercase letter (a-z)'),
        findsOneWidget,
      );

      // Missing Number
      await tester.enterText(passwordField, 'SecretPass!');
      await tester.pumpAndSettle();
      expect(find.text('Must contain at least 1 number (0-9)'), findsOneWidget);

      // Missing Special Character
      await tester.enterText(passwordField, 'SecretPass123');
      await tester.pumpAndSettle();
      expect(
        find.text('Must contain at least 1 special character (!@#\$%^&*...)'),
        findsOneWidget,
      );

      // Fully valid password
      await tester.enterText(passwordField, 'Valid@Password123');
      await tester.pumpAndSettle();
      expect(
        find.text('Must contain at least 1 uppercase letter (A-Z)'),
        findsNothing,
      );
      expect(find.text('Strength: Strong'), findsOneWidget);
    });

    testWidgets('Reset form resets fields to clean initial state', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Start Registration'));
      await tester.pumpAndSettle();

      final nameField = find.byKey(const Key('fullNameField'));
      await tester.enterText(nameField, 'Test User');
      await tester.pumpAndSettle();

      // Tap Reset action in AppBar
      await tester.tap(find.byTooltip('Reset Form'));
      await tester.pumpAndSettle();

      // Verify field is cleared
      expect(find.text('Test User'), findsNothing);
    });
  });
}
