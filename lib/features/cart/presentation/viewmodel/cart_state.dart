import '../../../cart/domain/models/cart.dart';
import '../../../products/domain/models/product.dart';

class CartState {
  final bool isLoading;
  final String? errorMessage;
  final List<CartItem> items;
  final Map<int, Product> productsIndex; // for price/title when available

  const CartState({
    this.isLoading = false,
    this.errorMessage,
    this.items = const [],
    this.productsIndex = const {},
  });

  double get total => items.fold(0.0, (sum, i) {
        final p = productsIndex[i.productId];
        return sum + (p != null ? p.price * i.quantity : 0.0);
      });

  CartState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<CartItem>? items,
    Map<int, Product>? productsIndex,
  }) {
    return CartState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      items: items ?? this.items,
      productsIndex: productsIndex ?? this.productsIndex,
    );
  }
}
