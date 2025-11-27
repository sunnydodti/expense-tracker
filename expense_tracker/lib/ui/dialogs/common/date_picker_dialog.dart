import 'package:flutter/material.dart';

import '../../../data/helpers/color_helper.dart';

class DateTimePickerDialog {
  static Future<DateTime?> datePicker(BuildContext context) {
    final DateTime now = DateTime.now();
    final ThemeData theme = Theme.of(context);

    final ColorScheme? colorScheme = (theme.brightness == Brightness.light)
        ? null
        : theme.colorScheme.copyWith(
            primary: theme.primaryColor,
            onPrimary: Colors.white,
            onSurface: Colors.white,
          );

    final TextButtonThemeData? textTheme = (theme.brightness == Brightness.light)
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
          data: theme.copyWith(
            colorScheme: colorScheme,
            textButtonTheme: textTheme,
            dialogBackgroundColor: ColorHelper.getTileColor(theme),
          ),
          child: child!,
        );
      },
    );
  }
}
