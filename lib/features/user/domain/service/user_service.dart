import 'package:grpc_app/features/user/domain/entity/user.dart';
import 'package:grpc_app/features/user/domain/repository/user_repository.dart';

abstract interface class IUserService {
  Future<User> getMe();
}

class UserServiceImpl implements IUserService {
  final IUserRepository _repository;

  UserServiceImpl(this._repository);

  @override
  Future<User> getMe() async {
    return await _repository.getMe();
  }
}
