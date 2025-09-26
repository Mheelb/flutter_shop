class CartItem {
  final int productId;
  final int quantity;

  const CartItem({required this.productId, required this.quantity});

  CartItem copyWith({int? productId, int? quantity}) => CartItem(
        productId: productId ?? this.productId,
        quantity: quantity ?? this.quantity,
      );

  Map<String, dynamic> toJson() => {
        'id': productId, // Fakestore example used 'id'
        'productId': productId, // also include canonical key if needed
        'quantity': quantity,
      };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        productId: (json['productId'] ?? json['id']) as int,
        quantity: (json['quantity'] ?? 1) as int,
      );
}

class Cart {
  final int id;
  final int userId;
  final List<CartItem> items;

  const Cart({required this.id, required this.userId, required this.items});

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'products': items
            .map((e) => {
                  'productId': e.productId,
                  'quantity': e.quantity,
                })
            .toList(),
      };

  factory Cart.fromJson(Map<String, dynamic> json) {
    final products = (json['products'] as List<dynamic>? ?? [])
        .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
        .toList();
    return Cart(
      id: (json['id'] ?? 0) as int,
      userId: (json['userId'] ?? 0) as int,
      items: products,
    );
  }
}
