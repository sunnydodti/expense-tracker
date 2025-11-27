import 'package:flutter/material.dart';

import '../../../data/constants/ui_constants.dart';
import '../../../data/helpers/color_helper.dart';
import '../../../data/helpers/navigation_helper.dart';

class MessageDialog extends StatelessWidget {
  final String title;
  final String message;

  const MessageDialog({super.key, required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return AlertDialog(
      titlePadding: const EdgeInsets.all(uiPaddingX2),
      contentPadding: const EdgeInsets.all(uiPaddingX2),
      backgroundColor: ColorHelper.getTileColor(theme),
      actionsPadding: const EdgeInsets.symmetric(
          horizontal: uiPaddingHalf, vertical: uiPaddingX2),
      insetPadding: const EdgeInsets.all(uiPadding),
      title: Text(
        title,
        textScaler: const TextScaler.linear(uiTextScalerAlertTitle),
      ),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => NavigationHelper.justNavigateBack(context),
          child: Text(
            'OK',
            style: TextStyle(
                color: (theme.brightness == Brightness.dark)
                    ? Colors.white
                    : null),
          ),
        ),
      ],
    );
  }
}
