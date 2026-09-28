import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile_card_app/main.dart';
import 'package:profile_card_app/widgets/profile_card.dart';

void main() {
  testWidgets('Profile card displays key elements and widgets', (WidgetTester tester) async {
    // Set viewport size large enough to view card comfortably
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    // Pump ProfileCardApp
    await tester.pumpWidget(const ProfileCardApp());
    await tester.pumpAndSettle();

    // Verify Profile Card renders
    expect(find.byType(ProfileCard), findsOneWidget);

    // Verify required widgets are present:
    // 1. CircleAvatar
    expect(find.byType(CircleAvatar), findsWidgets);

    // 2. Text widgets (Name, Title, Stats)
    expect(find.text('Rayhaan Siledar'), findsOneWidget);
    expect(find.text('Senior Flutter & Mobile Architect'), findsOneWidget);
    expect(find.text('PROJECTS'), findsOneWidget);
    expect(find.text('FOLLOWERS'), findsOneWidget);
    expect(find.text('RATING'), findsOneWidget);

    // 3. Icons (Verified, Email, Phone, etc.)
    expect(find.byIcon(Icons.verified_rounded), findsOneWidget);
    expect(find.byIcon(Icons.email_rounded), findsOneWidget);
    expect(find.byIcon(Icons.phone_android_rounded), findsOneWidget);

    // 4. Rows, Columns, and Containers
    expect(find.byType(Row), findsWidgets);
    expect(find.byType(Column), findsWidgets);
    expect(find.byType(Container), findsWidgets);

    // Scroll to and test follow interaction
    final followFinder = find.text('Follow');
    await tester.ensureVisible(followFinder);
    await tester.tap(followFinder);
    await tester.pumpAndSettle();
    expect(find.text('Following'), findsOneWidget);
  });
}
