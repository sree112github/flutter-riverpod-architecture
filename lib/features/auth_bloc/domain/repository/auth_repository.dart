import 'package:grpc_app/features/auth_bloc/domain/entity/auth_token.dart';
import 'package:grpc_app/features/auth_bloc/domain/entity/auth_params.dart';

abstract class IAuthRepository {
  Future<AuthToken> login(LoginParams params);
  Future<AuthToken> loginWithGoogle();
  Future<void> logout();
}
