import '../../domain/models/cart.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_remote_datasource.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remote;
  CartRepositoryImpl({CartRemoteDataSource? remote}) : remote = remote ?? CartRemoteDataSource();

  @override
  Future<Cart> createCart(int userId, List<CartItem> items) => remote.createCart(userId, items);

  @override
  Future<void> deleteCart(int cartId) => remote.deleteCart(cartId);

  @override
  Future<List<Cart>> fetchCarts() => remote.fetchCarts();

  @override
  Future<Cart> updateCart(int cartId, int userId, List<CartItem> items) =>
      remote.updateCart(cartId, userId, items);
}


