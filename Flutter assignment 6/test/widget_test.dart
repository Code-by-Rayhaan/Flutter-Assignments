import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_product_catalog/main.dart';
import 'package:flutter_product_catalog/models/product.dart';
import 'package:flutter_product_catalog/widgets/product_card.dart';

void main() {
  group('Product Model Tests', () {
    test('Product model instantiation and helper getters', () {
      const product = Product(
        id: 'test-1',
        name: 'Test Device',
        category: 'Electronics',
        price: 99.99,
        rating: 4.5,
        reviewCount: 120,
        description: 'Test description',
        imageUrl: 'https://example.com/image.png',
        brand: 'TestBrand',
      );

      expect(product.id, 'test-1');
      expect(product.formattedPrice, '₹100');
      expect(product.formattedRating, '4.5');
      expect(product.isFavorite, false);
      expect(product.inStock, true);
    });

    test('Product copyWith works accurately', () {
      const product = Product(
        id: 'test-1',
        name: 'Original Name',
        category: 'Audio',
        price: 150.00,
        rating: 4.0,
        reviewCount: 10,
        description: 'Desc',
        imageUrl: 'https://example.com/img.png',
        brand: 'Brand',
      );

      final updated = product.copyWith(
        name: 'Updated Name',
        isFavorite: true,
        inStock: false,
      );

      expect(updated.id, 'test-1');
      expect(updated.name, 'Updated Name');
      expect(updated.isFavorite, true);
      expect(updated.inStock, false);
      expect(updated.category, 'Audio');
    });
  });

  group('Product Catalog Widget Tests', () {
    testWidgets('Renders app title, search bar, category chips, and ListView', (tester) async {
      await tester.pumpWidget(const FlutterProductCatalogApp());
      await tester.pumpAndSettle();

      // Verify title & app bar
      expect(find.text('Discover Products'), findsOneWidget);

      // Verify SearchBar presence
      expect(find.byType(SearchBar), findsOneWidget);

      // Verify Category Chips
      expect(find.widgetWithText(FilterChip, 'All'), findsOneWidget);
      expect(find.widgetWithText(FilterChip, 'Electronics'), findsOneWidget);
      expect(find.widgetWithText(FilterChip, 'Audio'), findsOneWidget);

      // Verify ListView builder renders product cards
      expect(find.byType(ProductCard), findsWidgets);
    });

    testWidgets('Search query filters product list using setState', (tester) async {
      await tester.pumpWidget(const FlutterProductCatalogApp());
      await tester.pumpAndSettle();

      // Enter search query for "Sony"
      await tester.enterText(find.byType(SearchBar), 'Sony');
      await tester.pumpAndSettle();

      // Verify Sony product is found
      expect(find.textContaining('Sony WH-1000XM5'), findsOneWidget);
      // Apple MacBook should not be in the filtered list
      expect(find.textContaining('Apple MacBook Air'), findsNothing);

      // Clear search
      final clearButton = find.byIcon(Icons.clear_rounded);
      expect(clearButton, findsOneWidget);
      await tester.tap(clearButton);
      await tester.pumpAndSettle();

      // Now Apple MacBook should be visible again
      expect(find.textContaining('Apple MacBook Air'), findsOneWidget);
    });

    testWidgets('Category selection filters product list using setState', (tester) async {
      await tester.pumpWidget(const FlutterProductCatalogApp());
      await tester.pumpAndSettle();

      // Tap "Audio" category chip
      final audioChip = find.widgetWithText(FilterChip, 'Audio');
      expect(audioChip, findsOneWidget);
      await tester.tap(audioChip);
      await tester.pumpAndSettle();

      // Audio items should be displayed
      expect(find.textContaining('Sony WH-1000XM5'), findsOneWidget);
      // Non-audio items like Nike Pegasus should not be displayed
      expect(find.textContaining('Nike Air Zoom'), findsNothing);
    });

    testWidgets('Favorite toggle updates state via setState', (tester) async {
      await tester.pumpWidget(const FlutterProductCatalogApp());
      await tester.pumpAndSettle();

      // Initially 0 favorites badge
      final favoriteIconButton = find.byTooltip('Add to Favorites').first;
      await tester.tap(favoriteIconButton);
      await tester.pumpAndSettle();

      // The tooltip should change or favorite count badge should show
      expect(find.byTooltip('Remove from Favorites'), findsWidgets);
    });

    testWidgets('Shows empty state when no products match search query', (tester) async {
      await tester.pumpWidget(const FlutterProductCatalogApp());
      await tester.pumpAndSettle();

      // Search for something non-existent
      await tester.enterText(find.byType(SearchBar), 'NonExistentProductXYZ123');
      await tester.pumpAndSettle();

      expect(find.text('No products found'), findsOneWidget);
      expect(find.text('Reset All Filters'), findsOneWidget);

      // Tap Reset Filters
      await tester.tap(find.text('Reset All Filters'));
      await tester.pumpAndSettle();

      // Products should return
      expect(find.byType(ProductCard), findsWidgets);
    });
  });
}
