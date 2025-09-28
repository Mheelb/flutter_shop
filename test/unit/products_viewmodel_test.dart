import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_shop/features/products/presentation/viewmodel/products_state.dart';
import 'package:flutter_shop/features/products/presentation/viewmodel/products_view_model.dart';
import 'package:flutter_shop/features/products/domain/models/product.dart';

// Mock Repository pour les tests
class MockProductsRepository {
  final bool shouldFail;
  final List<Product> mockProducts;

  MockProductsRepository(
      {this.shouldFail = false, this.mockProducts = const []});

  Future<List<Product>> fetchAllProducts() async {
    await Future.delayed(
        const Duration(milliseconds: 10)); // Simulate network delay
    if (shouldFail) {
      throw Exception('Network error');
    }
    return mockProducts;
  }

  Future<Product> fetchProduct(int id) async {
    if (shouldFail) {
      throw Exception('Product not found');
    }
    return mockProducts.firstWhere((p) => p.id == id);
  }
}

void main() {
  group('ProductsViewModel Tests', () {
    late ProductsViewModel viewModel;
    late MockProductsRepository mockRepository;

    const testProducts = [
      Product(
        id: 1,
        title: 'iPhone 15',
        price: 999.0,
        imageUrl: 'iphone.jpg',
        description: 'Latest iPhone',
        category: 'electronics',
        rating: 4.5,
        ratingCount: 100,
      ),
      Product(
        id: 2,
        title: 'Samsung Galaxy',
        price: 899.0,
        imageUrl: 'samsung.jpg',
        description: 'Android phone',
        category: 'electronics',
        rating: 4.3,
        ratingCount: 80,
      ),
    ];

    setUp(() {
      mockRepository = MockProductsRepository(mockProducts: testProducts);
      viewModel = ProductsViewModel(mockRepository as dynamic);
    });

    test('should have correct initial state', () {
      expect(viewModel.state.products, isEmpty);
      expect(viewModel.state.isLoading, false);
      expect(viewModel.state.errorMessage, isNull);
      expect(viewModel.state.query, isEmpty);
    });

    test('should set loading state when load is called', () async {
      // Act
      final loadFuture = viewModel.load();

      // Assert - should be loading initially
      expect(viewModel.state.isLoading, true);
      expect(viewModel.state.errorMessage, isNull);

      // Wait for completion
      await loadFuture;
    });

    test('should load products successfully', () async {
      // Act
      await viewModel.load();

      // Assert
      expect(viewModel.state.isLoading, false);
      expect(viewModel.state.products.length, 2);
      expect(viewModel.state.products[0].title, 'iPhone 15');
      expect(viewModel.state.products[1].title, 'Samsung Galaxy');
      expect(viewModel.state.errorMessage, isNull);
    });

    test('should handle loading error', () async {
      // Arrange
      mockRepository = MockProductsRepository(shouldFail: true);
      viewModel = ProductsViewModel(mockRepository as dynamic);

      // Act
      await viewModel.load();

      // Assert
      expect(viewModel.state.isLoading, false);
      expect(viewModel.state.products, isEmpty);
      expect(viewModel.state.errorMessage, contains('Network error'));
    });

    test('should update query correctly', () {
      // Act
      viewModel.setQuery('iPhone');

      // Assert
      expect(viewModel.state.query, 'iPhone');
    });

    test('should filter products by query', () {
      // Arrange - Set products first
      viewModel = ProductsViewModel(mockRepository as dynamic);
      // Manually set products for testing filtering
      const state = ProductsState(products: testProducts, query: 'iPhone');

      // Act
      final filtered = state.filteredProducts;

      // Assert
      expect(filtered.length, 1);
      expect(filtered[0].title, 'iPhone 15');
    });

    test('should return all products when query is empty', () {
      // Arrange
      const state = ProductsState(products: testProducts, query: '');

      // Act
      final filtered = state.filteredProducts;

      // Assert
      expect(filtered.length, 2);
    });

    test('copyWith should work with all parameters', () {
      // Arrange
      const originalState = ProductsState();

      // Act
      final newState = originalState.copyWith(
        isLoading: true,
        errorMessage: 'Test error',
        products: testProducts,
        query: 'test query',
      );

      // Assert
      expect(newState.isLoading, true);
      expect(newState.errorMessage, 'Test error');
      expect(newState.products, testProducts);
      expect(newState.query, 'test query');
    });

    test('copyWith should preserve existing values when null', () {
      // Arrange
      const originalState = ProductsState(
        isLoading: true,
        errorMessage: 'Original error',
        products: testProducts,
        query: 'original query',
      );

      // Act
      final newState = originalState.copyWith(
        isLoading: false,
        // errorMessage not provided - should be preserved
        // products not provided - should be preserved
        // query not provided - should be preserved
      );

      // Assert
      expect(newState.isLoading, false);
      expect(newState.errorMessage, 'Original error'); // Preserved
      expect(newState.products, testProducts); // Preserved
      expect(newState.query, 'original query'); // Preserved
    });
  });
}
