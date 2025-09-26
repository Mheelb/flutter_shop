import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_shop/features/products/data/repositories/products_repository_impl.dart';
import 'package:flutter_shop/features/products/domain/models/product.dart';
import 'package:flutter_shop/features/products/data/datasources/products_remote_datasource.dart';

// Mock DataSource pour les tests
class MockProductsRemoteDataSource extends ProductsRemoteDataSource {
  final List<Product> mockProducts;

  MockProductsRemoteDataSource(this.mockProducts);

  @override
  Future<List<Product>> fetchAllProducts() async {
    return mockProducts;
  }

  @override
  Future<Product> fetchProduct(int id) async {
    final product = mockProducts.firstWhere(
      (p) => p.id == id,
      orElse: () => throw Exception('Product not found'),
    );
    return product;
  }
}

void main() {
  group('ProductsRepositoryImpl', () {
    late ProductsRepositoryImpl repository;
    late List<Product> mockProducts;

    setUp(() {
      mockProducts = [
        const Product(
          id: 1,
          title: 'Test Product 1',
          price: 29.99,
          imageUrl: 'test1.jpg',
          description: 'First test product',
          category: 'electronics',
          rating: 4.5,
          ratingCount: 100,
        ),
        const Product(
          id: 2,
          title: 'Test Product 2',
          price: 49.99,
          imageUrl: 'test2.jpg',
          description: 'Second test product',
          category: 'clothing',
          rating: 4.0,
          ratingCount: 50,
        ),
      ];

      repository = ProductsRepositoryImpl(
        remoteDataSource: MockProductsRemoteDataSource(mockProducts),
      );
    });

    test('should fetch all products from remote data source', () async {
      final products = await repository.fetchAllProducts();

      expect(products.length, 2);
      expect(products[0].title, 'Test Product 1');
      expect(products[1].title, 'Test Product 2');
    });

    test('should fetch specific product by id', () async {
      final product = await repository.fetchProduct(1);

      expect(product.id, 1);
      expect(product.title, 'Test Product 1');
      expect(product.price, 29.99);
    });

    test('should throw exception when product not found', () async {
      expect(
        () => repository.fetchProduct(999),
        throwsException,
      );
    });
  });
}
