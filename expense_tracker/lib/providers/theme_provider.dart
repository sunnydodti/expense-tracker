import 'package:flutter/material.dart';

import '../data/constants/theme_constants.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _currentTheme = blackTheme;

  ThemeData get currentTheme => _currentTheme;

  void setTheme(ThemeData theme) {
    _currentTheme = theme;
    notifyListeners();
  }

  void createCustomTheme(Color primaryColor, Color secondaryColor) {
    _currentTheme = ThemeData(
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
      ),
    );
    notifyListeners();
  }
}
