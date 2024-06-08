import 'package:flutter/material.dart';

class ColorHelper {
  static bool isThemeChanged = false;

  static Color? _appBarColor;
  static Color? _backgroundColor;
  static Color? _tileColor;
  static Color? _iconColor;

  static Color getAppBarColor(ThemeData theme) {
    if (!isThemeChanged) {
      if (_appBarColor != null) return _appBarColor!;
    }

    double lerpT = theme.colorScheme.brightness == Brightness.light ? .1 : 0;
    _appBarColor = Color.lerp(theme.colorScheme.primary, Colors.white, lerpT);

    return _appBarColor!;
  }

  static Color getBackgroundColor(ThemeData theme) {
    if (!isThemeChanged) {
      if (_backgroundColor != null) return _backgroundColor!;
    }

    double lerpT = theme.colorScheme.brightness == Brightness.light ? .85 : .05;
    _backgroundColor =
        Color.lerp(theme.colorScheme.primary, Colors.white, lerpT);

    return _backgroundColor!;
  }

  static Color getTileColor(ThemeData theme) {
    if (!isThemeChanged) {
      if (_tileColor != null) {
        return _tileColor!;
      }
    }

    double lerpT = theme.colorScheme.brightness == Brightness.light ? .7 : .1;
    _tileColor = Color.lerp(theme.colorScheme.primary, Colors.white, lerpT);

    return _tileColor!;
  }

  static Color getIconColor(ThemeData theme) {
    if (!isThemeChanged) {
      if (_iconColor != null) return _iconColor!;
    }

    double lerpT = theme.colorScheme.brightness == Brightness.light ? .3 : 1;
    _iconColor = Color.lerp(theme.colorScheme.primary, Colors.white, lerpT);

    return _iconColor!;
  }
}
