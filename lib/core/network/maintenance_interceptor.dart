import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'dart:math';

final maintenanceInterceptorProvider = Provider<MaintenanceInterceptor>((ref) {
  return MaintenanceInterceptor();
});

class MaintenanceInterceptor extends Interceptor {
  // Callback to notify the global app state
  void Function()? onMaintenanceModeTriggered;
  
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // 50% chance to trigger maintenance for testing
    if (response.statusCode == 200 && Random().nextDouble() < 0.5) {
      if (onMaintenanceModeTriggered != null) {
        onMaintenanceModeTriggered!();
      }
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Standard maintenance mode is usually 503 Service Unavailable
    if (err.response?.statusCode == 503) {
      if (onMaintenanceModeTriggered != null) {
        onMaintenanceModeTriggered!();
      }
    }
    handler.next(err);
  }
}
