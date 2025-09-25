import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/product_details_providers.dart';
import '../../domain/models/product.dart';
import '../../../cart/presentation/providers/cart_providers.dart';
import '../../../cart/presentation/view/cart_page.dart';
import '../../../checkout/presentation/view/checkout_page.dart';
import '../../../favorites/presentation/providers/favorites_providers.dart';

class ProductDetailsPage extends ConsumerStatefulWidget {
  final int productId;
  final Product? initialProduct;

  const ProductDetailsPage(
      {super.key, required this.productId, this.initialProduct});

  @override
  ConsumerState<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends ConsumerState<ProductDetailsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref
        .read(productDetailsViewModelProvider.notifier)
        .load(widget.productId));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productDetailsViewModelProvider);
    final product = state.product ?? widget.initialProduct;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        actions: [
          // Share Button
          IconButton(
            onPressed: () {
              // Share functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Partage en cours...'),
                  backgroundColor: Colors.blue,
                ),
              );
            },
            icon: const Icon(Icons.share, color: Colors.black),
          ),

          // Cart Button
          Consumer(
            builder: (context, ref, child) {
              final cartState = ref.watch(cartViewModelProvider);
              final itemCount = cartState.items.fold<int>(
                0,
                (sum, item) => sum + item.quantity,
              );

              return Stack(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const CartPage()),
                      );
                    },
                    icon: const Icon(Icons.shopping_cart_outlined,
                        color: Colors.black),
                  ),
                  if (itemCount > 0)
                    Positioned(
                      right: 4,
                      top: 4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Text(
                          '$itemCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),

          // Favorite Button
          Consumer(
            builder: (context, ref, child) {
              if (product == null) return const SizedBox.shrink();

              final isFavorite = ref.watch(
                favoritesProvider.select(
                  (state) => state.favoriteIds.contains(product.id),
                ),
              );

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      ref
                          .read(favoritesProvider.notifier)
                          .toggleFavorite(product.id);
                    },
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: Colors.red,
                      size: 24,
                    ),
                  ),
                  if (isFavorite)
                    Text(
                      "J'adore",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 8,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: state.isLoading && product == null
          ? const Center(child: CircularProgressIndicator())
          : state.errorMessage != null && product == null
              ? Center(child: Text(state.errorMessage!))
              : Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product Image
                            Container(
                              height: 300,
                              width: double.infinity,
                              color: Colors.grey[50],
                              child: Hero(
                                tag: 'product-${product!.id}',
                                child: Image.network(
                                  product.imageUrl,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),

                            // Product Info
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Title
                                  Text(
                                    product.title,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  // Rating
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.star,
                                            color: Colors.amber, size: 16),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${product.rating}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '(${product.ratingCount} avis)',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 16),

                                  // Description
                                  Text(
                                    product.description,
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 14,
                                      height: 1.5,
                                    ),
                                  ),

                                  const SizedBox(height: 30),

                                  // Price
                                  Text(
                                    '\$${product.price.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Action Buttons
                    Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Buy Now Button
                          Expanded(
                            flex: 2,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Colors.green, Color(0xFF2E7D32)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          CheckoutPage(singleProduct: product),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  foregroundColor: Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.shopping_cart, size: 18),
                                    const SizedBox(width: 8),
                                    const Text(
                                      'Acheter',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          // Add to Cart Button
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                final id = product.id;
                                ref
                                    .read(cartViewModelProvider.notifier)
                                    .addProduct(id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Ajouté au panier'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.green,
                                side: BorderSide(color: Colors.green, width: 2),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.add, size: 18),
                                  const SizedBox(width: 4),
                                  const Text(
                                    'Ajouter',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}
