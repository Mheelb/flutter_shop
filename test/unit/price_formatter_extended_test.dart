import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_shop/core/utils/price_formatter.dart';

void main() {
  group('PriceFormatter Additional Tests', () {
    // Tests plus exhaustifs pour améliorer la couverture

    test('formatPrice should handle zero price', () {
      expect(PriceFormatter.formatPrice(0.0), '0.00 €');
    });

    test('formatPrice should handle very small prices', () {
      expect(PriceFormatter.formatPrice(0.01), '0.01 €');
      expect(PriceFormatter.formatPrice(0.99), '0.99 €');
    });

    test('formatPrice should handle large prices', () {
      expect(PriceFormatter.formatPrice(999999.99), '999999.99 €');
      expect(PriceFormatter.formatPrice(1000000.00), '1000000.00 €');
    });

    test('formatPrice should handle different currencies', () {
      expect(PriceFormatter.formatPrice(29.99, currency: '\$'), '29.99 \$');
      expect(PriceFormatter.formatPrice(19.50, currency: '£'), '19.50 £');
      expect(PriceFormatter.formatPrice(39.95, currency: 'USD'), '39.95 USD');
    });

    test('formatPrice should handle decimal precision correctly', () {
      expect(PriceFormatter.formatPrice(19.1), '19.10 €');
      expect(PriceFormatter.formatPrice(29.555),
          '29.55 €'); // Dart rounds to nearest even
      expect(PriceFormatter.formatPrice(99.999), '100.00 €'); // Should round up
    });

    test('formatWithDiscount should handle zero discount', () {
      expect(PriceFormatter.formatWithDiscount(100.0, 0), '100.00 €');
    });

    test('formatWithDiscount should handle 100% discount', () {
      expect(PriceFormatter.formatWithDiscount(50.0, 100), '0.00 €');
    });

    test('formatWithDiscount should handle fractional discounts', () {
      expect(PriceFormatter.formatWithDiscount(100.0, 12.5), '87.50 €');
      expect(PriceFormatter.formatWithDiscount(200.0, 33.33), '133.34 €');
    });

    test('formatWithDiscount should handle large discounts', () {
      expect(PriceFormatter.formatWithDiscount(1000.0, 75), '250.00 €');
      expect(PriceFormatter.formatWithDiscount(999.99, 90), '100.00 €');
    });

    test('calculateDiscount should return correct amounts', () {
      expect(PriceFormatter.calculateDiscount(100.0, 10), 10.0);
      expect(PriceFormatter.calculateDiscount(200.0, 25), 50.0);
      expect(PriceFormatter.calculateDiscount(75.0, 20), 15.0);
    });

    test('calculateDiscount should handle zero discount', () {
      expect(PriceFormatter.calculateDiscount(100.0, 0), 0.0);
    });

    test('calculateDiscount should handle 100% discount', () {
      expect(PriceFormatter.calculateDiscount(50.0, 100), 50.0);
    });

    test('calculateDiscount should handle fractional percentages', () {
      expect(PriceFormatter.calculateDiscount(100.0, 12.5), 12.5);
      expect(PriceFormatter.calculateDiscount(80.0, 37.5), 30.0);
    });

    test('isValidPrice should validate correctly', () {
      expect(PriceFormatter.isValidPrice(0.0), true);
      expect(PriceFormatter.isValidPrice(0.01), true);
      expect(PriceFormatter.isValidPrice(999.99), true);
      expect(PriceFormatter.isValidPrice(-0.01), false);
      expect(PriceFormatter.isValidPrice(-100.0), false);
    });

    test('isValidPrice should handle edge cases', () {
      expect(PriceFormatter.isValidPrice(double.infinity),
          true); // Technically >= 0
      expect(PriceFormatter.isValidPrice(double.negativeInfinity), false);
      expect(PriceFormatter.isValidPrice(double.nan), false); // NaN is not >= 0
    });

    // Stress tests pour augmenter la couverture
    test('should handle multiple format operations', () {
      for (int i = 0; i < 100; i++) {
        final price = i * 1.99;
        final formatted = PriceFormatter.formatPrice(price);
        expect(formatted, contains('€'));
        expect(formatted, contains('.'));
      }
    });

    test('should handle multiple discount calculations', () {
      final prices = [10.0, 25.50, 99.99, 150.75, 299.95];
      final discounts = [5.0, 10.0, 15.0, 20.0, 25.0, 50.0];

      for (final price in prices) {
        for (final discount in discounts) {
          final result = PriceFormatter.formatWithDiscount(price, discount);
          expect(result, isA<String>());
          expect(result, contains('€'));

          final discountAmount =
              PriceFormatter.calculateDiscount(price, discount);
          expect(discountAmount, lessThanOrEqualTo(price));
          expect(discountAmount, greaterThanOrEqualTo(0));
        }
      }
    });

    test('should validate many price values', () {
      final testPrices = [
        0.0,
        0.01,
        1.0,
        10.0,
        99.99,
        100.0,
        999.99,
        1000.0,
        -0.01,
        -1.0,
        -100.0
      ];

      for (final price in testPrices) {
        final isValid = PriceFormatter.isValidPrice(price);
        if (price >= 0) {
          expect(isValid, true, reason: 'Price $price should be valid');
        } else {
          expect(isValid, false, reason: 'Price $price should be invalid');
        }
      }
    });
  });
}
