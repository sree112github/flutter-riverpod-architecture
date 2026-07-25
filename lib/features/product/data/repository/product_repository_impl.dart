import 'package:grpc_app/features/product/data/data_source/product_data_source.dart';
import 'package:grpc_app/features/product/data/model/product_dto.dart';
import 'package:grpc_app/features/product/domain/entity/product.dart';
import 'package:grpc_app/features/product/domain/entity/product_params.dart';
import 'package:grpc_app/features/product/domain/repository/product_repository.dart';

class ProductRepositoryImpl implements IProductRepository {
  final IProductDataSource _dataSource;

  ProductRepositoryImpl(this._dataSource);

  @override
  Future<Product> createProduct(CreateProductParams params) async {
    final product = CreateProductRequest(
      name: params.name,
      price: params.price,
      stockQuantity: params.stockQuantity,
    );
    final productModel = await _dataSource.createProduct(product);
    return productModel;
  }

  @override
  Future<void> deleteProduct(String id) async{
    await _dataSource.deleteProduct(id);
  }

  @override
  Future<List<Product>> getAllProducts() async{
    final productModels = await _dataSource.getAllProducts();
    return productModels.map((model) => model).toList();
  }

  @override
  Future<Product> getProductById(String id) async{
    final productModel = await _dataSource.getProductById(id);
    return productModel;
  }

  @override
  Future<Product> updateProduct(UpdateProductParams params) async{
    final product = UpdateProductRequest(
      id: params.id,
      name: params.name,
      price: params.price,
      stockQuantity: params.stockQuantity,
    );
    final productModel = await _dataSource.updateProduct(product);
    return productModel;
  }
}
