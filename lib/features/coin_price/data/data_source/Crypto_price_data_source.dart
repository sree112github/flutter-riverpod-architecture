

  import 'package:dio/dio.dart';
import 'package:grpc_app/features/coin_price/data/model/crypto_price_model.dart';


  class CryptoPriceDataSource {
    final Dio _dio;

    CryptoPriceDataSource(this._dio);

    Future<CryptoPriceModel> getPrice(String symbol) async {
      try {
        final response = await _dio.get(
          '/ticker/price',
          queryParameters: {
            'symbol': symbol,
          },
        );

        return CryptoPriceModel.fromJson(response.data);
      } on DioException catch (e) {
        if (e.response?.statusCode == 404) {
          throw Exception('Crypto not found');
        }

        throw Exception(
          e.response?.data.toString() ?? e.message ?? 'Network error',
        );
      }
      catch(e){
        throw Exception(e.toString());
      }
    }
  }