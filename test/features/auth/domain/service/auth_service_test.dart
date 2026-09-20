import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:grpc_app/core/storage/local_storage.dart';
import 'package:grpc_app/core/storage/storage_keys.dart';
import 'package:grpc_app/features/auth/domain/entity/auth_params.dart';
import 'package:grpc_app/features/auth/domain/entity/auth_token.dart';
import 'package:grpc_app/features/auth/domain/repository/auth_repository.dart';
import 'package:grpc_app/features/auth/domain/service/auth_service.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}
class MockLocalStorage extends Mock implements ILocalStorage {}
class FakeLoginParams extends Fake implements LoginParams {}

void main() {
  late AuthServiceImpl authService;
  late MockAuthRepository mockRepository;
  late MockLocalStorage mockLocalStorage;

  setUpAll(() {
    registerFallbackValue(FakeLoginParams());
  });

  setUp(() {
    mockRepository = MockAuthRepository();
    mockLocalStorage = MockLocalStorage();
    authService = AuthServiceImpl(mockRepository, mockLocalStorage);
  });

  group('AuthServiceImpl Tests', () {
    final tLoginParams = LoginParams(email: 'test@example.com', password: 'password123');
    final tAuthToken = AuthToken(accessToken: 'mock_token', userId: '123');

    test('login - should return AuthToken and save token to local storage on success', () async {
      // Arrange
      when(() => mockRepository.login(any())).thenAnswer((_) async => tAuthToken);
      when(() => mockLocalStorage.saveString(any(), any())).thenAnswer((_) async => Future.value());

      // Act
      final result = await authService.login(tLoginParams);

      // Assert
      expect(result, equals(tAuthToken));
      verify(() => mockRepository.login(tLoginParams)).called(1);
      verify(() => mockLocalStorage.saveString(StorageKeys.accessToken, 'mock_token')).called(1);
    });

    test('loginWithGoogle - should return AuthToken and save token on success', () async {
      // Arrange
      when(() => mockRepository.loginWithGoogle()).thenAnswer((_) async => tAuthToken);
      when(() => mockLocalStorage.saveString(any(), any())).thenAnswer((_) async => Future.value());

      // Act
      final result = await authService.loginWithGoogle();

      // Assert
      expect(result, equals(tAuthToken));
      verify(() => mockRepository.loginWithGoogle()).called(1);
      verify(() => mockLocalStorage.saveString(StorageKeys.accessToken, 'mock_token')).called(1);
    });

    test('logout - should call repository logout and delete token from storage', () async {
      // Arrange
      when(() => mockRepository.logout()).thenAnswer((_) async => Future.value());
      when(() => mockLocalStorage.delete(any())).thenAnswer((_) async => Future.value());

      // Act
      await authService.logout();

      // Assert
      verify(() => mockRepository.logout()).called(1);
      verify(() => mockLocalStorage.delete(StorageKeys.accessToken)).called(1);
    });

    test('isLoggedIn - should return true if token exists and is not empty', () async {
      // Arrange
      when(() => mockLocalStorage.getString(StorageKeys.accessToken)).thenAnswer((_) async => 'valid_token');

      // Act
      final result = await authService.isLoggedIn();

      // Assert
      expect(result, isTrue);
      verify(() => mockLocalStorage.getString(StorageKeys.accessToken)).called(1);
    });

    test('isLoggedIn - should return false if token does not exist', () async {
      // Arrange
      when(() => mockLocalStorage.getString(StorageKeys.accessToken)).thenAnswer((_) async => null);

      // Act
      final result = await authService.isLoggedIn();

      // Assert
      expect(result, isFalse);
    });

    test('isLoggedIn - should return false if token is empty', () async {
      // Arrange
      when(() => mockLocalStorage.getString(StorageKeys.accessToken)).thenAnswer((_) async => '');

      // Act
      final result = await authService.isLoggedIn();

      // Assert
      expect(result, isFalse);
    });
  });
}
