import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/presentation/providers/auth_providers.dart';
import '../../products/presentation/providers/products_providers.dart';
import '../../products/presentation/view/product_details_page.dart';
import '../../cart/presentation/view/cart_page.dart';
import '../../cart/presentation/providers/cart_providers.dart';
import '../../profile/presentation/view/profile_page.dart';
import '../../favorites/presentation/providers/favorites_providers.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(productsViewModelProvider.notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final productsState = ref.watch(productsViewModelProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: authState.when(
          data: (user) => Column(
            children: [
              // Header avec titre et panier
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'SHOPI',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                        ),
                        Text(
                          'FUN',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                        ),
                      ],
                    ),
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
                                  MaterialPageRoute(
                                      builder: (_) => const CartPage()),
                                );
                              },
                              icon: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.shopping_cart_outlined,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                            if (itemCount > 0)
                              Positioned(
                                right: 2,
                                top: 2,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.white, width: 2),
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 20,
                                    minHeight: 20,
                                  ),
                                  child: Text(
                                    '$itemCount',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
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
                  ],
                ),
              ),

              // Barre de recherche
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    onChanged:
                        ref.read(productsViewModelProvider.notifier).setQuery,
                    decoration: InputDecoration(
                      hintText: 'Search',
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Products Grid
              Expanded(
                child: productsState.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : productsState.errorMessage != null
                        ? Center(child: Text(productsState.errorMessage!))
                        : Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.75,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                              ),
                              itemCount: productsState.filteredProducts.length,
                              itemBuilder: (context, index) {
                                final product =
                                    productsState.filteredProducts[index];

                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => ProductDetailsPage(
                                          productId: product.id,
                                          initialProduct: product,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 10,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.vertical(
                                                top: Radius.circular(16),
                                              ),
                                            ),
                                            child: Stack(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius
                                                          .vertical(
                                                    top: Radius.circular(16),
                                                  ),
                                                  child: Image.network(
                                                    product.imageUrl,
                                                    fit: BoxFit.contain,
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                  ),
                                                ),
                                                // Cœur de favoris en haut à droite
                                                Positioned(
                                                  top: 8,
                                                  right: 8,
                                                  child: Consumer(
                                                    builder:
                                                        (context, ref, child) {
                                                      final isFavorite =
                                                          ref.watch(
                                                        favoritesProvider
                                                            .select(
                                                          (state) => state
                                                              .favoriteIds
                                                              .contains(
                                                                  product.id),
                                                        ),
                                                      );

                                                      return GestureDetector(
                                                        onTap: () {
                                                          ref
                                                              .read(
                                                                  favoritesProvider
                                                                      .notifier)
                                                              .toggleFavorite(
                                                                  product.id);
                                                        },
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(6),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white
                                                                .withOpacity(
                                                                    0.9),
                                                            shape:
                                                                BoxShape.circle,
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.1),
                                                                blurRadius: 4,
                                                                offset:
                                                                    const Offset(
                                                                        0, 2),
                                                              ),
                                                            ],
                                                          ),
                                                          child: Icon(
                                                            isFavorite
                                                                ? Icons.favorite
                                                                : Icons
                                                                    .favorite_border,
                                                            color: isFavorite
                                                                ? Colors.red
                                                                : Colors
                                                                    .grey[600],
                                                            size: 16,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                product.title,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  Icon(Icons.star,
                                                      color: Colors.amber,
                                                      size: 16),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    '${product.rating}',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                '\$${product.price.toStringAsFixed(2)}',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
              ),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Erreur: $error')),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            // Search - déjà sur la page principale
          } else if (index == 2) {
            // Favorites - à implémenter si nécessaire
          } else if (index == 3) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ProfilePage()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
