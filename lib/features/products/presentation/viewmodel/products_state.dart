import '../../../products/domain/models/product.dart';

class ProductsState {
  final bool isLoading;
  final String? errorMessage;
  final List<Product> products;

  const ProductsState({
    this.isLoading = false,
    this.errorMessage,
    this.products = const [],
  });

  ProductsState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<Product>? products,
  }) {
    return ProductsState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      products: products ?? this.products,
    );
  }
}


