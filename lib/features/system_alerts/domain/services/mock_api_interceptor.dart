import 'package:flutter_riverpod/flutter_riverpod.dart';

final apiInterceptorProvider = Provider<MockApiInterceptor>((ref) {
  return MockApiInterceptor();
});

class MockApiInterceptor {
  // We can attach a callback to this mock interceptor so it can notify the app state
  void Function()? onMaintenanceModeTriggered;

  // Simulate an API call failing with a 503 Maintenance error
  void simulate503Error() {
    if (onMaintenanceModeTriggered != null) {
      onMaintenanceModeTriggered!();
    }
  }
}
