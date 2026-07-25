import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:grpc_app/features/coin_price/domain/repository/crypto_repository.dart';
import 'package:grpc_app/features/coin_price/domain/service/crypto_service.dart';
import 'package:grpc_app/features/coin_price/domain/entity/crypto_price.dart';

class MockCryptoRepository extends Mock implements ICryptoRepository {}

void main() {
  late CryptoPriceService cryptoService;
  late MockCryptoRepository cryptoRepository;

  setUp(() {
    cryptoRepository = MockCryptoRepository();
    cryptoService = CryptoPriceService(cryptoRepository);
  });

  //Group our tests

  group('Crypto_price_sevice_test', () {
    test('should return fakePrice when getPrice is called', () async {
      final fakePrice = CryptoPrice(symbol: 'BTC', price: '3000.0');

      when(() => cryptoRepository.getPrice("BTC")).thenAnswer((_) async {
        return fakePrice;
      });

      final result = await cryptoService.getPrice("BTC");

      expect(result, fakePrice);
      expect(result.symbol, "BTC");

      verify(() => cryptoRepository.getPrice("BTC")).called(1);
    });

    test('should throw an exception when repository throws an exception', () async {
      // Arrange
      when(() => cryptoRepository.getPrice("BTC")).thenThrow(Exception('Failed to get price'));

      // Act
      final call = cryptoService.getPrice;

      // Assert
      expect(() => call("BTC"), throwsException);
      verify(() => cryptoRepository.getPrice("BTC")).called(1);
    });
  });
}
