import 'package:shared_preferences/shared_preferences.dart';

import '../../models/enums/sort_criteria.dart';
import '../constants/shared_preferences_constants.dart';

class SharedPreferencesHelper {
  static const String _preferencesKey = 'ExpenseTracker';

  static Future<bool> setBool(String key, bool value) async {
    final preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(_getKey(key), value);
  }

  static Future<bool?> getBool(String key) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(_getKey(key));
  }

  static Future<String?> getString(String key) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(_getKey(key));
  }

  static Future<void> setString(String key, String value) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_getKey(key), value);
  }

  static Future<int?> getInt(String key) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getInt(_getKey(key));
  }

  static Future<void> setInt(String key, int value) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setInt(_getKey(key), value);
  }

  static Future<double?> getDouble(String key) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getDouble(_getKey(key));
  }

  static Future<void> setDouble(String key, double value) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setDouble(_getKey(key), value);
  }

  static String _getKey(String key) => '$_preferencesKey.$key';

  static Future<void> deleteSharedPreferences(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove(key);
  }

  static Future<void> initializeSharedPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // await preferences.clear();
    bool isFirstTime = preferences
            .getBool(_getKey(SharedPreferencesConstants.IS_FIRST_TIME_KEY)) ??
        true;

    if (isFirstTime) {
      preferences.setBool(
          _getKey(SharedPreferencesConstants.IS_FIRST_TIME_KEY), false);

      preferences.setString(
          _getKey(SharedPreferencesConstants.sort.SORT_CRITERIA_KEY),
          SortCriteria.modifiedDate.name);
      preferences.setBool(
          _getKey(SharedPreferencesConstants.sort.IS_ASCENDIND_SORT_KEY),
          false);
    }
  }
}
