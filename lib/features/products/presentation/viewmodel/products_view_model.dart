import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../products/domain/repositories/products_repository.dart';
import 'products_state.dart';

class ProductsViewModel extends StateNotifier<ProductsState> {
  final ProductsRepository _repository;

  ProductsViewModel(this._repository) : super(const ProductsState());

  Future<void> load() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final items = await _repository.fetchAllProducts();
      state = state.copyWith(products: items);
    } catch (e) {
      state = state.copyWith(errorMessage: 'Erreur de chargement: $e');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}


