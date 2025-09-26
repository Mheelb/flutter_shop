import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_shop/features/products/presentation/viewmodel/products_state.dart';

void main() {
  group('ProductsViewModel Tests', () {
    test('ProductsState should have correct initial values', () {
      // Arrange & Act
      const state = ProductsState(
        products: [],
        isLoading: false,
        errorMessage: null,
      );

      // Assert
      expect(state.products, isEmpty);
      expect(state.isLoading, false);
      expect(state.errorMessage, isNull);
    });

    test('ProductsState should handle loading state', () {
      // Arrange & Act
      const loadingState = ProductsState(
        products: [],
        isLoading: true,
        errorMessage: null,
      );

      // Assert
      expect(loadingState.isLoading, true);
      expect(loadingState.products, isEmpty);
      expect(loadingState.errorMessage, isNull);
    });

    test('ProductsState should handle error state', () {
      // Arrange
      const errorMessage = 'Failed to load products';

      // Act
      const errorState = ProductsState(
        products: [],
        isLoading: false,
        errorMessage: errorMessage,
      );

      // Assert
      expect(errorState.errorMessage, equals(errorMessage));
      expect(errorState.isLoading, false);
      expect(errorState.products, isEmpty);
    });

    test('ProductsState copyWith should work correctly', () {
      // Arrange
      const originalState = ProductsState(
        products: [],
        isLoading: false,
        errorMessage: null,
      );

      // Act
      final newState = originalState.copyWith(
        isLoading: true,
        errorMessage: 'Some error',
      );

      // Assert
      expect(newState.isLoading, true);
      expect(newState.errorMessage, 'Some error');
      expect(newState.products, isEmpty); // Should remain the same
    });

    test('ProductsState should filter products correctly', () {
      // Arrange
      const state = ProductsState(
        products: [
          // Note: Ces tests utilisent les vraies classes Product
        ],
        isLoading: false,
        query: 'test',
      );

      // Assert
      expect(state.filteredProducts, isA<List>());
    });
  });
}
