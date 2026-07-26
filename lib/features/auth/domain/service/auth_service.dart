import 'package:grpc_app/core/storage/local_storage.dart';
import 'package:grpc_app/core/storage/storage_keys.dart';
import 'package:grpc_app/features/auth/domain/entity/auth_params.dart';
import 'package:grpc_app/features/auth/domain/entity/auth_token.dart';
import 'package:grpc_app/features/auth/domain/repository/auth_repository.dart';

abstract interface class IAuthService {
  Future<AuthToken> login(LoginParams params);
  Future<AuthToken> loginWithGoogle();
  Future<void> logout();
  Future<bool> isLoggedIn();
}

class AuthServiceImpl implements IAuthService {
  final IAuthRepository _repository;
  final ILocalStorage _localStorage;

  AuthServiceImpl(this._repository, this._localStorage);

  @override
  Future<AuthToken> login(LoginParams params) async {
    final token = await _repository.login(params);
    // Automatically persist the token upon successful login
    await _localStorage.saveString(StorageKeys.accessToken, token.accessToken);
    return token;
  }

  @override
  Future<AuthToken> loginWithGoogle() async {
    final token = await _repository.loginWithGoogle();
    await _localStorage.saveString(StorageKeys.accessToken, token.accessToken);
    return token;
  }

  @override
  Future<void> logout() async {
    await _repository.logout();
    await _localStorage.delete(StorageKeys.accessToken);
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = await _localStorage.getString(StorageKeys.accessToken);
    return token != null && token.isNotEmpty;
  }
}
