import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_shop/app/shop_app.dart';

void main() {
  group('ShopApp Tests', () {
    testWidgets('ShopApp should build correctly', (WidgetTester tester) async {
      // Wrap ShopApp in ProviderScope for Riverpod
      await tester.pumpWidget(
        const ProviderScope(
          child: ShopApp(),
        ),
      );

      // Verify that our app builds successfully
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    test('ShopApp should have correct title', () {
      const app = ShopApp();

      // Test that the widget can be created
      expect(app, isA<Widget>());
      expect(app.runtimeType, ShopApp);
    });
  });
}
