import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const String _preferencesKey = 'ExpenseTracker';

  Future<bool> setBool(String key, bool value) async {
    final preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(_getKey(key), value);
  }

  Future<bool?> getBool(String key) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(_getKey(key));
  }

  Future<String?> getString(String key) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(_getKey(key));
  }

  Future<void> setString(String key, String value) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_getKey(key), value);
  }

  Future<int?> getInt(String key) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getInt(_getKey(key));
  }

  Future<void> setInt(String key, int value) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setInt(_getKey(key), value);
  }

  Future<double?> getDouble(String key) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getDouble(_getKey(key));
  }

  Future<void> setDouble(String key, double value) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setDouble(_getKey(key), value);
  }

  Future<void> deleteSharedPreferences(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove(_getKey(key));
  }

  Future<void> clearSharedPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }

  String _getKey(String key) => '$_preferencesKey.$key';
}
