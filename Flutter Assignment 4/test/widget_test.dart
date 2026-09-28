import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_dashboard/main.dart';

void main() {
  testWidgets('Dashboard renders on mobile screen size', (WidgetTester tester) async {
    // Set mobile viewport (390x844)
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const ResponsiveDashboardApp());
    await tester.pumpAndSettle();

    expect(find.text('Total Revenue'), findsOneWidget);
    expect(find.text('Quick Operations'), findsOneWidget);
    expect(find.text('Recent Activity Stream'), findsOneWidget);
    expect(find.byType(ListView), findsWidgets);
    expect(find.byType(GridView), findsWidgets);
  });

  testWidgets('Dashboard renders on desktop screen size with split columns', (WidgetTester tester) async {
    // Set wide desktop viewport (1440x900)
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const ResponsiveDashboardApp());
    await tester.pumpAndSettle();

    expect(find.text('Nexus Engine'), findsOneWidget);
    expect(find.text('Total Revenue'), findsOneWidget);
    expect(find.text('Infrastructure Allocation'), findsOneWidget);
    expect(find.text('Weekly Throughput'), findsOneWidget);
    expect(find.byType(ListView), findsWidgets);
    expect(find.byType(GridView), findsWidgets);
  });

  testWidgets('Dashboard renders on tablet screen size with rail navigation', (WidgetTester tester) async {
    // Set tablet viewport (800x1024)
    tester.view.physicalSize = const Size(800, 1024);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const ResponsiveDashboardApp());
    await tester.pumpAndSettle();

    expect(find.text('Total Revenue'), findsOneWidget);
    expect(find.text('Quick Operations'), findsOneWidget);
    expect(find.byType(ListView), findsWidgets);
    expect(find.byType(GridView), findsWidgets);
  });
}
