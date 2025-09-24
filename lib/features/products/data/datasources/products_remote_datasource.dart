import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../domain/models/product.dart';

class ProductsRemoteDataSource {
  final http.Client httpClient;

  ProductsRemoteDataSource({http.Client? httpClient})
      : httpClient = httpClient ?? http.Client();

  Future<List<Product>> fetchAllProducts() async {
    final uri = Uri.parse('https://fakestoreapi.com/products');
    final response = await httpClient.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load products (${response.statusCode})');
    }

    final List<dynamic> decoded = json.decode(response.body) as List<dynamic>;
    return decoded.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Product> fetchProduct(int id) async {
    final uri = Uri.parse('https://fakestoreapi.com/products/$id');
    final response = await httpClient.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load product $id (${response.statusCode})');
    }

    final Map<String, dynamic> decoded = json.decode(response.body) as Map<String, dynamic>;
    return Product.fromJson(decoded);
  }
}


