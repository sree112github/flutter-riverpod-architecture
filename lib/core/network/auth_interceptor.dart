import 'package:dio/dio.dart';
import 'package:grpc_app/core/storage/local_storage.dart';
import 'package:grpc_app/core/storage/storage_keys.dart';

class AuthInterceptor extends Interceptor {
  final ILocalStorage _localStorage;

  AuthInterceptor(this._localStorage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // --- REAL FIREBASE IMPLEMENTATION (Uncomment when Firebase is installed) ---
    // final user = FirebaseAuth.instance.currentUser;
    // final token = await user?.getIdToken(); 
    // --------------------------------------------------------------------------

    // --- MOCK IMPLEMENTATION (Delete when using Firebase) ---
    final token = await _localStorage.getString(StorageKeys.accessToken);
    // --------------------------------------------------------
    
    // If a token exists, inject it into the Authorization header
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    
    // Continue with the request
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Optional: Handle 401 Unauthorized globally here to force logout if token expires
    if (err.response?.statusCode == 401) {
      // You could trigger a global state reset here
    }
    handler.next(err);
  }
}
