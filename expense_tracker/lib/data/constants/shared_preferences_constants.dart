class SharedPreferencesConstants {
  static String IS_FIRST_TIME_KEY = "is_first_time";
  static SortPreferencesConstants sort = SortPreferencesConstants();
  static FilterPreferencesConstants filter = FilterPreferencesConstants();
  static SettingsPreferencesConstants settings = SettingsPreferencesConstants();
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
