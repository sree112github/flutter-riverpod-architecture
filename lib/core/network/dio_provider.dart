import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:grpc_app/core/network/auth_interceptor.dart';
import 'package:grpc_app/core/network/maintenance_interceptor.dart';
import 'package:grpc_app/core/storage/storage_provider.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://keam-helper-project.onrender.com',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json',}
    ),
  );

  final localStorage = ref.read(localStorageProvider);
  dio.interceptors.add(AuthInterceptor(localStorage));
  dio.interceptors.add(ref.read(maintenanceInterceptorProvider));
  dio.interceptors.add(LogInterceptor(requestUrl: true,requestBody: true,responseBody: true, responseHeader: false, error: true));
  
  return dio;
});
