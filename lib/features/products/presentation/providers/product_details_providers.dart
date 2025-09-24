import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../products/presentation/providers/products_providers.dart';
import '../viewmodel/product_details_state.dart';
import '../viewmodel/product_details_view_model.dart';

final productDetailsViewModelProvider = StateNotifierProvider.autoDispose<
    ProductDetailsViewModel, ProductDetailsState>((ref) {
  final repo = ref.read(productsRepositoryProvider);
  return ProductDetailsViewModel(repo);
});


