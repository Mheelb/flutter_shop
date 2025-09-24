import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/cart_providers.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cartViewModelProvider);
    final vm = ref.read(cartViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panier'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: state.items.isEmpty
            ? const Center(child: Text('Votre panier est vide'))
            : Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      itemCount: state.items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final item = state.items[index];
                        final product = state.productsIndex[item.productId];
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.12),
                              child: const Icon(Icons.shopping_bag),
                            ),
                            title: Text(product?.title ?? 'Produit #${item.productId}'),
                            subtitle: Text('${product?.price.toStringAsFixed(2) ?? '--'} €'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  onPressed: () => vm.changeQuantity(item.productId, item.quantity - 1),
                                ),
                                Text(item.quantity.toString()),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline),
                                  onPressed: () => vm.changeQuantity(item.productId, item.quantity + 1),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed: () => vm.removeProduct(item.productId),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Total: ${state.total.toStringAsFixed(2)} €',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: state.items.isEmpty
                            ? null
                            : () async {
                                final ok = await showDialog<bool>(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('Confirmer le paiement'),
                                    content: Text('Payer ${state.total.toStringAsFixed(2)} € ? (mock)'),
                                    actions: [
                                      TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Annuler')),
                                      ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Payer')),
                                    ],
                                  ),
                                );
                                if (ok == true) {
                                  await vm.clearCart();
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Commande créée (mock) !')),
                                    );
                                    Navigator.pop(context);
                                  }
                                }
                              },
                        icon: const Icon(Icons.lock_outline),
                        label: const Text('Passer au paiement'),
                      )
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}


