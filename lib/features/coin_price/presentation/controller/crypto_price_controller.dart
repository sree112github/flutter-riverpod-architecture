


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grpc_app/features/coin_price/domain/entity/crypto_price.dart';
import 'package:grpc_app/features/coin_price/presentation/provider/crypto_price_provider.dart';


final cryptoPriceControllerProvider = AsyncNotifierProvider<CryptoPriceController,CryptoPrice>(
    ()=>CryptoPriceController()
);
class CryptoPriceController extends AsyncNotifier<CryptoPrice>{

  @override
 Future<CryptoPrice> build() async{
    return await _fetchPrice();
  }

  Future<CryptoPrice>_fetchPrice()async{

    final service = ref.read(cryptoPriceServiceProvider);

    final res = await service.getPrice("BTCUSDT");

    return res;

  }

  Future<void> refreshPage()async{

    state = const AsyncValue.loading();

    state = await AsyncValue.guard(()=> _fetchPrice());

  }

}