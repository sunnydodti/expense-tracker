import 'package:flutter/material.dart';

import '../data/constants/shared_preferences_constants.dart';
import '../data/constants/theme_constants.dart';
import '../data/helpers/color_helper.dart';
import '../models/enums/app_theme.dart';
import '../service/shared_preferences_service.dart';

class ThemeProvider with ChangeNotifier {
  AppTheme _theme = AppTheme.black;

  AppTheme get theme => _theme;

  setTheme(AppTheme appTheme) async {
    await SharedPreferencesService().setStringPreference(
        SharedPreferencesConstants.theme.APP_THEME_KEY, appTheme.name);

    _theme = appTheme;
    ColorHelper.isThemeChanged = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));
    ColorHelper.isThemeChanged = false;
  }

  ThemeData get themeData => appThemeMap[_theme]!;

  Future refreshTheme() async {
    String? themeName = await SharedPreferencesService()
        .getStringPreference(SharedPreferencesConstants.theme.APP_THEME_KEY);
    AppTheme appTheme =
        (themeName == null) ? _theme : AppTheme.values.byName(themeName);

    _theme = appTheme;
  }

// void createCustomTheme(Color primaryColor, Color secondaryColor) {
//   _currentTheme = ThemeData(
//     colorScheme: ColorScheme.light(
//       primary: primaryColor,
//       secondary: secondaryColor,
//     ),
//   );
//   notifyListeners();
// }
}
