import 'package:flutter/material.dart';

import '../../../data/constants/ui_constants.dart';
import '../../../data/helpers/color_helper.dart';
import '../../../data/helpers/navigation_helper.dart';

class YearPickerDialog {
  static Future<int?> show(BuildContext context) async {
    return showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.all(uiPaddingX2),
          contentPadding: const EdgeInsets.all(uiPaddingX2),
          backgroundColor: ColorHelper.getTileColor(Theme.of(context)),
          actionsPadding: const EdgeInsets.symmetric(
              horizontal: uiPaddingHalf, vertical: uiPaddingX2),
          insetPadding: const EdgeInsets.all(uiPadding),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                  child: Text('Select Year',
                      textScaler: TextScaler.linear(uiTextScalerAlertTitle))),
              IconButton(
                  onPressed: () => NavigationHelper.justNavigateBack(context),
                  icon: const Icon(Icons.clear))
            ],
          ),
          content: SizedBox(
            height: 200.0,
            width: 200.0,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: DateTime.now().year - 1999,
              itemBuilder: (context, index) {
                final year = DateTime.now().year - index;
                return ListTile(
                  title: Text(year.toString()),
                  onTap: () {
                    NavigationHelper.navigateBackWithResult(context, year);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
