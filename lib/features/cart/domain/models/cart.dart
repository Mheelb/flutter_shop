import '../../../movies/domain/models/movie.dart';

class CartItem {
  final Movie movie;
  final double price;
  final DateTime addedAt;

  CartItem({
    required this.movie,
    required this.price,
    DateTime? addedAt,
  }) : addedAt = addedAt ?? DateTime.now();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItem &&
          runtimeType == other.runtimeType &&
          movie.id == other.movie.id;

  @override
  int get hashCode => movie.id.hashCode;
}

class Cart {
  final List<CartItem> items;

  Cart({this.items = const []});

  double get totalPrice => items.fold(0.0, (sum, item) => sum + item.price);
  
  int get itemCount => items.length;

  bool contains(Movie movie) => items.any((item) => item.movie.id == movie.id);

  Cart addItem(Movie movie, {double price = 4.99}) {
    if (contains(movie)) return this;
    
    final newItems = List<CartItem>.from(items)
      ..add(CartItem(movie: movie, price: price));
    
    return Cart(items: newItems);
  }

  Cart removeItem(Movie movie) {
    final newItems = items.where((item) => item.movie.id != movie.id).toList();
    return Cart(items: newItems);
  }

  Cart clear() {
    return Cart(items: []);
  }
}
