import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_assignment_7/main.dart';
import 'package:flutter_assignment_7/models/user_model.dart';
import 'package:flutter_assignment_7/screens/detail_screen.dart';

void main() {
  group('3-Screen Navigation & Validation Widget Tests', () {
    testWidgets('Home Screen displays hero banner and navigates to Form screen', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Verify Home Screen elements
      expect(find.text('App Portal'), findsOneWidget);
      expect(find.text('Welcome to\nRegistration Portal'), findsOneWidget);
      expect(find.text('Start Registration'), findsOneWidget);
      expect(find.text('Proceed to Registration Form'), findsOneWidget);

      // Tap on Start Registration button to navigate to FormScreen via named route
      await tester.tap(find.text('Start Registration'));
      await tester.pumpAndSettle();

      // Verify we are on the Form Screen
      expect(find.text('Registration Form'), findsOneWidget);
      expect(find.text('Create Your Profile'), findsOneWidget);
    });

    testWidgets('Form Screen triggers validation errors when fields are empty', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Navigate to form
      await tester.tap(find.text('Start Registration'));
      await tester.pumpAndSettle();

      // Tap submit button without filling fields
      final submitButton = find.byKey(const Key('submitButton'));
      await tester.ensureVisible(submitButton);
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      // Verify validation error messages
      expect(find.text('Full Name is required'), findsOneWidget);
      expect(find.text('Email address is required'), findsOneWidget);
      expect(find.text('Phone number is required'), findsOneWidget);
      expect(find.text('Please select an account type'), findsOneWidget);
      expect(find.text('Password is required'), findsOneWidget);
      expect(find.text('Please confirm your password'), findsOneWidget);
    });

    testWidgets('Form Screen validates email format and password strength', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Navigate to form
      await tester.tap(find.text('Start Registration'));
      await tester.pumpAndSettle();

      // Enter invalid email
      await tester.enterText(
        find.byKey(const Key('emailField')),
        'invalid-email-format',
      );

      // Enter weak password
      await tester.enterText(
        find.byKey(const Key('passwordField')),
        '12345',
      );

      // Enter non-matching confirm password
      await tester.enterText(
        find.byKey(const Key('confirmPasswordField')),
        'different',
      );

      // Tap submit
      final submitButton = find.byKey(const Key('submitButton'));
      await tester.ensureVisible(submitButton);
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      // Verify specific validation error messages
      expect(
        find.text('Please enter a valid email address (e.g. user@domain.com)'),
        findsOneWidget,
      );
      expect(
        find.text('Password must be at least 8 characters long'),
        findsOneWidget,
      );
      expect(
        find.text('Passwords do not match'),
        findsOneWidget,
      );
    });

    testWidgets('Valid form submission navigates to Detail Screen with arguments', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Navigate to form
      await tester.tap(find.text('Start Registration'));
      await tester.pumpAndSettle();

      // Fill in valid details
      await tester.enterText(
        find.byKey(const Key('fullNameField')),
        'Jane Doe',
      );
      await tester.enterText(
        find.byKey(const Key('emailField')),
        'jane.doe@example.com',
      );
      await tester.enterText(
        find.byKey(const Key('phoneField')),
        '9876543210',
      );

      // Select Account Type
      final dropdown = find.byKey(const Key('accountTypeField'));
      await tester.ensureVisible(dropdown);
      await tester.tap(dropdown);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Software Developer').last);
      await tester.pumpAndSettle();

      // Enter strong matching password
      await tester.enterText(
        find.byKey(const Key('passwordField')),
        'Secur3#Pass!',
      );
      await tester.enterText(
        find.byKey(const Key('confirmPasswordField')),
        'Secur3#Pass!',
      );

      // Check Terms and Conditions
      final termsCheckbox = find.byKey(const Key('termsCheckbox'));
      await tester.ensureVisible(termsCheckbox);
      await tester.tap(termsCheckbox);
      await tester.pumpAndSettle();

      // Submit Form
      final submitButton = find.byKey(const Key('submitButton'));
      await tester.ensureVisible(submitButton);
      await tester.tap(submitButton);
      await tester.pump(const Duration(milliseconds: 700));
      await tester.pumpAndSettle();

      // Verify Detail Screen is presented with passed arguments
      expect(find.text('User Profile Details'), findsOneWidget);
      expect(find.text('Jane Doe'), findsWidgets);
      expect(find.text('jane.doe@example.com'), findsWidgets);
      expect(find.text('9876543210'), findsOneWidget);
      expect(find.text('Software Developer'), findsWidgets);
      expect(find.text('Registration Complete'), findsOneWidget);

      // Test "Back to Home" action
      final backToHomeBtn = find.text('Back to Home');
      await tester.ensureVisible(backToHomeBtn);
      await tester.tap(backToHomeBtn);
      await tester.pumpAndSettle();

      // Verify we are back on the Home Screen
      expect(find.text('Welcome to\nRegistration Portal'), findsOneWidget);
    });

    testWidgets('Detail Screen displays fallback state when arguments are absent', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: DetailScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('No User Data Provided'), findsOneWidget);
      expect(find.text('Go to Registration Form'), findsOneWidget);
    });

    testWidgets('UserModel computes initials and formatted date correctly', (
      WidgetTester tester,
    ) async {
      final user = UserModel(
        fullName: 'Alex Johnson',
        email: 'alex@test.com',
        phoneNumber: '1234567890',
        accountType: 'Student',
        subscribedToNewsletter: true,
        registeredAt: DateTime(2026, 9, 23, 10, 30),
      );

      expect(user.initials, 'AJ');
      expect(user.formattedRegistrationDate, '2026-09-23 10:30');
    });
  });
}
