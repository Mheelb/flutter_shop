import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_shop/core/utils/price_formatter.dart';

void main() {
  group('PriceFormatter', () {
    group('formatPrice', () {
      test('should format price with default currency', () {
        expect(PriceFormatter.formatPrice(29.99), '29.99 €');
        expect(PriceFormatter.formatPrice(100.0), '100.00 €');
      });

      test('should format price with custom currency', () {
        expect(PriceFormatter.formatPrice(29.99, currency: '\$'), '29.99 \$');
        expect(
            PriceFormatter.formatPrice(100.0, currency: 'USD'), '100.00 USD');
      });

      test('should handle integer prices', () {
        expect(PriceFormatter.formatPrice(25), '25.00 €');
      });
    });

    group('formatWithDiscount', () {
      test('should calculate and format discounted price', () {
        // 100€ avec 20% de réduction = 80€
        expect(PriceFormatter.formatWithDiscount(100.0, 20.0), '80.00 €');

        // 50€ avec 10% de réduction = 45€
        expect(PriceFormatter.formatWithDiscount(50.0, 10.0), '45.00 €');
      });

      test('should handle zero discount', () {
        expect(PriceFormatter.formatWithDiscount(100.0, 0.0), '100.00 €');
      });
    });

    group('calculateDiscount', () {
      test('should calculate discount amount correctly', () {
        expect(PriceFormatter.calculateDiscount(100.0, 20.0), 20.0);
        expect(PriceFormatter.calculateDiscount(50.0, 10.0), 5.0);
        expect(PriceFormatter.calculateDiscount(200.0, 15.0), 30.0);
      });

      test('should handle zero discount', () {
        expect(PriceFormatter.calculateDiscount(100.0, 0.0), 0.0);
      });
    });

    group('isValidPrice', () {
      test('should return true for valid prices', () {
        expect(PriceFormatter.isValidPrice(0.0), true);
        expect(PriceFormatter.isValidPrice(29.99), true);
        expect(PriceFormatter.isValidPrice(1000.0), true);
      });

      test('should return false for negative prices', () {
        expect(PriceFormatter.isValidPrice(-1.0), false);
        expect(PriceFormatter.isValidPrice(-29.99), false);
      });
    });
  });
}
