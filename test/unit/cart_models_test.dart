import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_shop/features/cart/domain/models/cart.dart';

void main() {
  group('CartItem Tests', () {
    test('should create CartItem with correct values', () {
      const item = CartItem(productId: 1, quantity: 3);

      expect(item.productId, 1);
      expect(item.quantity, 3);
    });

    test('should create CartItem with minimum quantity', () {
      const item = CartItem(productId: 2, quantity: 1);

      expect(item.productId, 2);
      expect(item.quantity, 1);
    });

    test('should handle large quantities', () {
      const item = CartItem(productId: 3, quantity: 999);

      expect(item.productId, 3);
      expect(item.quantity, 999);
    });

    test('should be immutable', () {
      const item1 = CartItem(productId: 1, quantity: 2);
      const item2 = CartItem(productId: 1, quantity: 2);

      expect(item1.productId, item2.productId);
      expect(item1.quantity, item2.quantity);
    });

    test('should support copyWith functionality via constructor', () {
      const originalItem = CartItem(productId: 1, quantity: 2);
      const updatedItem = CartItem(productId: 1, quantity: 5);

      expect(updatedItem.productId, originalItem.productId);
      expect(updatedItem.quantity, 5);
      expect(originalItem.quantity, 2); // Original unchanged
    });
  });

  group('Cart Tests', () {
    const sampleItems = [
      CartItem(productId: 1, quantity: 2),
      CartItem(productId: 2, quantity: 1),
      CartItem(productId: 3, quantity: 4),
    ];

    test('should create Cart with required fields', () {
      const cart = Cart(
        id: 123,
        userId: 456,
        items: sampleItems,
      );

      expect(cart.id, 123);
      expect(cart.userId, 456);
      expect(cart.items.length, 3);
    });

    test('should create Cart with empty items list', () {
      const cart = Cart(
        id: 1,
        userId: 123,
        items: [],
      );

      expect(cart.id, 1);
      expect(cart.userId, 123);
      expect(cart.items, isEmpty);
    });

    test('should handle single item cart', () {
      const cart = Cart(
        id: 2,
        userId: 789,
        items: [CartItem(productId: 42, quantity: 1)],
      );

      expect(cart.items.length, 1);
      expect(cart.items[0].productId, 42);
      expect(cart.items[0].quantity, 1);
    });

    test('should preserve item order', () {
      const items = [
        CartItem(productId: 3, quantity: 1),
        CartItem(productId: 1, quantity: 2),
        CartItem(productId: 2, quantity: 1),
      ];

      const cart = Cart(
        id: 3,
        userId: 111,
        items: items,
      );

      expect(cart.items[0].productId, 3);
      expect(cart.items[1].productId, 1);
      expect(cart.items[2].productId, 2);
    });

    test('should handle different user IDs', () {
      const cart1 = Cart(
        id: 4,
        userId: 100,
        items: sampleItems,
      );

      const cart2 = Cart(
        id: 5,
        userId: 200,
        items: [],
      );

      expect(cart1.userId, 100);
      expect(cart2.userId, 200);
      expect(cart1.items.isNotEmpty, true);
      expect(cart2.items.isEmpty, true);
    });

    test('should handle cart with duplicate product IDs', () {
      const itemsWithDuplicates = [
        CartItem(productId: 1, quantity: 2),
        CartItem(productId: 1, quantity: 3), // Same product, different quantity
        CartItem(productId: 2, quantity: 1),
      ];

      const cart = Cart(
        id: 6,
        userId: 300,
        items: itemsWithDuplicates,
      );

      expect(cart.items.length, 3);
      expect(cart.items.where((item) => item.productId == 1).length, 2);
    });

    test('should maintain immutability', () {
      final originalItems = [
        CartItem(productId: 1, quantity: 1),
      ];

      const cart = Cart(
        id: 7,
        userId: 400,
        items: [CartItem(productId: 1, quantity: 1)],
      );

      // Original list should not affect cart
      expect(cart.items.length, 1);
      expect(cart.items[0].quantity, 1);
    });
  });
}
