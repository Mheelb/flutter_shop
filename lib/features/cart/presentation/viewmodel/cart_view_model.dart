import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../cart/domain/models/cart.dart';
import '../../../cart/domain/repositories/cart_repository.dart';
import '../../../products/domain/models/product.dart';
import '../../../products/domain/repositories/products_repository.dart';
import 'cart_state.dart';

class CartViewModel extends StateNotifier<CartState> {
  final CartRepository _cartRepo;
  final ProductsRepository _productsRepo;
  int? _serverCartId; // store fakestore cart id
  final int _userId = 1; // demo user id

  CartViewModel(this._cartRepo, this._productsRepo) : super(const CartState());

  Future<void> addProduct(int productId) async {
    final existing = [...state.items];
    final idx = existing.indexWhere((e) => e.productId == productId);
    if (idx >= 0) {
      existing[idx] = existing[idx].copyWith(quantity: existing[idx].quantity + 1);
    } else {
      existing.add(CartItem(productId: productId, quantity: 1));
    }
    state = state.copyWith(items: existing);

    // update local product cache
    if (!state.productsIndex.containsKey(productId)) {
      final p = await _productsRepo.fetchProduct(productId);
      final nextIndex = {...state.productsIndex, productId: p};
      state = state.copyWith(productsIndex: nextIndex);
    }

    await _syncToServer();
  }

  Future<void> removeProduct(int productId) async {
    final existing = state.items.where((e) => e.productId != productId).toList();
    state = state.copyWith(items: existing);
    await _syncToServer();
  }

  Future<void> changeQuantity(int productId, int quantity) async {
    final existing = [...state.items];
    final idx = existing.indexWhere((e) => e.productId == productId);
    if (idx >= 0) {
      if (quantity <= 0) {
        existing.removeAt(idx);
      } else {
        existing[idx] = existing[idx].copyWith(quantity: quantity);
      }
      state = state.copyWith(items: existing);
      await _syncToServer();
    }
  }

  Future<void> clearCart() async {
    state = state.copyWith(items: []);
    if (_serverCartId != null) {
      await _cartRepo.deleteCart(_serverCartId!);
      _serverCartId = null;
    }
  }

  Future<void> _syncToServer() async {
    if (state.items.isEmpty) {
      if (_serverCartId != null) {
        await _cartRepo.deleteCart(_serverCartId!);
        _serverCartId = null;
      }
      return;
    }
    if (_serverCartId == null) {
      final created = await _cartRepo.createCart(_userId, state.items);
      _serverCartId = created.id;
    } else {
      await _cartRepo.updateCart(_serverCartId!, _userId, state.items);
    }
  }
}


