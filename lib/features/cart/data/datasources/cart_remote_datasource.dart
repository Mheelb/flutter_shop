import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../domain/models/cart.dart';

class CartRemoteDataSource {
  final http.Client httpClient;
  final String baseUrl;

  CartRemoteDataSource({http.Client? httpClient, this.baseUrl = 'https://fakestoreapi.com'})
      : httpClient = httpClient ?? http.Client();

  Future<List<Cart>> fetchCarts() async {
    final uri = Uri.parse('$baseUrl/carts');
    final res = await httpClient.get(uri);
    if (res.statusCode != 200) throw Exception('Failed to fetch carts (${res.statusCode})');
    final List<dynamic> list = json.decode(res.body) as List<dynamic>;
    return list.map((e) => Cart.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Cart> createCart(int userId, List<CartItem> items) async {
    final uri = Uri.parse('$baseUrl/carts');
    final body = json.encode({
      'userId': userId,
      'products': items
          .map((e) => {
                'productId': e.productId,
                'quantity': e.quantity,
              })
          .toList(),
    });
    final res = await httpClient.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception('Failed to create cart (${res.statusCode})');
    }
    return Cart.fromJson(json.decode(res.body) as Map<String, dynamic>);
  }

  Future<Cart> updateCart(int cartId, int userId, List<CartItem> items) async {
    final uri = Uri.parse('$baseUrl/carts/$cartId');
    final body = json.encode({
      'userId': userId,
      'products': items
          .map((e) => {
                'productId': e.productId,
                'quantity': e.quantity,
              })
          .toList(),
    });
    final res = await httpClient.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    if (res.statusCode != 200) throw Exception('Failed to update cart (${res.statusCode})');
    return Cart.fromJson(json.decode(res.body) as Map<String, dynamic>);
  }

  Future<void> deleteCart(int cartId) async {
    final uri = Uri.parse('$baseUrl/carts/$cartId');
    final res = await httpClient.delete(uri);
    if (res.statusCode != 200) throw Exception('Failed to delete cart (${res.statusCode})');
  }
}


