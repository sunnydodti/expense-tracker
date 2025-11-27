
// ignore_for_file: constant_identifier_names, non_constant_identifier_names

class SharedPreferencesConstants {
  SharedPreferencesConstants._();
  static const String IS_FIRST_TIME_KEY = "is_first_time";
  static final SortPreferencesConstants sort = SortPreferencesConstants();
  static final FilterPreferencesConstants filter = FilterPreferencesConstants();
  static final SettingsPreferencesConstants settings = SettingsPreferencesConstants();
  static final SummaryPreferencesConstants summary = SummaryPreferencesConstants();
  static final AppThemeConstants theme = AppThemeConstants();
  static final UserConstants user = UserConstants();
  static final ProfileConstants profile = ProfileConstants();
}

class SortPreferencesConstants {
  final String IS_ASCENDIND_KEY = "sort_is_ascending";
  final String CRITERIA_KEY = "sort_criteria";
}

class FilterPreferencesConstants {
  final String IS_APPLIED_KEY = "filter_is_applied";
  final String IS_BY_YEAR_KEY = "filter_is_by_year";
  final String IS_BY_MONTH_KEY = "filter_is_by_month";
  final String YEAR_KEY = "filter_year";
  final String MONTH_KEY = "filter_month";
}

class SettingsPreferencesConstants {
  final String DEFAULT_CURRENCY = "default_currency";
}

class SummaryPreferencesConstants {
  final String HIDE_TOTAL_KEY = "hide_total";
}

class AppThemeConstants {
  final String APP_THEME_KEY = "app_theme";
}

class UserConstants {
  final String USER = "user";
}

class ProfileConstants {
  final String PROFILE = "profile";
}