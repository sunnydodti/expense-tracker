import 'package:expense_tracker/models/enums/sort_criteria.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/shared_preferences_constants.dart';

class SharedPreferencesHelper {
  static const String _prefsKey = 'ExpenseTracker';

  static Future<bool> setBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(_getKey(key), value);
  }

  static Future<bool?> getBool(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_getKey(key));
  }

  static Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_getKey(key));
  }

  static Future<void> setString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_getKey(key), value);
  }

  static Future<int?> getInt(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_getKey(key));
  }

  static Future<void> setInt(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_getKey(key), value);
  }

  static Future<double?> getDouble(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_getKey(key));
  }

  static Future<void> setDouble(String key, double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_getKey(key), value);
  }

  static String _getKey(String key) => '$_prefsKey.$key';

  static Future<void> deleteSharedPreferences(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  static Future<void> initializeSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(SharedPreferencesConstants.IS_FIRST_TIME_KEY, true);
    bool isFirstTime = prefs.getBool(SharedPreferencesConstants.IS_FIRST_TIME_KEY) ?? true;

    if (isFirstTime) {
      prefs.setBool(SharedPreferencesConstants.IS_FIRST_TIME_KEY, false);

      prefs.setString(SharedPreferencesConstants.sort.SORT_CRITERIA_KEY, SortCriteria.modifiedDate.name);
      prefs.setBool(SharedPreferencesConstants.sort.IS_ASCENDIND_SORT_KEY, false);
    }
  }
}
