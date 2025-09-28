import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../products/data/repositories/products_repository_impl.dart';
import '../../../products/domain/repositories/products_repository.dart';
import '../viewmodel/products_state.dart';
import '../viewmodel/products_view_model.dart';

final productsRepositoryProvider = Provider<ProductsRepository>((ref) {
  return ProductsRepositoryImpl();
});

final productsViewModelProvider =
    StateNotifierProvider<ProductsViewModel, ProductsState>((ref) {
  final repo = ref.read(productsRepositoryProvider);
  return ProductsViewModel(repo);
});
