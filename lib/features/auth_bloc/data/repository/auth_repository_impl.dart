import 'package:grpc_app/features/auth_bloc/data/data_source/auth_data_source.dart';
import 'package:grpc_app/features/auth_bloc/data/model/auth_dto.dart';
import 'package:grpc_app/features/auth_bloc/domain/entity/auth_params.dart';
import 'package:grpc_app/features/auth_bloc/domain/entity/auth_token.dart';
import 'package:grpc_app/features/auth_bloc/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final IAuthDataSource _dataSource;

  AuthRepositoryImpl(this._dataSource);

  @override
  Future<AuthToken> login(LoginParams params) async {
    final request = LoginRequest(
      email: params.email,
      password: params.password,
    );
    final response = await _dataSource.login(request);
    
    return AuthToken(
      accessToken: response.accessToken,
      userId: response.userId,
    );
  }

  @override
  Future<AuthToken> loginWithGoogle() async {
    final response = await _dataSource.loginWithGoogle();
    return AuthToken(
      accessToken: response.accessToken,
      userId: response.userId,
    );
  }

  @override
  Future<void> logout() async {
    await _dataSource.logout();
  }
}
