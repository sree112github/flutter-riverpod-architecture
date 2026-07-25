

 import 'package:grpc_app/features/coin_price/domain/entity/crypto_price.dart';
import 'package:grpc_app/features/coin_price/domain/repository/crypto_repository.dart';

import '../data_source/Crypto_price_data_source.dart';

class CryptoPriceRepositoryImpl implements ICryptoRepository{
  final CryptoPriceDataSource _dataSource;

  CryptoPriceRepositoryImpl(this._dataSource);


  @override
  Future<CryptoPrice> getPrice(String symbol) async{
   final res= await _dataSource.getPrice(symbol);
   return res;
  }

 }