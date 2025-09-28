class PriceFormatter {
  static String formatPrice(double price, {String currency = '€'}) {
    return '${price.toStringAsFixed(2)} $currency';
  }

  static String formatWithDiscount(
      double originalPrice, double discountPercent) {
    final discountAmount = originalPrice * (discountPercent / 100);
    final finalPrice = originalPrice - discountAmount;
    return formatPrice(finalPrice);
  }

  static double calculateDiscount(
      double originalPrice, double discountPercent) {
    return originalPrice * (discountPercent / 100);
  }

  static bool isValidPrice(double price) {
    return price >= 0;
  }
}
