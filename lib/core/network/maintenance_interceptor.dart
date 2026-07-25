import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

final maintenanceInterceptorProvider = Provider<MaintenanceInterceptor>((ref) {
  return MaintenanceInterceptor();
});

class MaintenanceInterceptor extends Interceptor {
  // Callback to notify the global app state
  void Function()? onMaintenanceModeTriggered;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 503) {
      if (onMaintenanceModeTriggered != null) {
        onMaintenanceModeTriggered!();
      }
    }
    handler.next(err);
  }
}
