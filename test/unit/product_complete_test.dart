import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_shop/features/products/domain/models/product.dart';

void main() {
  group('Product Model Tests', () {
    const testProduct = Product(
      id: 1,
      title: 'Test Product',
      description: 'A test product for unit testing',
      price: 29.99,
      category: 'Electronics',
      imageUrl: 'https://example.com/image.jpg',
      rating: 4.5,
      ratingCount: 120,
    );

    group('Product Creation', () {
      test('should create product with all fields', () {
        expect(testProduct.id, 1);
        expect(testProduct.title, 'Test Product');
        expect(testProduct.description, 'A test product for unit testing');
        expect(testProduct.price, 29.99);
        expect(testProduct.category, 'Electronics');
        expect(testProduct.imageUrl, 'https://example.com/image.jpg');
        expect(testProduct.rating, 4.5);
        expect(testProduct.ratingCount, 120);
      });

      test('should create products with different values', () {
        const products = [
          Product(
            id: 100,
            title: 'Expensive Item',
            description: 'Very expensive luxury item',
            price: 999999.99,
            category: 'Luxury',
            imageUrl: 'https://example.com/luxury.jpg',
            rating: 5.0,
            ratingCount: 1,
          ),
          Product(
            id: 0,
            title: 'Free Item',
            description: 'Completely free item',
            price: 0.0,
            category: 'Free',
            imageUrl: 'https://example.com/free.jpg',
            rating: 0.0,
            ratingCount: 0,
          ),
        ];

        for (final product in products) {
          expect(product.id, isA<int>());
          expect(product.title, isA<String>());
          expect(product.description, isA<String>());
          expect(product.price, isA<double>());
          expect(product.category, isA<String>());
          expect(product.imageUrl, isA<String>());
          expect(product.rating, isA<double>());
          expect(product.ratingCount, isA<int>());
        }
      });
    });

    group('JSON Serialization', () {
      test('fromJson should create Product from JSON', () {
        final json = {
          'id': 1,
          'title': 'Test Product',
          'description': 'A test product for unit testing',
          'price': 29.99,
          'category': 'Electronics',
          'image': 'https://example.com/image.jpg',
          'rating': {
            'rate': 4.5,
            'count': 120,
          },
        };

        final product = Product.fromJson(json);

        expect(product.id, 1);
        expect(product.title, 'Test Product');
        expect(product.description, 'A test product for unit testing');
        expect(product.price, 29.99);
        expect(product.category, 'Electronics');
        expect(product.imageUrl, 'https://example.com/image.jpg');
        expect(product.rating, 4.5);
        expect(product.ratingCount, 120);
      });

      test('fromJson should handle missing rating', () {
        final json = {
          'id': 2,
          'title': 'No Rating Product',
          'description': 'Product without rating',
          'price': 15.50,
          'category': 'Books',
          'image': 'https://example.com/norating.jpg',
        };

        final product = Product.fromJson(json);

        expect(product.id, 2);
        expect(product.title, 'No Rating Product');
        expect(product.rating, 0.0);
        expect(product.ratingCount, 0);
      });

      test('fromJson should handle null rating', () {
        final json = {
          'id': 3,
          'title': 'Null Rating Product',
          'description': 'Product with null rating',
          'price': 12.99,
          'category': 'Toys',
          'image': 'https://example.com/toys.jpg',
          'rating': null,
        };

        final product = Product.fromJson(json);

        expect(product.id, 3);
        expect(product.rating, 0.0);
        expect(product.ratingCount, 0);
      });

      test('toJson should convert Product to JSON', () {
        final json = testProduct.toJson();

        expect(json['id'], 1);
        expect(json['title'], 'Test Product');
        expect(json['description'], 'A test product for unit testing');
        expect(json['price'], 29.99);
        expect(json['category'], 'Electronics');
        expect(json['image'], 'https://example.com/image.jpg');
        expect(json['rating']['rate'], 4.5);
        expect(json['rating']['count'], 120);
      });

      test('should handle round trip serialization', () {
        final json = testProduct.toJson();
        final recreatedProduct = Product.fromJson(json);

        expect(recreatedProduct.id, testProduct.id);
        expect(recreatedProduct.title, testProduct.title);
        expect(recreatedProduct.description, testProduct.description);
        expect(recreatedProduct.price, testProduct.price);
        expect(recreatedProduct.category, testProduct.category);
        expect(recreatedProduct.imageUrl, testProduct.imageUrl);
        expect(recreatedProduct.rating, testProduct.rating);
        expect(recreatedProduct.ratingCount, testProduct.ratingCount);
      });

      test('should handle multiple round trips', () {
        var product = testProduct;

        for (int i = 0; i < 10; i++) {
          final json = product.toJson();
          product = Product.fromJson(json);
        }

        expect(product.id, testProduct.id);
        expect(product.title, testProduct.title);
        expect(product.price, testProduct.price);
      });
    });

    group('Equality and Hash Code', () {
      test('should be equal when all properties are same', () {
        const product1 = Product(
          id: 1,
          title: 'Same Product',
          description: 'Same description',
          price: 19.99,
          category: 'Same Category',
          imageUrl: 'https://example.com/same.jpg',
          rating: 4.0,
          ratingCount: 50,
        );

        const product2 = Product(
          id: 1,
          title: 'Same Product',
          description: 'Same description',
          price: 19.99,
          category: 'Same Category',
          imageUrl: 'https://example.com/same.jpg',
          rating: 4.0,
          ratingCount: 50,
        );

        expect(product1, equals(product2));
        expect(product1.hashCode, equals(product2.hashCode));
      });

      test('should not be equal when id differs', () {
        const product1 = Product(
          id: 1,
          title: 'Product',
          description: 'Description',
          price: 19.99,
          category: 'Category',
          imageUrl: 'https://example.com/image.jpg',
          rating: 4.0,
          ratingCount: 50,
        );

        const product2 = Product(
          id: 2,
          title: 'Product',
          description: 'Description',
          price: 19.99,
          category: 'Category',
          imageUrl: 'https://example.com/image.jpg',
          rating: 4.0,
          ratingCount: 50,
        );

        expect(product1, isNot(equals(product2)));
      });

      test('should not be equal when price differs', () {
        const product1 = Product(
          id: 1,
          title: 'Product',
          description: 'Description',
          price: 19.99,
          category: 'Category',
          imageUrl: 'https://example.com/image.jpg',
          rating: 4.0,
          ratingCount: 50,
        );

        const product2 = Product(
          id: 1,
          title: 'Product',
          description: 'Description',
          price: 29.99,
          category: 'Category',
          imageUrl: 'https://example.com/image.jpg',
          rating: 4.0,
          ratingCount: 50,
        );

        expect(product1, isNot(equals(product2)));
      });

      test('should not be equal when rating differs', () {
        const product1 = Product(
          id: 1,
          title: 'Product',
          description: 'Description',
          price: 19.99,
          category: 'Category',
          imageUrl: 'https://example.com/image.jpg',
          rating: 4.0,
          ratingCount: 50,
        );

        const product2 = Product(
          id: 1,
          title: 'Product',
          description: 'Description',
          price: 19.99,
          category: 'Category',
          imageUrl: 'https://example.com/image.jpg',
          rating: 3.0,
          ratingCount: 50,
        );

        expect(product1, isNot(equals(product2)));
      });
    });

    group('CopyWith Method', () {
      test('copyWith should create new instance with updated fields', () {
        final updatedProduct = testProduct.copyWith(
          title: 'Updated Title',
          price: 39.99,
        );

        expect(updatedProduct.id, testProduct.id);
        expect(updatedProduct.title, 'Updated Title');
        expect(updatedProduct.description, testProduct.description);
        expect(updatedProduct.price, 39.99);
        expect(updatedProduct.category, testProduct.category);
        expect(updatedProduct.imageUrl, testProduct.imageUrl);
        expect(updatedProduct.rating, testProduct.rating);
      });

      test('copyWith should handle updating rating', () {
        final updatedProduct = testProduct.copyWith(
          rating: 5.0,
          ratingCount: 200,
        );

        expect(updatedProduct.rating, 5.0);
        expect(updatedProduct.ratingCount, 200);
        expect(updatedProduct.id, testProduct.id);
        expect(updatedProduct.title, testProduct.title);
      });

      test('copyWith without parameters should create identical copy', () {
        final copiedProduct = testProduct.copyWith();

        expect(copiedProduct, equals(testProduct));
        expect(copiedProduct.hashCode, equals(testProduct.hashCode));
      });
    });

    group('Edge Cases', () {
      test('should handle empty strings', () {
        const productWithEmptyStrings = Product(
          id: 999,
          title: '',
          description: '',
          price: 0.0,
          category: '',
          imageUrl: '',
          rating: 0.0,
          ratingCount: 0,
        );

        expect(productWithEmptyStrings.title, '');
        expect(productWithEmptyStrings.description, '');
        expect(productWithEmptyStrings.category, '');
        expect(productWithEmptyStrings.imageUrl, '');
      });

      test('should handle special characters', () {
        const productWithSpecialChars = Product(
          id: 888,
          title: 'Product with émojis 🎉 and special chars äöü',
          description:
              'Description with "quotes" and \'apostrophes\' & symbols',
          price: 99.99,
          category: 'Special/Category-Name_123',
          imageUrl:
              'https://example.com/spëcial-imagé.jpg?param=value&other=123',
          rating: 4.8,
          ratingCount: 42,
        );

        expect(productWithSpecialChars.title, contains('🎉'));
        expect(productWithSpecialChars.description, contains('"quotes"'));
        expect(productWithSpecialChars.category, 'Special/Category-Name_123');
        expect(productWithSpecialChars.imageUrl, contains('spëcial'));
      });

      test('should handle extreme price values', () {
        const extremeProducts = [
          Product(
            id: 1,
            title: 'Free Item',
            description: 'Completely free',
            price: 0.0,
            category: 'Free',
            imageUrl: 'https://example.com/free.jpg',
            rating: 0.0,
            ratingCount: 0,
          ),
          Product(
            id: 2,
            title: 'Very Expensive',
            description: 'Extremely expensive item',
            price: 999999999.99,
            category: 'Luxury',
            imageUrl: 'https://example.com/expensive.jpg',
            rating: 5.0,
            ratingCount: 1,
          ),
          Product(
            id: 3,
            title: 'Penny Item',
            description: 'Very cheap item',
            price: 0.01,
            category: 'Cheap',
            imageUrl: 'https://example.com/penny.jpg',
            rating: 2.5,
            ratingCount: 100,
          ),
        ];

        for (final product in extremeProducts) {
          expect(product.price, isA<double>());
          expect(product.price, greaterThanOrEqualTo(0.0));
        }
      });
    });

    group('Stress Testing', () {
      test('should handle many serialization operations', () {
        for (int i = 0; i < 500; i++) {
          final product = Product(
            id: i,
            title: 'Product $i',
            description: 'Description for product number $i',
            price: (i * 1.99) + 0.99,
            category: 'Category ${i % 10}',
            imageUrl: 'https://example.com/product$i.jpg',
            rating: (i % 5) + 1.0,
            ratingCount: i * 2,
          );

          final json = product.toJson();
          final recreated = Product.fromJson(json);

          expect(recreated.id, product.id);
          expect(recreated.title, product.title);
          expect(recreated.price, product.price);
          expect(recreated.rating, product.rating);
          expect(recreated.ratingCount, product.ratingCount);
        }
      });

      test('should handle batch operations', () {
        final products = <Product>[];

        // Create 100 products
        for (int i = 0; i < 100; i++) {
          products.add(Product(
            id: i,
            title: 'Batch Product $i',
            description: 'Batch description $i',
            price: i * 5.99,
            category: 'Batch Category ${i % 5}',
            imageUrl: 'https://example.com/batch$i.jpg',
            rating: (i % 5) + 1.0,
            ratingCount: i,
          ));
        }

        // Convert all to JSON
        final jsonList = products.map((p) => p.toJson()).toList();

        // Convert back to products
        final recreatedProducts =
            jsonList.map((json) => Product.fromJson(json)).toList();

        expect(recreatedProducts.length, products.length);

        for (int i = 0; i < products.length; i++) {
          expect(recreatedProducts[i].id, products[i].id);
          expect(recreatedProducts[i].title, products[i].title);
          expect(recreatedProducts[i].price, products[i].price);
        }
      });

      test('should handle edge rating values consistently', () {
        final ratingValues = [0.0, 0.5, 1.0, 2.5, 3.7, 4.2, 4.9, 5.0];
        final countValues = [0, 1, 10, 50, 100, 500, 1000, 9999];

        for (final rating in ratingValues) {
          for (final count in countValues) {
            final product = Product(
              id: 1,
              title: 'Test Product',
              description: 'Test',
              price: 10.0,
              category: 'Test',
              imageUrl: 'https://test.com/test.jpg',
              rating: rating,
              ratingCount: count,
            );

            final json = product.toJson();
            final recreated = Product.fromJson(json);

            expect(recreated.rating, rating);
            expect(recreated.ratingCount, count);
          }
        }
      });
    });
  });
}
