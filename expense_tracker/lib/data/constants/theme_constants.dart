import 'package:flutter/material.dart';

import '../../models/enums/app_theme.dart';

final Map<AppTheme, ThemeData> appThemeMap = {
  AppTheme.red: redTheme,
  AppTheme.orange: orangeTheme,
  AppTheme.pink: pinkTheme,
  AppTheme.purple: purpleTheme,
  AppTheme.green: greenTheme,
  AppTheme.lightGreen: lightGreenTheme,
  AppTheme.teal: tealTheme,
  AppTheme.cyan: cyanTheme,
  AppTheme.blue: blueTheme,
  AppTheme.indigo: indigoTheme,
  AppTheme.black: blackTheme,
  AppTheme.custom: customTheme,
};

final ThemeData redTheme =
    ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.red));

final ThemeData orangeTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange.shade900));

final ThemeData pinkTheme =
    ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink));

final ThemeData purpleTheme =
    ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple));

final ThemeData greenTheme =
    ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.green));

final ThemeData lightGreenTheme =
    ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen));

final ThemeData tealTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal.shade900));

final ThemeData cyanTheme =
    ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan));

final ThemeData blueTheme =
    ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue));

final ThemeData indigoTheme =
    ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo));

final ThemeData greyTheme =
    ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey));

final ThemeData blackTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.black,
    primary: Colors.black,
    brightness: Brightness.dark,
  ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Colors.white,
      selectionColor: Colors.white54,
      selectionHandleColor: Colors.white,
    ),
    expansionTileTheme: const ExpansionTileThemeData(
      textColor: Colors.white,
      iconColor: Colors.white,
    ));

final ThemeData customTheme = ThemeData(
  colorScheme: const ColorScheme.light(
    primary: Colors.green,
    secondary: Colors.orange,
  ),
);
