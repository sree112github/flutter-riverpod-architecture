import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grpc_app/core/storage/local_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:grpc_app/core/storage/shared_prefs_storage_impl.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden in main.dart');
});

final localStorageProvider = Provider<ILocalStorage>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SharedPrefsStorageImpl(prefs);
});
