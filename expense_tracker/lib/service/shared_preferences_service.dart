import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import '../data/constants/form_constants.dart';
import '../data/constants/shared_preferences_constants.dart';
import '../data/helpers/database/profile_helper.dart';
import '../data/helpers/database/user_helper.dart';
import '../data/helpers/shared_preferences_helper.dart';
import '../models/enums/app_theme.dart';
import '../models/enums/sort_criteria.dart';

class SharedPreferencesService {
  final Logger _logger = Logger(printer: SimplePrinter(), level: Level.info);

  final SharedPreferencesHelper _helper = SharedPreferencesHelper();

  Future<bool> setBoolPreference(String key, bool value) =>
      _helper.setBool(key, value);

  Future<bool?> getBoolPreference(String key) => _helper.getBool(key);

  Future<String?> getStringPreference(String key) => _helper.getString(key);

  Future<void> setStringPreference(String key, String value) =>
      _helper.setString(key, value);

  Future<int?> getIntPreference(String key) => _helper.getInt(key);

  Future<void> setIntPreference(String key, int value) =>
      _helper.setInt(key, value);

  Future<double?> getDoublePreference(String key) => _helper.getDouble(key);

  Future<void> setDoublePreference(String key, double value) =>
      _helper.setDouble(key, value);

  Future<void> deletePreference(String key) =>
      _helper.deleteSharedPreferences(key);

  Future<void> initializeSharedPreferences() async {
    _logger.i("initializing shared preferences");
    // await _helper.clearSharedPreferences();
    bool isFirstTime =
        await getBoolPreference(SharedPreferencesConstants.IS_FIRST_TIME_KEY) ??
            true;

    if (isFirstTime) {
      setBoolPreference(SharedPreferencesConstants.IS_FIRST_TIME_KEY, false);

      await initializeSortPreferences();
      await initializeFilterPreferences();
      await initializeSettingsPreferences();
      await initializeSummaryPreferences();
      await initializeThemePreferences();
      await initializeUserPreferences();
      await initializeProfilePreferences();
    }
  }

  Future<void> initializeSortPreferences() async {
    setStringPreference(SharedPreferencesConstants.sort.CRITERIA_KEY,
        SortCriteria.modifiedDate.name);
    setBoolPreference(SharedPreferencesConstants.sort.IS_ASCENDIND_KEY, false);
  }

  Future<void> initializeFilterPreferences() async {
    setBoolPreference(SharedPreferencesConstants.filter.IS_APPLIED_KEY, true);
    setBoolPreference(SharedPreferencesConstants.filter.IS_BY_YEAR_KEY, true);
    setBoolPreference(SharedPreferencesConstants.filter.IS_BY_MONTH_KEY, true);
    setStringPreference(SharedPreferencesConstants.filter.YEAR_KEY,
        DateFormat('yyyy').format(DateTime.now()));
    setStringPreference(SharedPreferencesConstants.filter.MONTH_KEY,
        DateFormat('MMMM').format(DateTime.now()));
  }

  Future<void> initializeSettingsPreferences() async {
    setStringPreference(SharedPreferencesConstants.settings.DEFAULT_CURRENCY,
        FormConstants.expense.currencies.keys.first);
  }

  Future<void> initializeSummaryPreferences() async {
    setBoolPreference(SharedPreferencesConstants.summary.HIDE_TOTAL_KEY, false);
  }

  Future<void> initializeThemePreferences() async {
    setStringPreference(
        SharedPreferencesConstants.theme.APP_THEME_KEY, AppTheme.black.name);
  }

  Future<void> initializeUserPreferences() async {
    setStringPreference(
        SharedPreferencesConstants.user.USER, UserHelper.defaultUser);
  }

  Future<void> initializeProfilePreferences() async {
    setStringPreference(SharedPreferencesConstants.profile.PROFILE,
        ProfileHelper.defaultProfile);
  }
}
