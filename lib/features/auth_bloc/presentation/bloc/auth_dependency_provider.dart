import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grpc_app/core/storage/storage_provider.dart';
import 'package:grpc_app/features/auth_bloc/data/data_source/auth_data_source.dart';
import 'package:grpc_app/features/auth_bloc/data/data_source/auth_mock_data_source.dart';
import 'package:grpc_app/features/auth_bloc/data/repository/auth_repository_impl.dart';
import 'package:grpc_app/features/auth_bloc/domain/repository/auth_repository.dart';
import 'package:grpc_app/features/auth_bloc/domain/service/auth_service.dart';
import 'package:grpc_app/features/auth_bloc/presentation/bloc/auth_bloc.dart';
import 'package:grpc_app/features/auth_bloc/presentation/bloc/auth_event.dart';

final authBlocDataSourceProvider = Provider<IAuthDataSource>((ref) {
  return AuthMockDataSourceImpl();
});

final authBlocRepositoryProvider = Provider<IAuthRepository>((ref) {
  return AuthRepositoryImpl(ref.watch(authBlocDataSourceProvider));
});

final authBlocServiceProvider = Provider<IAuthService>((ref) {
  final repo = ref.watch(authBlocRepositoryProvider);
  final storage = ref.watch(localStorageProvider);
  return AuthServiceImpl(repo, storage);
});

final authBlocProvider = Provider<AuthBloc>((ref) {
  final service = ref.watch(authBlocServiceProvider);
  final bloc = AuthBloc(authService: service);
  bloc.add(AuthCheckStatusRequested());
  
  ref.onDispose(() => bloc.close());
  return bloc;
});
