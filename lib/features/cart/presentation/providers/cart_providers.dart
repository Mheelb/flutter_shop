import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../cart/data/repositories/cart_repository_impl.dart';
import '../../../cart/domain/repositories/cart_repository.dart';
import '../../../products/presentation/providers/products_providers.dart';
import '../viewmodel/cart_state.dart';
import '../viewmodel/cart_view_model.dart';

final cartRepositoryProvider = Provider<CartRepository>((ref) {
  return CartRepositoryImpl();
});

final cartViewModelProvider =
    StateNotifierProvider<CartViewModel, CartState>((ref) {
  final cartRepo = ref.read(cartRepositoryProvider);
  final productsRepo = ref.read(productsRepositoryProvider);
  return CartViewModel(cartRepo, productsRepo);
});
