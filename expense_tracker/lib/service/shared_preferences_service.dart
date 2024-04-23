import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import '../data/constants/shared_preferences_constants.dart';
import '../data/helpers/shared_preferences_helper.dart';
import '../models/enums/sort_criteria.dart';

class SharedPreferencesService {
  static final Logger _logger =
      Logger(printer: SimplePrinter(), level: Level.info);

  static final SharedPreferencesHelper _helper = SharedPreferencesHelper();

  static Future<bool> setBoolPreference(String key, bool value) =>
      _helper.setBool(key, value);

  static Future<bool?> getBoolPreference(String key) => _helper.getBool(key);

  static Future<String?> getStringPreference(String key) =>
      _helper.getString(key);

  static Future<void> setStringPreference(String key, String value) =>
      _helper.setString(key, value);

  static Future<int?> getIntPreference(String key) => _helper.getInt(key);

  static Future<void> setIntPreference(String key, int value) =>
      _helper.setInt(key, value);

  static Future<double?> getDoublePreference(String key) =>
      _helper.getDouble(key);

  static Future<void> setDoublePreference(String key, double value) =>
      _helper.setDouble(key, value);

  static Future<void> deletePreference(String key) =>
      _helper.deleteSharedPreferences(key);

  static Future<void> initializeSharedPreferences() async {
    _logger.i("initializing shared preferences");
    // await _helper.clearSharedPreferences();
    bool isFirstTime =
        await getBoolPreference(SharedPreferencesConstants.IS_FIRST_TIME_KEY) ??
            true;

    if (isFirstTime) {
      setBoolPreference(SharedPreferencesConstants.IS_FIRST_TIME_KEY, false);

      // sort preferences
      setStringPreference(SharedPreferencesConstants.sort.CRITERIA_KEY,
          SortCriteria.modifiedDate.name);
      setBoolPreference(
          SharedPreferencesConstants.sort.IS_ASCENDIND_KEY, false);

      // filter preferences
      setBoolPreference(SharedPreferencesConstants.filter.IS_APPLIED_KEY, true);
      setBoolPreference(SharedPreferencesConstants.filter.IS_BY_YEAR_KEY, true);
      setBoolPreference(
          SharedPreferencesConstants.filter.IS_BY_MONTH_KEY, true);
      setStringPreference(SharedPreferencesConstants.filter.YEAR_KEY,
          DateFormat('yyyy').format(DateTime.now()));
      setStringPreference(SharedPreferencesConstants.filter.MONTH_KEY,
          DateFormat('MMMM').format(DateTime.now()));
    }
  }
}
