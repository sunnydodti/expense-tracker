import 'package:flutter/foundation.dart';

import '../data/constants/form_constants.dart';
import '../service/settings_service.dart';

class SettingsProvider extends ChangeNotifier {
  late final SettingsService _settingsService;

  SettingsProvider() {
    _init();
  }

  Future<void> _init() async {
    _settingsService = SettingsService();
  }

  // preferences
  String _defaultCurrency = FormConstants.expense.currencies.keys.first;

  String get defaultCurrency => _defaultCurrency;

  void setDefaultCurrency(String value) {
    _defaultCurrency = value;
    _settingsService.setDefaultCurrency(value);
    notifyListeners();
  }

  refreshDefaultCurrency({bool notify = false}) async {
    String? defaultCurrency = await _settingsService.getDefaultCurrency();

    _defaultCurrency = defaultCurrency ?? _defaultCurrency;

    if (notify) notifyListeners();
  }

  refreshPreferences({bool notify = false}) async {
    String? defaultCurrency = await _settingsService.getDefaultCurrency();

    _defaultCurrency = defaultCurrency ?? _defaultCurrency;

    if (notify) notifyListeners();
  }
}
