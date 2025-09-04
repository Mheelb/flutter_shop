import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/cart.dart';
import '../../../movies/domain/models/movie.dart';

// Provider pour l'état du panier
final cartProvider = StateNotifierProvider<CartNotifier, Cart>((ref) {
  return CartNotifier();
});

// Provider pour le nombre d'éléments dans le panier
final cartItemCountProvider = Provider<int>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.itemCount;
});

// Provider pour le total du panier
final cartTotalProvider = Provider<double>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.totalPrice;
});

// Notifier pour gérer l'état du panier
class CartNotifier extends StateNotifier<Cart> {
  CartNotifier() : super(Cart());

  void addMovie(Movie movie, {double price = 4.99}) {
    state = state.addItem(movie, price: price);
  }

  void removeMovie(Movie movie) {
    state = state.removeItem(movie);
  }

  void clearCart() {
    state = state.clear();
  }

  bool isInCart(Movie movie) {
    return state.contains(movie);
  }
}
