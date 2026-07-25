import 'package:grpc_app/features/user/data/data_source/user_data_source.dart';
import 'package:grpc_app/features/user/domain/entity/user.dart';
import 'package:grpc_app/features/user/domain/repository/user_repository.dart';

class UserRepositoryImpl implements IUserRepository {
  final IUserDataSource _dataSource;

  UserRepositoryImpl(this._dataSource);

  @override
  Future<User> getMe() async {
    return await _dataSource.getMe();
  }
}
