import '../models/product.dart';

abstract class ProductsRepository {
  Future<List<Product>> fetchAllProducts();
}



