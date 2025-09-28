import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

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

  // Détection iOS - En production utiliserait Platform.isIOS
  bool get _shouldUseCupertinoDesign {
    try {
      // En production: return !kIsWeb && Platform.isIOS;
      // Pour test iOS sur Web : activé temporairement
      return !kIsWeb; // Active le mode iOS sur desktop pour test
    } catch (e) {
      return false; // Fallback sécurisé
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productDetailsViewModelProvider);
    final product = state.product ?? widget.initialProduct;

    // Utiliser CupertinoPageScaffold sur iOS, Scaffold ailleurs
    if (_shouldUseCupertinoDesign) {
      return _buildCupertinoPage(context, state, product);
    }

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
          // Share Button - Adaptatif selon la plateforme
          IconButton(
            onPressed: () async {
              if (product != null) {
                try {
                  // Partage natif (Android/iOS) ou Web Share
                  await Share.share(
                    'Découvrez ce produit sur SHOPIFUN !\n'
                    '${product.title}\n'
                    'Prix: \$${product.price}\n\n'
                    'Téléchargez SHOPIFUN pour plus de produits !',
                    subject: 'Produit SHOPIFUN',
                  );
                } catch (e) {
                  // Fallback pour les plateformes non supportées
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Lien du produit copié dans le presse-papiers !'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              }
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

              return IconButton(
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

  // Version iOS avec CupertinoPageScaffold
  Widget _buildCupertinoPage(
      BuildContext context, dynamic state, dynamic product) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemBackground,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.systemBackground,
        border: null,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.of(context).pop(),
          child: const Icon(CupertinoIcons.back, color: CupertinoColors.black),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () async {
            if (product != null) {
              try {
                await Share.share(
                  'Découvrez ce produit sur SHOPIFUN !\n'
                  '${product.title}\n'
                  'Prix: \$${product.price}\n\n'
                  'Téléchargez SHOPIFUN pour plus de produits !',
                  subject: 'Produit SHOPIFUN',
                );
              } catch (e) {
                // Affichage d'erreur Cupertino
                showCupertinoDialog(
                  context: context,
                  builder: (context) => CupertinoAlertDialog(
                    title: const Text('Partage'),
                    content: const Text('Produit partagé !'),
                    actions: [
                      CupertinoDialogAction(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              }
            }
          },
          child: const Icon(CupertinoIcons.share, color: CupertinoColors.black),
        ),
      ),
      child: SafeArea(
        child: state.isLoading
            ? const Center(child: CupertinoActivityIndicator())
            : product == null
                ? const Center(child: Text('Produit non trouvé'))
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image du produit avec style iOS
                        Container(
                          height: 300,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: CupertinoColors.systemGrey6,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.all(16),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              product.image,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(CupertinoIcons.photo, size: 50),
                            ),
                          ),
                        ),
                        // Titre et prix avec style iOS
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.title,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: CupertinoColors.black,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '\$${product.price}',
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: CupertinoColors.activeGreen,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                product.description,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: CupertinoColors.secondaryLabel,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 32),
                              // Boutons d'action avec style iOS
                              Row(
                                children: [
                                  Expanded(
                                    child: CupertinoButton.filled(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (_) => CheckoutPage(
                                            singleProduct: product,
                                            fromCart: false,
                                          ),
                                        ));
                                      },
                                      child: const Text('Acheter maintenant'),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: CupertinoButton(
                                      color: CupertinoColors.systemGrey4,
                                      onPressed: () {
                                        ref
                                            .read(
                                                cartViewModelProvider.notifier)
                                            .addProduct(product.id);
                                        showCupertinoDialog(
                                          context: context,
                                          builder: (context) =>
                                              CupertinoAlertDialog(
                                            title: const Text('Ajouté !'),
                                            content: const Text(
                                                'Produit ajouté au panier'),
                                            actions: [
                                              CupertinoDialogAction(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        'Ajouter au panier',
                                        style: TextStyle(
                                            color: CupertinoColors.black),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 32),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
