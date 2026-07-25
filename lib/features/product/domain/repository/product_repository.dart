

   import 'package:grpc_app/features/product/domain/entity/product.dart';
import 'package:grpc_app/features/product/domain/entity/product_params.dart';

abstract interface class IProductRepository {

  Future<Product>getProductById(String id);
  Future<List<Product>>getAllProducts();
  Future<Product>createProduct(CreateProductParams params);
  Future<Product>updateProduct(UpdateProductParams params);
  Future<void>deleteProduct(String id);
}
