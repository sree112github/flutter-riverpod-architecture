import 'package:grpc_app/features/coin_price/domain/entity/crypto_price.dart';
import 'package:grpc_app/features/coin_price/domain/repository/crypto_repository.dart';

class CryptoPriceService {
  final ICryptoRepository _repository;
  CryptoPriceService(this._repository);

  Future<CryptoPrice> getPrice(String symbol) async {
    return await _repository.getPrice(symbol);
  }
}
