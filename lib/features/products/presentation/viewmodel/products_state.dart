import '../../../products/domain/models/product.dart';

class ProductsState {
  final bool isLoading;
  final String? errorMessage;
  final List<Product> products;
  final String query;

  const ProductsState({
    this.isLoading = false,
    this.errorMessage,
    this.products = const [],
    this.query = '',
  });

  ProductsState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<Product>? products,
    String? query,
  }) {
    return ProductsState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      products: products ?? this.products,
      query: query ?? this.query,
    );
  }

  List<Product> get filteredProducts {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return products;
    return products.where((p) {
      return p.title.toLowerCase().contains(q) ||
          p.category.toLowerCase().contains(q);
    }).toList();
  }
}
