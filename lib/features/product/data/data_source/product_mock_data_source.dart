

import 'package:grpc_app/features/product/data/data_source/product_data_source.dart';
import 'package:grpc_app/features/product/data/model/product_dto.dart';
import 'package:grpc_app/features/product/data/model/product_model.dart';

import '../../domain/entity/product.dart';

class ProductMockDataSourceImpl implements IProductDataSource {
  @override
  Future<ProductModel> createProduct(CreateProductRequest data) async{
    await Future.delayed(const Duration(milliseconds: 500));

    return ProductModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: data.name,
      price: data.price,
      stockQuantity: data.stockQuantity,
    );

  }

  @override
  Future<void> deleteProduct(String id) async{
    await Future.delayed(const Duration(milliseconds: 500));

  }

  @override
  Future<List<ProductModel>> getAllProducts() async{
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      ProductModel(id: '1', name: 'Product 1', price: 10.99, stockQuantity: 10),
      ProductModel(id: '2', name: 'Product 2', price: 19.99, stockQuantity: 5),
    ];

  }

  @override
  Future<ProductModel> getProductById(String id) async{
    await Future.delayed(const Duration(milliseconds: 500));
    return ProductModel(id: '1', name: 'Product 1', price: 10.99, stockQuantity: 10);
  }

  @override
  Future<ProductModel> updateProduct(UpdateProductRequest data) async{
    await Future.delayed(const Duration(milliseconds: 500));
    return ProductModel(
      id: data.id,
      name: data.name ?? '',
      price: data.price ?? 0.0,
      stockQuantity: data.stockQuantity ?? 0,);


  }

}