import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grpc_app/core/router/app_state.dart';
import 'package:grpc_app/features/system_alerts/domain/services/mock_remote_config_service.dart';
import 'package:grpc_app/core/network/maintenance_interceptor.dart';
import 'package:grpc_app/features/system_alerts/domain/services/network_service.dart';
import 'package:grpc_app/core/storage/storage_provider.dart';
import 'package:grpc_app/core/storage/storage_keys.dart';

final appStateProvider = NotifierProvider<AppStateNotifier, AppState>(() {
  return AppStateNotifier();
});

class AppStateNotifier extends Notifier<AppState> {
  bool _isInitializing = false;
  bool _maintenanceTriggeredThisCheck = false;

  @override
  AppState build() {
    _initialize();
    
    // Listen to interceptor for maintenance mode
    ref.read(maintenanceInterceptorProvider).onMaintenanceModeTriggered = () {
      _maintenanceTriggeredThisCheck = true;
      state = AppState.maintenance;
    };
    
    return AppState.initializing;
  }

  Future<void> _initialize() async {
    _isInitializing = true;
    _maintenanceTriggeredThisCheck = false;
    try {
      // 1. Check Network
      final hasNetwork = await ref.read(networkServiceProvider).hasConnection();
      if (_maintenanceTriggeredThisCheck) return;
      
      if (!hasNetwork) {
        state = AppState.networkError;
        return;
      }

      // 2. Check Remote Config
      final needsUpdate = await ref.read(remoteConfigServiceProvider).needsForceUpdate();
      if (_maintenanceTriggeredThisCheck) return;
      
      if (needsUpdate) {
        state = AppState.forceUpdate;
        return;
      }
      
      // 3. Check Local Storage for Onboarding
      final prefs = ref.read(sharedPreferencesProvider);
      final termsAccepted = prefs.getBool(StorageKeys.termsAccepted) ?? false;
      if (!termsAccepted) {
        state = AppState.termsPending;
        return;
      }

      final introSeen = prefs.getBool(StorageKeys.introSeen) ?? false;
      if (!introSeen) {
        state = AppState.introPending;
        return;
      }

      // Ready triggers go_router to check auth state
      state = AppState.ready;
    } finally {
      _isInitializing = false;
    }
  }
  
  Future<void> retryInitialization() async {
    if (_isInitializing) return; // Prevent spam clicking causing race conditions
    // We do NOT set state to initializing here, to avoid jumping to the splash screen.
    // Instead, we stay on the current screen and let it show a loading spinner.
    await _initialize();
  }
  Future<void> acceptTerms() async {
    if (state == AppState.maintenance) return;
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(StorageKeys.termsAccepted, true);
    
    // Instantly check next step instead of re-running network/config calls
    final introSeen = prefs.getBool(StorageKeys.introSeen) ?? false;
    if (!introSeen) {
      state = AppState.introPending;
    } else {
      state = AppState.ready;
    }
  }

  Future<void> finishIntro() async {
    if (state == AppState.maintenance) return;
    await ref.read(sharedPreferencesProvider).setBool(StorageKeys.introSeen, true);
    state = AppState.ready;
  }
  
  Future<void> clearPreferences() async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.remove(StorageKeys.termsAccepted);
    await prefs.remove(StorageKeys.introSeen);
    retryInitialization(); // Restart flow
  }
}
