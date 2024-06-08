import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/constants/theme_constants.dart';
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
            _buildThemeSelector(themeProvider),
          ],
        ),
      ),
    );
  }

  Container _buildThemeSelector(ThemeProvider themeProvider) {
    Color boxColor = (themeProvider.theme == AppTheme.black)
        ? Colors.grey.shade700
        : appThemeMap[themeProvider.theme]!
            .colorScheme
            .inversePrimary
            .withOpacity(.3);
    return Container(
      width: 110,
      decoration: BoxDecoration(
          color: boxColor, borderRadius: BorderRadius.circular(5)),
      child: DropdownButton<AppTheme>(
        isExpanded: true,
        value: themeProvider.theme,
        items: getThemeDropdownItems(),
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

  static List<DropdownMenuItem<AppTheme>> getThemeDropdownItems() {
    return appThemeMap.keys
        .map((AppTheme theme) => DropdownMenuItem<AppTheme>(
              value: theme,
              alignment: Alignment.centerRight,
              child: Text(
                theme.toString().split('.').last,
                style: TextStyle(
                    color: appThemeMap[theme]!.colorScheme.primary),
              ),
            ))
        .toList();
  }
}
