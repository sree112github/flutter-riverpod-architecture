import 'package:grpc_app/features/product/domain/entity/product.dart';
import 'package:grpc_app/features/product/domain/entity/product_params.dart';
import 'package:grpc_app/features/product/domain/repository/product_repository.dart';

abstract interface class IProductService {

  Future<Product>getProductById(String id);
  Future<List<Product>>getAllProducts();
  Future<Product>createProduct(CreateProductParams params);
  Future<Product>updateProduct(UpdateProductParams params);
  Future<void>deleteProduct(String id);
}


class ProductServiceImpl implements IProductService {
  final IProductRepository _repository;
  ProductServiceImpl(this._repository);

  @override
  Future<Product> createProduct(CreateProductParams params) async{
    // Business logic orchestration can happen here before delegating to repository
    return await _repository.createProduct(params);

  }

  @override
  Future<void> deleteProduct(String id) async{
    await _repository.deleteProduct(id);

  }

  @override
  Future<List<Product>> getAllProducts() async{
    return await _repository.getAllProducts();
  }

  @override
  Future<Product> getProductById(String id) async{
    return await _repository.getProductById(id);

  }

  @override
  Future<Product> updateProduct(UpdateProductParams params) async{
    return await _repository.updateProduct(params);
  }


}