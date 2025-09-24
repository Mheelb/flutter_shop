import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../products/domain/repositories/products_repository.dart';
import 'product_details_state.dart';

class ProductDetailsViewModel extends StateNotifier<ProductDetailsState> {
  final ProductsRepository _repository;

  ProductDetailsViewModel(this._repository) : super(const ProductDetailsState());

  Future<void> load(int id) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final item = await _repository.fetchProduct(id);
      state = state.copyWith(product: item);
    } catch (e) {
      state = state.copyWith(errorMessage: 'Erreur de chargement: $e');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}


