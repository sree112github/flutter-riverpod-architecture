import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:grpc_app/features/auth/domain/entity/auth_params.dart';
import 'package:grpc_app/features/auth/domain/entity/auth_token.dart';
import 'package:grpc_app/features/auth/domain/service/auth_service.dart';
import 'package:grpc_app/features/auth/presentation/controller/auth_controller.dart';
import 'package:grpc_app/features/auth/presentation/provider/auth_provider.dart';

class MockAuthService extends Mock implements IAuthService {}
class FakeLoginParams extends Fake implements LoginParams {}

void main() {
  late ProviderContainer container;
  late MockAuthService mockAuthService;

  setUpAll(() {
    registerFallbackValue(FakeLoginParams());
  });

  setUp(() {
    mockAuthService = MockAuthService();
    container = ProviderContainer(
      overrides: [
        authServiceProvider.overrideWithValue(mockAuthService),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('AuthController Tests', () {
    final tAuthToken = AuthToken(accessToken: 'token', userId: '123');

    test('initial state is derived from authService.isLoggedIn()', () async {
      // Arrange
      when(() => mockAuthService.isLoggedIn()).thenAnswer((_) async => true);

      // Act
      final state = await container.read(authControllerProvider.future);

      // Assert
      expect(state, isTrue);
      verify(() => mockAuthService.isLoggedIn()).called(1);
    });

    test('login successfully updates state to true', () async {
      // Arrange
      when(() => mockAuthService.isLoggedIn()).thenAnswer((_) async => false);
      when(() => mockAuthService.login(any())).thenAnswer((_) async => tAuthToken);

      // We need to wait for the build to finish first
      await container.read(authControllerProvider.future);

      // Act
      await container.read(authControllerProvider.notifier).login('test@test.com', 'pass');

      // Assert
      final finalState = container.read(authControllerProvider);
      expect(finalState.value, isTrue);
    });

    test('login failure throws and sets state to false', () async {
      // Arrange
      when(() => mockAuthService.isLoggedIn()).thenAnswer((_) async => false);
      when(() => mockAuthService.login(any())).thenThrow(Exception('Login failed'));

      await container.read(authControllerProvider.future);

      // Act & Assert
      expect(
        () => container.read(authControllerProvider.notifier).login('test@test.com', 'pass'),
        throwsException,
      );

      // Wait a microtask to let the catch block execute
      await Future.delayed(Duration.zero);
      final finalState = container.read(authControllerProvider);
      expect(finalState.value, isFalse);
    });
  });
}
