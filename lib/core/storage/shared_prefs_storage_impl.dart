import 'package:grpc_app/core/storage/local_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsStorageImpl implements ILocalStorage {
  final SharedPreferences _prefs;

  SharedPrefsStorageImpl(this._prefs);

  @override
  Future<void> saveString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  @override
  Future<String?> getString(String key) async {
    return _prefs.getString(key);
  }

  @override
  Future<void> delete(String key) async {
    await _prefs.remove(key);
  }

  @override
  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
