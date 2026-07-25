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
  @override
  AppState build() {
    _initialize();
    
    // Listen to interceptor for maintenance mode
    ref.read(maintenanceInterceptorProvider).onMaintenanceModeTriggered = () {
      state = AppState.maintenance;
    };
    
    return AppState.initializing;
  }

  Future<void> _initialize() async {
    // 1. Check Network
    final hasNetwork = await ref.read(networkServiceProvider).hasConnection();
    if (!hasNetwork) {
      state = AppState.networkError;
      return;
    }

    // 2. Check Remote Config
    final needsUpdate = await ref.read(remoteConfigServiceProvider).needsForceUpdate();
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
  }
  
  void retryInitialization() {
    state = AppState.initializing;
    _initialize();
  }
  Future<void> acceptTerms() async {
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
