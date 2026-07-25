import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grpc_app/core/storage/storage_provider.dart';
import 'package:grpc_app/features/auth/data/data_source/auth_data_source.dart';
import 'package:grpc_app/features/auth/data/data_source/auth_mock_data_source.dart';
import 'package:grpc_app/features/auth/data/repository/auth_repository_impl.dart';
import 'package:grpc_app/features/auth/domain/repository/auth_repository.dart';
import 'package:grpc_app/features/auth/domain/service/auth_service.dart';

final authDataSourceProvider = Provider<IAuthDataSource>((ref) {
  // Use mock data source based on requirements for dummy credentials
  return AuthMockDataSourceImpl();
});

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  return AuthRepositoryImpl(ref.watch(authDataSourceProvider));
});

final authServiceProvider = Provider<IAuthService>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  final storage = ref.watch(localStorageProvider);
  return AuthServiceImpl(repo, storage);
});
