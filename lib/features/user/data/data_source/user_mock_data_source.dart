import 'package:grpc_app/features/user/data/data_source/user_data_source.dart';
import 'package:grpc_app/features/user/domain/entity/user.dart';

class UserMockDataSourceImpl implements IUserDataSource {
  @override
  Future<User> getMe() async {
    await Future.delayed(const Duration(milliseconds: 800)); // Simulate network
    return User(
      id: 'mock_user_id_001',
      name: 'John Doe',
      email: 'test@test.com',
    );
  }
}
