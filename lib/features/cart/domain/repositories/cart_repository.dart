import '../models/cart.dart';

abstract class CartRepository {
  Future<List<Cart>> fetchCarts();
  Future<Cart> createCart(int userId, List<CartItem> items);
  Future<Cart> updateCart(int cartId, int userId, List<CartItem> items);
  Future<void> deleteCart(int cartId);
}


