class AppConstants {
  static const String appName = 'Flutter Shop';
  static const String appVersion = '1.0.0';
  static const int maxProductsPerPage = 20;
  static const Duration networkTimeout = Duration(seconds: 30);

  // API Constants
  static const String baseUrl = 'https://fakestoreapi.com';
  static const String productsEndpoint = '/products';

  // Cache durations
  static const Duration cacheTimeout = Duration(minutes: 5);
  static const Duration imageCacheTimeout = Duration(hours: 24);

  // Validation constants
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 128;

  static bool isValidPassword(String password) {
    return password.length >= minPasswordLength &&
        password.length <= maxPasswordLength;
  }

  static String getProductUrl(int productId) {
    return '$baseUrl$productsEndpoint/$productId';
  }
}
