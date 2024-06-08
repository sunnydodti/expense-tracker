import 'package:flutter/material.dart';

import '../data/constants/theme_constants.dart';
import '../data/helpers/color_helper.dart';
import '../models/enums/app_theme.dart';

class ThemeProvider with ChangeNotifier {
  AppTheme _theme = AppTheme.black;

  AppTheme get theme => _theme;

  setTheme(AppTheme appTheme) async {
    _theme = appTheme;
    ColorHelper.isThemeChanged = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));
    ColorHelper.isThemeChanged = false;
  }

  ThemeData get themeData => appThemeMap[_theme]!;

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
