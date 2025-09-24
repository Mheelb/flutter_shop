import 'cart.dart';

class Order {
  final int id;
  final int userId;
  final List<CartItem> items;
  final double total;
  final DateTime createdAt;

  const Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.total,
    required this.createdAt,
  });
}


