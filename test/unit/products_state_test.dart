import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_shop/features/products/presentation/viewmodel/products_state.dart';
import 'package:flutter_shop/features/products/domain/models/product.dart';

void main() {
  group('ProductsState', () {
    test('should have correct initial values', () {
      const state = ProductsState();

      expect(state.isLoading, false);
      expect(state.errorMessage, null);
      expect(state.products, isEmpty);
      expect(state.query, '');
    });

    test('should create new state with copyWith', () {
      const initialState = ProductsState();
      final newState = initialState.copyWith(
        isLoading: true,
        errorMessage: 'Test error',
      );

      expect(newState.isLoading, true);
      expect(newState.errorMessage, 'Test error');
      expect(newState.products, isEmpty);
    });

    test('should filter products by title', () {
      const products = [
        Product(
          id: 1,
          title: 'iPhone 15',
          price: 999.0,
          imageUrl: 'test.jpg',
          description: 'Test phone',
          category: 'electronics',
          rating: 4.5,
          ratingCount: 100,
        ),
        Product(
          id: 2,
          title: 'Samsung Galaxy',
          price: 899.0,
          imageUrl: 'test2.jpg',
          description: 'Test phone',
          category: 'electronics',
          rating: 4.3,
          ratingCount: 50,
        ),
      ];

      final state = ProductsState(products: products, query: 'iPhone');
      final filtered = state.filteredProducts;

      expect(filtered.length, 1);
      expect(filtered.first.title, 'iPhone 15');
    });

    test('should filter products by category', () {
      const products = [
        Product(
          id: 1,
          title: 'iPhone 15',
          price: 999.0,
          imageUrl: 'test.jpg',
          description: 'Test phone',
          category: 'electronics',
          rating: 4.5,
          ratingCount: 100,
        ),
        Product(
          id: 2,
          title: 'T-Shirt',
          price: 29.99,
          imageUrl: 'shirt.jpg',
          description: 'Cotton t-shirt',
          category: 'clothing',
          rating: 4.0,
          ratingCount: 25,
        ),
      ];

      final state = ProductsState(products: products, query: 'clothing');
      final filtered = state.filteredProducts;

      expect(filtered.length, 1);
      expect(filtered.first.category, 'clothing');
    });

    test('should return all products when query is empty', () {
      const products = [
        Product(
          id: 1,
          title: 'iPhone 15',
          price: 999.0,
          imageUrl: 'test.jpg',
          description: 'Test phone',
          category: 'electronics',
          rating: 4.5,
          ratingCount: 100,
        ),
        Product(
          id: 2,
          title: 'Samsung Galaxy',
          price: 899.0,
          imageUrl: 'test2.jpg',
          description: 'Test phone',
          category: 'electronics',
          rating: 4.3,
          ratingCount: 50,
        ),
      ];

      final state = ProductsState(products: products, query: '');
      final filtered = state.filteredProducts;

      expect(filtered.length, 2);
    });
  });

  group('Product', () {
    test('should create Product from JSON', () {
      final json = {
        'id': 1,
        'title': 'Test Product',
        'price': 29.99,
        'image': 'test.jpg',
        'description': 'A test product',
        'category': 'test',
        'rating': {'rate': 4.5, 'count': 100}
      };

      final product = Product.fromJson(json);

      expect(product.id, 1);
      expect(product.title, 'Test Product');
      expect(product.price, 29.99);
      expect(product.imageUrl, 'test.jpg');
      expect(product.description, 'A test product');
      expect(product.category, 'test');
      expect(product.rating, 4.5);
      expect(product.ratingCount, 100);
    });

    test('should handle missing rating in JSON', () {
      final json = {
        'id': 1,
        'title': 'Test Product',
        'price': 29.99,
        'image': 'test.jpg',
        'description': 'A test product',
        'category': 'test',
      };

      final product = Product.fromJson(json);

      expect(product.rating, 0.0);
      expect(product.ratingCount, 0);
    });
  });
}
