

import 'package:dio/dio.dart';
import 'package:grpc_app/features/product/data/model/product_dto.dart';
import 'package:grpc_app/features/product/data/model/product_model.dart';


abstract class IProductDataSource {
  Future<List<ProductModel>>getAllProducts();
  Future<ProductModel>getProductById(String id);
  Future<ProductModel>createProduct(CreateProductRequest data);
  Future<ProductModel>updateProduct(UpdateProductRequest data);
  Future<void>deleteProduct(String id);
}

class ProductDataSourceImpl implements IProductDataSource {
  final Dio _dio;
  ProductDataSourceImpl(this._dio);


  @override
  Future<List<ProductModel>>getAllProducts() async{
    final response = await _dio.get("/getAllProduct");

    return response.data.map<ProductModel>((e) => ProductModel.fromMap(e)).toList();
  }

  @override
  Future<ProductModel>getProductById(String id) async{
    final response = await _dio.get("/getProductById/$id");
    return ProductModel.fromMap(response.data);
  }

  @override
  Future<ProductModel>createProduct(CreateProductRequest data) async{
    final response = await _dio.post("/createProduct", data: data);
    return ProductModel.fromMap(response.data);
  }

  @override
  Future<ProductModel>updateProduct(UpdateProductRequest data) async{
    final response = await _dio.put("/updateProduct/${data.id}", data: data);
    return ProductModel.fromMap(response.data);
  }

  @override
  Future<void>deleteProduct(String id) async{
    await _dio.delete("/deleteProduct/$id");
  }
}

