import 'package:grpc_app/features/user/domain/entity/user.dart';

abstract interface class IUserRepository {
  Future<User> getMe();
}
