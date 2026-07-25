import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grpc_app/core/config/env_config.dart';
import 'package:grpc_app/core/network/dio_provider.dart';
import 'package:grpc_app/features/product/data/data_source/product_data_source.dart';
import 'package:grpc_app/features/product/data/data_source/product_mock_data_source.dart';
import 'package:grpc_app/features/product/data/repository/product_repository_impl.dart';
import 'package:grpc_app/features/product/domain/repository/product_repository.dart';
import 'package:grpc_app/features/product/domain/service/product_service.dart';


final productDataSourceProvider = Provider<IProductDataSource>(
  (ref){

    if(EnvConfig.useMock) {
      return ProductMockDataSourceImpl();
    }else{
      return ProductDataSourceImpl(ref.read(dioProvider));
    }
  }
  ,
);


final productRepositoryProvider = Provider<IProductRepository>((ref){
  return ProductRepositoryImpl(ref.read(productDataSourceProvider));
});


final productServiceProvider = Provider<IProductService>((ref){
  return ProductServiceImpl(ref.read(productRepositoryProvider));
});


