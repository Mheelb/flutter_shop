import '../../../products/domain/models/product.dart';

class ProductDetailsState {
  final bool isLoading;
  final String? errorMessage;
  final Product? product;

  const ProductDetailsState({
    this.isLoading = false,
    this.errorMessage,
    this.product,
  });

  ProductDetailsState copyWith({
    bool? isLoading,
    String? errorMessage,
    Product? product,
  }) {
    return ProductDetailsState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      product: product ?? this.product,
    );
  }
}


