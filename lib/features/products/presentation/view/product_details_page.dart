import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/product_details_providers.dart';
import '../../domain/models/product.dart';
import '../../../cart/presentation/providers/cart_providers.dart';

class ProductDetailsPage extends ConsumerStatefulWidget {
  final int productId;
  final Product? initialProduct;

  const ProductDetailsPage({super.key, required this.productId, this.initialProduct});

  @override
  ConsumerState<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends ConsumerState<ProductDetailsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(productDetailsViewModelProvider.notifier).load(widget.productId));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productDetailsViewModelProvider);
    final product = state.product ?? widget.initialProduct;

    return Scaffold(
      appBar: AppBar(title: const Text('Détails du produit')),
      body: state.isLoading && product == null
          ? const Center(child: CircularProgressIndicator())
          : state.errorMessage != null && product == null
              ? Center(child: Text(state.errorMessage!))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Hero(
                          tag: 'product-${product!.id}',
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              color: Colors.white,
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: Image.network(product.imageUrl, fit: BoxFit.contain),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        product.title,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 18),
                          const SizedBox(width: 4),
                          Text('${product.rating} (${product.ratingCount})'),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${product.price.toStringAsFixed(2)} €',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(product.category.toUpperCase(), style: const TextStyle(letterSpacing: 1.2, color: Colors.grey)),
                      const SizedBox(height: 12),
                      Text(product.description),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            final id = product.id;
                            ref.read(cartViewModelProvider.notifier).addProduct(id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Ajouté au panier')),
                            );
                          },
                          icon: const Icon(Icons.add_shopping_cart),
                          label: const Text('Ajouter au panier'),
                          style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}


