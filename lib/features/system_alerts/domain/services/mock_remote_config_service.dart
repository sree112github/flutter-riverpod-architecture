import 'package:flutter_riverpod/flutter_riverpod.dart';

final remoteConfigServiceProvider = Provider<MockRemoteConfigService>((ref) {
  return MockRemoteConfigService();
});

class MockRemoteConfigService {
  bool _needsForceUpdate = false;

  Future<bool> needsForceUpdate() async {
    // Simulate remote config fetch delay
    await Future.delayed(const Duration(milliseconds: 800));
    return _needsForceUpdate;
  }

  void setNeedsForceUpdate(bool needsUpdate) {
    _needsForceUpdate = needsUpdate;
  }
}
