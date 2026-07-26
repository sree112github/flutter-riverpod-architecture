import 'package:grpc_app/features/auth_bloc/data/model/auth_dto.dart';

abstract interface class IAuthDataSource {
  Future<AuthResponse> login(LoginRequest request);
  Future<AuthResponse> loginWithGoogle();
  Future<void> logout();
}
