import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../data/constants/ui_constants.dart';
import '../../../data/helpers/color_helper.dart';
import '../../../data/helpers/navigation_helper.dart';

class MonthPickerDialog {
  static Future<String?> show(BuildContext context) async {
    return showDialog<String>(
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
                  child: Text(
                'Select Month',
                textScaler: TextScaler.linear(uiTextScalerAlertTitle),
              )),
              IconButton(
                onPressed: () => NavigationHelper.justNavigateBack(context),
                icon: const Icon(Icons.clear),
              )
            ],
          ),
          content: SizedBox(
            height: 200.0,
            width: 200.0,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 12,
              itemBuilder: (context, index) {
                final fullMonth =
                    DateFormat('MMMM').format(DateTime(2000, index + 1));
                final shortMonth =
                    DateFormat('MMMM').format(DateTime(2000, index + 1));
                return ListTile(
                  title: Text(fullMonth),
                  onTap: () {
                    NavigationHelper.navigateBackWithResult(
                        context, shortMonth);
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
