import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  colorScheme: const ColorScheme.light(
    primary: Colors.blue,
    secondary: Colors.amber,
  ),
);

final ThemeData darkTheme = ThemeData(
  colorScheme: ColorScheme.dark(
    primary: Colors.grey[900]!,
    secondary: Colors.redAccent,
  ),
);

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
