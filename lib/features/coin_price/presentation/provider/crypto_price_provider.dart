

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grpc_app/features/coin_price/domain/repository/crypto_repository.dart';
import 'package:grpc_app/features/coin_price/domain/service/crypto_service.dart';

import '../../../../core/network/dio_provider.dart';
import '../../data/data_source/Crypto_price_data_source.dart';
import '../../data/reposiotory/crypto_price_repository_impl.dart';


final cryptoPriceDataSourceProvider = Provider<CryptoPriceDataSource>((ref){
  final dio= ref.watch(dioProvider);
  return CryptoPriceDataSource(dio);
});


final cryptoPriceRepositoryProvider = Provider<ICryptoRepository>((ref){

  final dataSource= ref.watch(cryptoPriceDataSourceProvider);
  return CryptoPriceRepositoryImpl(dataSource);
});


final cryptoPriceServiceProvider = Provider<CryptoPriceService>((ref){

  final repository = ref.watch(cryptoPriceRepositoryProvider);

  return CryptoPriceService(repository);
});