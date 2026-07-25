import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:grpc_app/core/config/env_config.dart';
import 'package:grpc_app/core/network/dio_provider.dart';


/// The provider that dictates which implementation is used
final networkServiceProvider = Provider<INetworkService>((ref) {
  final dio = ref.watch(dioProvider);
  // Switch to MockNetworkServiceImpl() for UI testing without a backend

  if(EnvConfig.useMock){
    return MockNetworkServiceImpl();
  }else{
    return RealNetworkServiceImpl(dio);
  }
});



/// The abstraction for network connectivity checks
abstract class INetworkService {
  Future<bool> hasConnection();
}

/// A real implementation that pings the health endpoint
class RealNetworkServiceImpl implements INetworkService {
  final Dio _dio;

  RealNetworkServiceImpl(this._dio);

  @override
  Future<bool> hasConnection() async {
    try {
      // Uses baseUrl from dioProvider (http://localhost:8000/api)
      final response = await _dio.get('/ping');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}

/// A mock implementation for testing
class MockNetworkServiceImpl implements INetworkService {
  bool _isConnected = false;

  @override
  Future<bool> hasConnection() async {
    await Future.delayed(const Duration(seconds: 10));
    return _isConnected;
  }

  void setConnected(bool isConnected) {
    _isConnected = isConnected;
  }
}
