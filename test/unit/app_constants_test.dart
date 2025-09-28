import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_shop/core/constants/app_constants.dart';

void main() {
  group('AppConstants', () {
    test('should have correct app information', () {
      expect(AppConstants.appName, 'Flutter Shop');
      expect(AppConstants.appVersion, '1.0.0');
    });

    test('should have correct API configuration', () {
      expect(AppConstants.baseUrl, 'https://fakestoreapi.com');
      expect(AppConstants.productsEndpoint, '/products');
      expect(AppConstants.maxProductsPerPage, 20);
    });

    test('should have correct timeout durations', () {
      expect(AppConstants.networkTimeout, const Duration(seconds: 30));
      expect(AppConstants.cacheTimeout, const Duration(minutes: 5));
      expect(AppConstants.imageCacheTimeout, const Duration(hours: 24));
    });

    test('should have correct password validation constants', () {
      expect(AppConstants.minPasswordLength, 6);
      expect(AppConstants.maxPasswordLength, 128);
    });

    group('isValidPassword', () {
      test('should return true for valid passwords', () {
        expect(AppConstants.isValidPassword('123456'), true);
        expect(AppConstants.isValidPassword('password123'), true);
        expect(AppConstants.isValidPassword('a' * 50), true);
      });

      test('should return false for invalid passwords', () {
        expect(AppConstants.isValidPassword('12345'), false); // trop court
        expect(AppConstants.isValidPassword('a' * 130), false); // trop long
        expect(AppConstants.isValidPassword(''), false); // vide
      });
    });

    test('getProductUrl should generate correct URLs', () {
      expect(
          AppConstants.getProductUrl(1), 'https://fakestoreapi.com/products/1');
      expect(AppConstants.getProductUrl(42),
          'https://fakestoreapi.com/products/42');
    });
  });
}
