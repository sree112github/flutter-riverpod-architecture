import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grpc_app/features/auth/domain/entity/auth_params.dart';
import 'package:grpc_app/features/auth/presentation/provider/auth_provider.dart';

final authControllerProvider = AsyncNotifierProvider<AuthController, bool>(
  () => AuthController(),
);

class AuthController extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    final service = ref.read(authServiceProvider);
    return await service.isLoggedIn();
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final service = ref.read(authServiceProvider);
      await service.login(LoginParams(email: email, password: password));
      state = const AsyncValue.data(true);
    } catch (e) {
      // Don't set error state globally here to avoid routing glitches.
      // The UI will handle displaying the error via rethrow.
      state = const AsyncValue.data(false);
      rethrow;
    }
  }

  Future<void> loginWithGoogle() async {
    state = const AsyncValue.loading();
    try {
      final service = ref.read(authServiceProvider);
      await service.loginWithGoogle();
      state = const AsyncValue.data(true);
    } catch (e) {
      state = const AsyncValue.data(false);
      rethrow;
    }
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    try {
      final service = ref.read(authServiceProvider);
      await service.logout();
      state = const AsyncValue.data(false);
    } catch (e) {
      // Ignore errors on logout or handle silently
      state = const AsyncValue.data(false);
    }
  }
}
