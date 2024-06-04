import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(colorScheme: const ColorScheme.light());

final ThemeData darkTheme = ThemeData(colorScheme: const ColorScheme.dark());

final ThemeData blackTheme = ThemeData(
  colorScheme: const ColorScheme.dark(
    primary: Colors.black,
    secondary: Colors.white,
  ),
);

final ThemeData customTheme = ThemeData(
  colorScheme: const ColorScheme.light(
    primary: Colors.green,
    secondary: Colors.orange,
  ),
);
