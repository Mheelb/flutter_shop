import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Widget Tests', () {
    testWidgets('Should create a basic button widget',
        (WidgetTester tester) async {
      bool wasPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ElevatedButton(
              onPressed: () {
                wasPressed = true;
              },
              child: const Text('Test Button'),
            ),
          ),
        ),
      );

      // Verify button exists
      expect(find.text('Test Button'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);

      // Tap button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Verify button was pressed
      expect(wasPressed, true);
    });

    testWidgets('Should display text input field', (WidgetTester tester) async {
      final textController = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextField(
              controller: textController,
              decoration: const InputDecoration(
                hintText: 'Enter text here',
              ),
            ),
          ),
        ),
      );

      // Verify text field exists
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Enter text here'), findsOneWidget);

      // Enter text
      await tester.enterText(find.byType(TextField), 'Hello World');
      expect(textController.text, 'Hello World');
    });

    testWidgets('Should create a shopping cart icon',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.shopping_cart), findsOneWidget);
      expect(find.byType(IconButton), findsOneWidget);
    });

    testWidgets('Should handle list view', (WidgetTester tester) async {
      final items = ['Item 1', 'Item 2', 'Item 3'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(items[index]),
                );
              },
            ),
          ),
        ),
      );

      // Verify list items
      for (final item in items) {
        expect(find.text(item), findsOneWidget);
      }
      expect(find.byType(ListTile), findsNWidgets(3));
    });

    testWidgets('Should handle navigation', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: const Text('Home')),
            body: ElevatedButton(
              onPressed: () {},
              child: const Text('Navigate'),
            ),
          ),
          routes: {
            '/second': (context) => Scaffold(
                  appBar: AppBar(title: const Text('Second Page')),
                ),
          },
        ),
      );

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Navigate'), findsOneWidget);
    });
  });
}
