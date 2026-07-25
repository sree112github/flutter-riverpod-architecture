import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grpc_app/features/user/data/data_source/user_data_source.dart';
import 'package:grpc_app/features/user/data/data_source/user_mock_data_source.dart';
import 'package:grpc_app/features/user/data/repository/user_repository_impl.dart';
import 'package:grpc_app/features/user/domain/repository/user_repository.dart';
import 'package:grpc_app/features/user/domain/service/user_service.dart';

final userDataSourceProvider = Provider<IUserDataSource>((ref) {
  return UserMockDataSourceImpl();
});

final userRepositoryProvider = Provider<IUserRepository>((ref) {
  return UserRepositoryImpl(ref.watch(userDataSourceProvider));
});

final userServiceProvider = Provider<IUserService>((ref) {
  return UserServiceImpl(ref.watch(userRepositoryProvider));
});
