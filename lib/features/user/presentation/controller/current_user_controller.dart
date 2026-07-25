import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grpc_app/features/auth/presentation/controller/auth_controller.dart';
import 'package:grpc_app/features/user/domain/entity/user.dart';
import 'package:grpc_app/features/user/presentation/provider/user_provider.dart';


final currentUserControllerProvider = AsyncNotifierProvider<CurrentUserController, User?>(
  () => CurrentUserController(),
);

class CurrentUserController extends AsyncNotifier<User?> {
  @override
  Future<User?> build() async {
    // 1. Watch the authentication state
    final isLoggedIn = ref.watch(authControllerProvider).value ?? false;

    // 2. If logged in, fetch the user profile
    if (isLoggedIn) {
      final userService = ref.read(userServiceProvider);
      return await userService.getMe();
    }

    // 3. If logged out, return null
    return null;
  }
}
