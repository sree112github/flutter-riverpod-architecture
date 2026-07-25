     abstract interface class ILocalStorage {

       Future<void> saveString(String key, String value);
       Future<String?> getString(String key);
       Future<void> delete(String key);
       Future<void> clearAll();
     }