import 'package:grpc_app/features/user/domain/entity/user.dart';

abstract interface class IUserDataSource {
  Future<User> getMe();
}
