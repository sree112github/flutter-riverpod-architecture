import 'package:grpc_app/features/coin_price/domain/entity/crypto_price.dart';

class CryptoPriceModel extends CryptoPrice {
  CryptoPriceModel({required super.symbol, required super.price});

  factory CryptoPriceModel.fromJson(Map<String, dynamic> json) {
    return CryptoPriceModel(symbol: json['symbol'], price: json['price']);
  }
}
