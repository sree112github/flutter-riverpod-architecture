import 'package:dio/dio.dart';
import 'package:grpc_app/core/error/exceptions.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 1. Handle No Internet / Timeouts
    if (err.type == DioExceptionType.connectionTimeout || 
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.connectionError) {
      
      return handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: NetworkException(message: 'No internet connection or request timed out.'),
        ),
      );
    }

    // 2. Handle HTTP Status Codes (e.g., 400, 401, 500)
    if (err.type == DioExceptionType.badResponse) {
      final statusCode = err.response?.statusCode;
      final data = err.response?.data;
      
      String errorMessage = 'An unexpected server error occurred.';

      // Extract specific backend error message if your API sends one
      if (data != null && data is Map<String, dynamic> && data.containsKey('message')) {
        errorMessage = data['message'];
      }

      if (statusCode == 401) {
        // You can intercept 401s here to trigger a global logout event or refresh tokens.
        errorMessage = 'Your session has expired. Please log in again.';
      } else if (statusCode == 500) {
        errorMessage = 'Internal server error. Please try again later.';
      }

      return handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: ServerException(message: errorMessage, statusCode: statusCode),
        ),
      );
    }

    // 3. Fallback for any other Dio errors
    return handler.next(err);
  }
}
