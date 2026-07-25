import 'package:dio/dio.dart';

class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;
  final Duration retryDelay;

  RetryInterceptor({
    required this.dio,
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 2),
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Determine if we should retry
    bool shouldRetry = _shouldRetry(err);
    
    // Get current retry count from the request headers/extra, default to 0
    int retryCount = err.requestOptions.extra['retryCount'] ?? 0;

    if (shouldRetry && retryCount < maxRetries) {
      retryCount++;
      err.requestOptions.extra['retryCount'] = retryCount;

      // Wait before retrying
      await Future.delayed(retryDelay);

      try {
        // Create a new request based on the failed one
        final response = await dio.request(
          err.requestOptions.path,
          options: Options(
            method: err.requestOptions.method,
            headers: err.requestOptions.headers,
          ),
          data: err.requestOptions.data,
          queryParameters: err.requestOptions.queryParameters,
        );
        return handler.resolve(response);
      } catch (e) {
        if (e is DioException) {
          handler.next(e);
        } else {
          handler.reject(DioException(requestOptions: err.requestOptions, error: e));
        }
      }
    }
    
    // If we exceed max retries or shouldn't retry, pass the error forward to stop
    handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    // DO NOT retry 404 (Not Found), 400 (Bad Request), 401 (Unauthorized), 403 (Forbidden)
    if (err.type == DioExceptionType.badResponse) {
      final statusCode = err.response?.statusCode;
      if (statusCode != null && statusCode >= 400 && statusCode < 500) {
        // It's a client error, retrying won't help (e.g. 404 Not Found)
        return false; 
      }
    }
    
    // Retry on timeouts, 500 server errors, or connection errors
    return err.type == DioExceptionType.connectionTimeout ||
           err.type == DioExceptionType.sendTimeout ||
           err.type == DioExceptionType.receiveTimeout ||
           err.type == DioExceptionType.connectionError ||
           (err.response != null && err.response!.statusCode! >= 500);
  }
}
