import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../../auth/presentation/providers/auth_providers.dart';
import '../../products/presentation/providers/products_providers.dart';
import '../../products/presentation/view/product_details_page.dart';
import '../../cart/presentation/view/cart_page.dart';
import '../../cart/presentation/providers/cart_providers.dart';
import '../../profile/presentation/view/profile_page.dart';
import '../../favorites/presentation/providers/favorites_providers.dart';
import '../../favorites/presentation/view/favorites_page.dart';

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
  } // Méthode responsive pour déterminer le nombre de colonnes

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (kIsWeb) {
      if (width >= 1200) return 5; // Desktop large
      if (width >= 900) return 4; // Desktop
      if (width >= 600) return 3; // Tablet
      return 2; // Mobile
    }
    return 2; // Mobile par défaut
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
                                fontSize: kIsWeb &&
                                        MediaQuery.of(context).size.width > 600
                                    ? 32
                                    : 24,
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
                                fontSize: kIsWeb &&
                                        MediaQuery.of(context).size.width > 600
                                    ? 32
                                    : 24,
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
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: _getCrossAxisCount(context),
                                childAspectRatio: kIsWeb &&
                                        MediaQuery.of(context).size.width > 900
                                    ? 0.8
                                    : 0.75,
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
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Home
              _buildNavItem(
                icon: Icons.home,
                isSelected: true,
                onTap: () {},
              ),

              // Cart
              Consumer(
                builder: (context, ref, child) {
                  final cartState = ref.watch(cartViewModelProvider);
                  final itemCount = cartState.items.fold<int>(
                    0,
                    (sum, item) => sum + item.quantity,
                  );

                  return _buildNavItemWithBadge(
                    icon: Icons.shopping_cart_outlined,
                    isSelected: false,
                    badgeCount: itemCount,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const CartPage()),
                      );
                    },
                  );
                },
              ),

              // Favorites
              Consumer(
                builder: (context, ref, child) {
                  final favoritesState = ref.watch(favoritesProvider);
                  final hasFavorites = favoritesState.favoriteIds.isNotEmpty;

                  return _buildNavItemWithNotification(
                    icon: Icons.favorite_border,
                    isSelected: false,
                    hasNotification: hasFavorites,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => const FavoritesPage()),
                      );
                    },
                  );
                },
              ),

              // Profile
              _buildNavItem(
                icon: Icons.person_outline,
                isSelected: false,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ProfilePage()),
                  );
                },
              ),

              // Test des fonctionnalités (Debug uniquement)
              if (kDebugMode)
                _buildNavItem(
                  icon: Icons.bug_report,
                  isSelected: false,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const _PlatformTestPage()),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget pour les éléments du menu moderne
  Widget _buildNavItem({
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.grey[600],
          size: 24,
        ),
      ),
    );
  }

  Widget _buildNavItemWithBadge({
    required IconData icon,
    required bool isSelected,
    required int badgeCount,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected ? Colors.green : Colors.transparent,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey[600],
              size: 24,
            ),
          ),
          if (badgeCount > 0)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(
                  minWidth: 20,
                  minHeight: 20,
                ),
                child: Text(
                  '$badgeCount',
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
      ),
    );
  }

  Widget _buildNavItemWithNotification({
    required IconData icon,
    required bool isSelected,
    required bool hasNotification,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected ? Colors.green : Colors.transparent,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey[600],
              size: 24,
            ),
          ),
          if (hasNotification)
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// Page de test simple intégrée
class _PlatformTestPage extends StatelessWidget {
  const _PlatformTestPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🔧 Test des Fonctionnalités'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '🌐 Détection de Plateforme',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Text('Web: ${kIsWeb ? '✅ Détecté' : '❌ Non détecté'}'),
                    if (kIsWeb) const Text('✅ PWA et Partage Web disponibles'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '📱 Grille Responsive',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Text(
                        'Largeur écran: ${MediaQuery.of(context).size.width.toInt()}px'),
                    Text('Colonnes: ${_getColumns(context)}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (kIsWeb)
              Card(
                child: ListTile(
                  leading: const Icon(Icons.share, color: Colors.blue),
                  title: const Text('Test Partage Web'),
                  subtitle: const Text('Testez la Web Share API'),
                  onTap: () async {
                    try {
                      await Share.share(
                        'Test de partage depuis SHOPIFUN !',
                        subject: 'SHOPIFUN Test',
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Partage testé avec succès !'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  int _getColumns(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (kIsWeb) {
      if (width >= 1200) return 5;
      if (width >= 900) return 4;
      if (width >= 600) return 3;
      return 2;
    }
    return 2;
  }
}
