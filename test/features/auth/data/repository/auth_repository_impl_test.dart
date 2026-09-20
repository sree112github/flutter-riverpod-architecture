import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:grpc_app/features/auth/data/data_source/auth_data_source.dart';
import 'package:grpc_app/features/auth/data/model/auth_dto.dart';
import 'package:grpc_app/features/auth/data/repository/auth_repository_impl.dart';
import 'package:grpc_app/features/auth/domain/entity/auth_params.dart';
import 'package:grpc_app/features/auth/domain/entity/auth_token.dart';

// Create a Mock for the Dependency
class MockAuthDataSource extends Mock implements IAuthDataSource {}

// We need a Fake for LoginRequest since it's passed as an argument in the Mock
class FakeLoginRequest extends Fake implements LoginRequest {}

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthDataSource mockDataSource;

  setUpAll(() {
    // Register the fallback value for custom types used in any() matchers
    registerFallbackValue(FakeLoginRequest());
  });

  setUp(() {
    mockDataSource = MockAuthDataSource();
    repository = AuthRepositoryImpl(mockDataSource);
  });

  group('AuthRepositoryImpl Tests', () {
    final tLoginParams = LoginParams(email: 'test@example.com', password: 'password123');
    final tAuthResponse = AuthResponse(accessToken: 'mock_token_123', userId: 'user_456');

    test('login - should return AuthToken when the call to data source is successful', () async {
      // Arrange
      when(() => mockDataSource.login(any())).thenAnswer((_) async => tAuthResponse);

      // Act
      final result = await repository.login(tLoginParams);

      // Assert
      expect(result, isA<AuthToken>());
      expect(result.accessToken, equals('mock_token_123'));
      expect(result.userId, equals('user_456'));
      
      // Verify the correct request object was passed to the data source
      verify(() => mockDataSource.login(any(that: isA<LoginRequest>()))).called(1);
    });

    test('login - should throw an Exception when the call to data source fails', () async {
      // Arrange
      when(() => mockDataSource.login(any())).thenThrow(Exception('Failed to login'));

      // Act & Assert
      expect(() => repository.login(tLoginParams), throwsException);
      verify(() => mockDataSource.login(any())).called(1);
    });

    test('loginWithGoogle - should return AuthToken on success', () async {
      // Arrange
      when(() => mockDataSource.loginWithGoogle()).thenAnswer((_) async => tAuthResponse);

      // Act
      final result = await repository.loginWithGoogle();

      // Assert
      expect(result.accessToken, equals('mock_token_123'));
      verify(() => mockDataSource.loginWithGoogle()).called(1);
    });

    test('logout - should complete successfully when called', () async {
      // Arrange
      when(() => mockDataSource.logout()).thenAnswer((_) async => Future.value());

      // Act
      await repository.logout();

      // Assert
      verify(() => mockDataSource.logout()).called(1);
    });
  });
}
