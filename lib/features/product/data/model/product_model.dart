import 'package:grpc_app/features/product/domain/entity/product.dart';

class ProductModel extends Product {
  ProductModel({
    required super.id,
    required super.name,
    required super.price,
    required super.stockQuantity,
  });


  factory ProductModel.fromMap(Map<String, dynamic> map) {

    return ProductModel(
      id: map['id'] ?? map['_id'] ?? '',
      name: map['name'] ?? '',
      price: map['price'] ?? 0.0,
      stockQuantity: map['stockQuantity'] ?? 0
    );
  }
}
