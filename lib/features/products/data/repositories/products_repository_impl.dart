import '../../domain/models/product.dart';
import '../../domain/repositories/products_repository.dart';
import '../datasources/products_remote_datasource.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final ProductsRemoteDataSource remoteDataSource;

  ProductsRepositoryImpl({ProductsRemoteDataSource? remoteDataSource})
      : remoteDataSource = remoteDataSource ?? ProductsRemoteDataSource();

  @override
  Future<List<Product>> fetchAllProducts() {
    return remoteDataSource.fetchAllProducts();
  }

  @override
  Future<Product> fetchProduct(int id) {
    return remoteDataSource.fetchProduct(id);
  }
}
