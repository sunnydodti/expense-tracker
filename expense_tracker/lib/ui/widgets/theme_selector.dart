import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/constants/theme_constants.dart';
import '../../data/helpers/color_helper.dart';
import '../../models/enums/app_theme.dart';
import '../../providers/theme_provider.dart';

class ThemeSelector extends StatelessWidget {
  const ThemeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('App Theme', textScaleFactor: 1.1),
            _buildThemeSelector(themeProvider, context),
          ],
        ),
      ),
    );
  }

  Container _buildThemeSelector(
      ThemeProvider themeProvider, BuildContext context) {
    Color dropdownColor = ColorHelper.getTileColor(Theme.of(context));
    return Container(
      width: 110,
      decoration: BoxDecoration(
          color: dropdownColor, borderRadius: BorderRadius.circular(5)),
      child: DropdownButton<AppTheme>(
        dropdownColor: dropdownColor,
        isExpanded: true,
        value: themeProvider.theme,
        items: getThemeDropdownItems(Theme.of(context)),
        hint: const Text('Theme'),
        alignment: Alignment.centerRight,
        onChanged: (value) {
          if (value != null) {
            themeProvider.setTheme(value);
          }
        },
        underline: Container(),
      ),
    );
  }

  static List<DropdownMenuItem<AppTheme>> getThemeDropdownItems(
      ThemeData theme) {
    return appThemeMap.keys.map((AppTheme appTheme) {
      Color? color = appThemeMap[appTheme]!.colorScheme.primary;
      if (theme.colorScheme.brightness != Brightness.light) {
        if (appTheme == AppTheme.black) color = Colors.grey;
      }
      TextStyle style = TextStyle(color: color);
      return DropdownMenuItem<AppTheme>(
        value: appTheme,
        alignment: Alignment.centerRight,
        child: Text(appTheme.toString().split('.').last, style: style),
      );
    }).toList();
  }
}
