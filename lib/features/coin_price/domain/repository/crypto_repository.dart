
import 'package:grpc_app/features/coin_price/domain/entity/crypto_price.dart';

abstract interface class ICryptoRepository{

  Future<CryptoPrice>getPrice(String symbol);
}