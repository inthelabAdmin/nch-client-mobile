import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsManager {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<bool> containsKey(String key) async {
    await initIfNeeded();
    return _prefs!.containsKey(key);
  }

  static Future<void> setString(String key, String value) async {
    await initIfNeeded();
    await _prefs!.setString(key, value);
  }

  static Future<String?> getString(String key) async {
    await initIfNeeded();
    return _prefs!.getString(key);
  }

  static Future<void> setBool(String key, bool value) async {
    await initIfNeeded();
    await _prefs!.setBool(key, value);
  }

  static Future<bool?> getBool(String key) async {
    await initIfNeeded();
    return _prefs!.getBool(key);
  }

  static Future<void> setInt(String key, int value) async {
    await initIfNeeded();
    await _prefs!.setInt(key, value);
  }

  static Future<int?> getInt(String key) async {
    await initIfNeeded();
    return _prefs!.getInt(key);
  }

  static Future<void> setDouble(String key, double value) async {
    await initIfNeeded();
    await _prefs!.setDouble(key, value);
  }

  static Future<double?> getDouble(String key) async {
    await initIfNeeded();
    return _prefs!.getDouble(key);
  }

  static Future<void> remove(String key) async {
    await initIfNeeded();
    await _prefs!.remove(key);
  }

  static Future<void> clear() async {
    await initIfNeeded();
    await _prefs!.clear();
  }

  static Future<void> initIfNeeded() async {
    if (_prefs == null) {
      await init();
    }
  }
}