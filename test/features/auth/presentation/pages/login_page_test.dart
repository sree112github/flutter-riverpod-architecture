import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:grpc_app/core/router/app_state.dart';
import 'package:grpc_app/core/router/app_state_provider.dart';
import 'package:grpc_app/features/auth/domain/entity/auth_params.dart';
import 'package:grpc_app/features/auth/domain/entity/auth_token.dart';
import 'package:grpc_app/features/auth/domain/service/auth_service.dart';
import 'package:grpc_app/features/auth/presentation/pages/login_page.dart';
import 'package:grpc_app/features/auth/presentation/provider/auth_provider.dart';
import 'package:grpc_app/core/constants/app_keys.dart';

// Mock dependencies
class MockAuthService extends Mock implements IAuthService {}

class FakeLoginParams extends Fake implements LoginParams {}

// Dummy AppStateNotifier to avoid triggering the real initialization logic during UI tests
class DummyAppStateNotifier extends Notifier<AppState> implements AppStateNotifier {
  @override
  AppState build() => AppState.ready;
  
  @override
  Future<void> acceptTerms() async {}
  @override
  Future<void> clearPreferences() async {}
  @override
  Future<void> finishIntro() async {}
  @override
  Future<void> retryInitialization() async {}
}

void main() {
  late MockAuthService mockAuthService;

  setUpAll(() {
    registerFallbackValue(FakeLoginParams());
  });

  setUp(() {
    mockAuthService = MockAuthService();
  });

  Widget createTestWidget() {
    return ProviderScope(
      overrides: [
        authServiceProvider.overrideWithValue(mockAuthService),
        appStateProvider.overrideWith(() => DummyAppStateNotifier()),
      ],
      child: const MaterialApp(
        home: LoginPage(),
      ),
    );
  }

  testWidgets('renders login page with expected UI elements', (WidgetTester tester) async {
    // Arrange
    when(() => mockAuthService.isLoggedIn()).thenAnswer((_) async => false);

    // Act
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Login'), findsOneWidget);
    expect(find.byKey(AppKeys.emailField), findsOneWidget);
    expect(find.byKey(AppKeys.passwordField), findsOneWidget);
    expect(find.byKey(AppKeys.loginDirectBtn), findsOneWidget);
    expect(find.byKey(AppKeys.loginGoogleBtn), findsOneWidget);
  });

  testWidgets('shows validation errors when fields are empty', (WidgetTester tester) async {
    // Arrange
    when(() => mockAuthService.isLoggedIn()).thenAnswer((_) async => false);

    // Act
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    final loginButton = find.byKey(AppKeys.loginDirectBtn);
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Email cannot be empty'), findsOneWidget);
    expect(find.text('Password cannot be empty'), findsOneWidget);
    verifyNever(() => mockAuthService.login(any())); // Ensure login is not called
  });

  testWidgets('shows validation error for invalid email', (WidgetTester tester) async {
    // Arrange
    when(() => mockAuthService.isLoggedIn()).thenAnswer((_) async => false);

    // Act
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(AppKeys.emailField), 'invalidemail');
    await tester.enterText(find.byKey(AppKeys.passwordField), 'password123');

    final loginButton = find.byKey(AppKeys.loginDirectBtn);
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Please enter a valid email'), findsOneWidget);
    verifyNever(() => mockAuthService.login(any()));
  });

  testWidgets('tapping Direct Login button triggers login logic and shows success snackbar', (WidgetTester tester) async {
    // Arrange
    when(() => mockAuthService.isLoggedIn()).thenAnswer((_) async => false);
    when(() => mockAuthService.login(any())).thenAnswer(
      (_) async => AuthToken(accessToken: 'token', userId: '123'),
    );

    // Act
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(AppKeys.emailField), 'test@test.com');
    await tester.enterText(find.byKey(AppKeys.passwordField), 'password123');

    final loginButton = find.byKey(AppKeys.loginDirectBtn);
    await tester.tap(loginButton);
    
    // Settle the async calls
    await tester.pumpAndSettle();

    // Assert
    verify(() => mockAuthService.login(any())).called(1);
    expect(find.text('Login successful!'), findsOneWidget); // Snackbar text
  });

  testWidgets('shows CircularProgressIndicator while logging in', (WidgetTester tester) async {
    // Arrange
    when(() => mockAuthService.isLoggedIn()).thenAnswer((_) async => false);
    when(() => mockAuthService.login(any())).thenAnswer(
      (_) async {
        await Future.delayed(const Duration(seconds: 1));
        return AuthToken(accessToken: 'token', userId: '123');
      },
    );

    // Act
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(AppKeys.emailField), 'test@test.com');
    await tester.enterText(find.byKey(AppKeys.passwordField), 'password123');

    final loginButton = find.byKey(AppKeys.loginDirectBtn);
    await tester.tap(loginButton);
    
    // Pump once to trigger the loading state (before the 1 second delay finishes)
    await tester.pump(); 

    // Assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Direct Login'), findsNothing); // Text is hidden when loading

    // Finish the async call
    await tester.pumpAndSettle();
  });

  testWidgets('failed login shows error snackbar', (WidgetTester tester) async {
    // Arrange
    when(() => mockAuthService.isLoggedIn()).thenAnswer((_) async => false);
    when(() => mockAuthService.login(any())).thenThrow(Exception('Invalid credentials'));

    // Act
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(AppKeys.emailField), 'test@test.com');
    await tester.enterText(find.byKey(AppKeys.passwordField), 'password123');

    final loginButton = find.byKey(AppKeys.loginDirectBtn);
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    // Assert
    verify(() => mockAuthService.login(any())).called(1);
    expect(find.text('Invalid credentials'), findsOneWidget); // Snackbar error text
  });
}
