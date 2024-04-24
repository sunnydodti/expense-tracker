import 'package:logger/logger.dart';

import '../data/constants/shared_preferences_constants.dart';
import 'shared_preferences_service.dart';

class SettingsService extends SharedPreferencesService {
  static final Logger _logger =
      Logger(printer: SimplePrinter(), level: Level.info);

  Future<String?> getDefaultCurrency() async {
    String? defaultCurrency;
    try {
      defaultCurrency = await getStringPreference(
          SharedPreferencesConstants.settings.DEFAULT_CURRENCY);
    } catch (e, stackTrace) {
      _logger.e(
          "error retrieving is defaultCurrency from shared preferences at getDefaultCurrency(): $e - \n$stackTrace");
    }
    return defaultCurrency;
  }

  setDefaultCurrency(String value) async {
    setStringPreference(
        SharedPreferencesConstants.settings.DEFAULT_CURRENCY, value);
  }
}
