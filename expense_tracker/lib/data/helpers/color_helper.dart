import 'package:flutter/material.dart';

class ColorHelper {
  static Color? _appBarColor;
  static Color? _screenAppBarColor;
  static Color? _backgroundColor;
  static Color? _tileColor;
  static Color? _iconColor;
  static Color? _toggleColor;
  static Color? _buttonTextColor;
  static Color? _dropDownTextColor;

  static void resetColors() {
    _appBarColor = null;
    _screenAppBarColor = null;
    _backgroundColor = null;
    _tileColor = null;
    _iconColor = null;
    _toggleColor = null;
    _buttonTextColor = null;
    _dropDownTextColor = null;
  }

  static Color getAppBarColor(ThemeData theme) {
    if (_appBarColor != null) return _appBarColor!;

    double lerpT = theme.colorScheme.brightness == Brightness.light ? .1 : 0;
    _appBarColor = Color.lerp(theme.colorScheme.primary, Colors.white, lerpT);

    return _appBarColor!;
  }

  static Color getScreenAppBarColor(ThemeData theme) {
    if (_screenAppBarColor != null) return _screenAppBarColor!;

    double lerpT = theme.colorScheme.brightness == Brightness.light ? .35 : .03;
    _screenAppBarColor = Color.lerp(theme.colorScheme.primary, Colors.white, lerpT);

    return _screenAppBarColor!;
  }

  static Color getBackgroundColor(ThemeData theme) {
    if (_backgroundColor != null) return _backgroundColor!;

    double lerpT = theme.colorScheme.brightness == Brightness.light ? .85 : .05;
    _backgroundColor =
        Color.lerp(theme.colorScheme.primary, Colors.white, lerpT);

    return _backgroundColor!;
  }

  static Color getTileColor(ThemeData theme) {
    if (_tileColor != null) return _tileColor!;

    double lerpT = theme.colorScheme.brightness == Brightness.light ? .7 : .1;
    _tileColor = Color.lerp(theme.colorScheme.primary, Colors.white, lerpT);

    return _tileColor!;
  }

  static Color getIconColor(ThemeData theme) {
    if (_iconColor != null) return _iconColor!;

    double lerpT = theme.colorScheme.brightness == Brightness.light ? .3 : 1;
    _iconColor = Color.lerp(theme.colorScheme.primary, Colors.white, lerpT);

    return _iconColor!;
  }

  static Color? getToggleColor(ThemeData theme) {
    if (_toggleColor != null) return _toggleColor;

    _toggleColor = theme.colorScheme.brightness == Brightness.light
        ? getIconColor(theme)
        : Colors.grey.shade800;

    return _toggleColor;
  }

  static Color? getButtonTextColor(ThemeData theme) {
    if (_buttonTextColor != null) return _buttonTextColor;
    _buttonTextColor =
        (theme.brightness == Brightness.dark) ? Colors.white : null;

    return _buttonTextColor;
  }

  static Color? getDropdownTextColor(ThemeData theme) {
    if (_dropDownTextColor != null) return _dropDownTextColor;
    _dropDownTextColor =
        (theme.brightness == Brightness.dark) ? null : Colors.black;

    return _dropDownTextColor;
  }
}
