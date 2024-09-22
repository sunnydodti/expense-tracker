import 'package:flutter/material.dart';

import '../../../data/helpers/color_helper.dart';

class DateTimePickerDialog {
  static Future<DateTime?> datePicker(BuildContext context) {
    DateTime now = DateTime.now();
    ThemeData theme = Theme.of(context);
    ColorScheme? colorScheme = (theme.brightness == Brightness.light)
        ? null
        : ColorScheme(
            brightness: theme.brightness,
            primary: theme.primaryColor,
            onPrimary: Colors.white,
            secondary: theme.colorScheme.secondary,
            onSecondary: theme.colorScheme.onSecondary,
            error: theme.colorScheme.error,
            onError: theme.colorScheme.onError,
            background: theme.colorScheme.background,
            onBackground: Colors.white,
            surface: theme.colorScheme.surface,
            onSurface: Colors.white,
          );

    TextButtonThemeData? textTheme = (theme.brightness == Brightness.light)
        ? null
        : TextButtonThemeData(
            style: TextButton.styleFrom(foregroundColor: Colors.white));

    return showDatePicker(
        context: context,
        initialDate: now,
        firstDate: DateTime(2000),
        lastDate: DateTime(now.year + 100),
        builder: (BuildContext context, Widget? child) {
          return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: colorScheme,
                textButtonTheme: textTheme,
                dialogBackgroundColor: ColorHelper.getTileColor(theme),
              ),
              child: child!);
        });
  }
}
