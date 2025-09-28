import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../products/domain/models/product.dart';
import '../../../cart/presentation/providers/cart_providers.dart';

class CheckoutPage extends ConsumerStatefulWidget {
  final Product? singleProduct;
  final bool fromCart;

  const CheckoutPage({
    super.key,
    this.singleProduct,
    this.fromCart = false,
  });

  @override
  ConsumerState<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends ConsumerState<CheckoutPage> {
  String selectedPaymentMethod = '';
  bool isLoadingProducts = false;

  @override
  void initState() {
    super.initState();
    // Charger les produits manquants si nécessaire
    if (widget.fromCart) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadMissingProducts();
      });
    }
  }

  Future<void> _loadMissingProducts() async {
    setState(() {
      isLoadingProducts = true;
    });

    try {
      final cartState = ref.read(cartViewModelProvider);
      final cartNotifier = ref.read(cartViewModelProvider.notifier);

      print('🛒 CHECKOUT DEBUG: Items in cart: ${cartState.items.length}');
      print(
          '🛒 CHECKOUT DEBUG: Products in index: ${cartState.productsIndex.length}');
      print('🛒 CHECKOUT DEBUG: Cart state total: ${cartState.total}');

      for (var item in cartState.items) {
        print(
            '🛒 CHECKOUT DEBUG: Checking product ${item.productId}, quantity: ${item.quantity}');
        if (!cartState.productsIndex.containsKey(item.productId)) {
          print('🛒 CHECKOUT DEBUG: Loading missing product ${item.productId}');
          // Force le chargement du produit manquant
          await cartNotifier.addProduct(item.productId);
          await cartNotifier.changeQuantity(item.productId, item.quantity);
        }
      }

      // Attendre un peu pour que le state se mette à jour
      await Future.delayed(const Duration(milliseconds: 100));

      final updatedCartState = ref.read(cartViewModelProvider);
      print(
          '🛒 CHECKOUT DEBUG: After loading - total: ${updatedCartState.total}');
      print(
          '🛒 CHECKOUT DEBUG: After loading - products in index: ${updatedCartState.productsIndex.length}');
    } finally {
      if (mounted) {
        setState(() {
          isLoadingProducts = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartViewModelProvider);

    // Debug prints
    print('🎯 BUILD DEBUG: Cart state total: ${cartState.total}');
    print(
        '🎯 BUILD DEBUG: Products in index: ${cartState.productsIndex.keys.toList()}');
    print(
        '🎯 BUILD DEBUG: Cart items: ${cartState.items.map((e) => '${e.productId}:${e.quantity}').toList()}');

    // Calculer les produits à afficher
    List<Widget> productWidgets = [];
    double total = 0.0;

    if (widget.singleProduct != null) {
      // Achat direct d'un produit
      total = widget.singleProduct!.price;
      productWidgets.add(_buildProductItem(widget.singleProduct!, 1));
    } else if (widget.fromCart) {
      // Achat depuis le panier - utiliser le total du state
      total = cartState.total;
      print('🎯 BUILD DEBUG: Using cart total: $total');

      for (var item in cartState.items) {
        final product = cartState.productsIndex[item.productId];
        if (product != null) {
          productWidgets.add(_buildProductItem(product, item.quantity));
        } else {
          print('🎯 BUILD DEBUG: Product ${item.productId} not found in index');
        }
      }
    }

    // Si on est en train de charger les produits, afficher un loading
    if (isLoadingProducts && widget.fromCart) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back, color: Colors.black),
          ),
          title: const Text(
            'Commande',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: const Text(
          'Commande',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Produits
                  Container(
                    padding: const EdgeInsets.all(16.0),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Produits',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...productWidgets,
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Méthodes de paiement
                  Container(
                    padding: const EdgeInsets.all(16.0),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Méthode de paiement',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Google Pay
                        _buildPaymentOption(
                          'google_pay',
                          'Google Pay',
                          Icons.account_balance_wallet,
                          Colors.blue,
                        ),

                        // Apple Pay
                        _buildPaymentOption(
                          'apple_pay',
                          'Apple Pay',
                          Icons.apple,
                          Colors.black,
                        ),

                        // Carte de crédit
                        _buildPaymentOption(
                          'credit_card',
                          'Carte de crédit',
                          Icons.credit_card,
                          Colors.green,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Résumé
                  Container(
                    padding: const EdgeInsets.all(16.0),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Résumé',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '\$${total.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bouton de paiement
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
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedPaymentMethod.isEmpty
                    ? null
                    : () {
                        _processPayment();
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedPaymentMethod.isEmpty
                      ? Colors.grey
                      : Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  selectedPaymentMethod.isEmpty
                      ? 'Choisir une méthode de paiement'
                      : 'Payer \$${total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductItem(Product product, int quantity) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              product.imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Quantité: $quantity',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Text(
            '\$${(product.price * quantity).toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(
      String id, String title, IconData icon, Color color) {
    final isSelected = selectedPaymentMethod == id;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPaymentMethod = id;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green.withOpacity(0.1) : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? Colors.green : Colors.black,
                ),
              ),
            ),
            if (isSelected) const Icon(Icons.check_circle, color: Colors.green),
          ],
        ),
      ),
    );
  }

  void _processPayment() {
    String paymentMethodName = '';
    switch (selectedPaymentMethod) {
      case 'google_pay':
        paymentMethodName = 'Google Pay';
        break;
      case 'apple_pay':
        paymentMethodName = 'Apple Pay';
        break;
      case 'credit_card':
        paymentMethodName = 'Carte de crédit';
        break;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Paiement confirmé!'),
        content: Text(
            'Votre paiement via $paymentMethodName a été traité avec succès.'),
        actions: [
          TextButton(
            onPressed: () {
              // Vider le panier si achat depuis le panier
              if (widget.fromCart) {
                ref.read(cartViewModelProvider.notifier).clearCart();
              }
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Back to previous page
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
