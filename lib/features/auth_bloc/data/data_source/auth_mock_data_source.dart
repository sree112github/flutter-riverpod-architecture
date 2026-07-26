import 'package:grpc_app/features/auth_bloc/data/data_source/auth_data_source.dart';
import 'package:grpc_app/features/auth_bloc/data/model/auth_dto.dart';

class AuthMockDataSourceImpl implements IAuthDataSource {
  @override
  Future<AuthResponse> login(LoginRequest request) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network
    if (request.email == 'test@test.com' && request.password == 'password123') {
      return AuthResponse(
        accessToken: 'mock_jwt_access_token_abc123',
        userId: 'mock_user_id_001',
      );
    } else {
      throw Exception('Invalid credentials');
    }
  }

  @override
  Future<AuthResponse> loginWithGoogle() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate Firebase delay
    return AuthResponse(
      accessToken: 'mock_google_jwt_access_token_789',
      userId: 'mock_google_user_id_002',
    );
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
