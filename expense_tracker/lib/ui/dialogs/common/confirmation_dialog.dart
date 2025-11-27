import 'package:flutter/material.dart';

import '../../../data/constants/ui_constants.dart';
import '../../../data/helpers/color_helper.dart';
import '../../../data/helpers/navigation_helper.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final String cancelAction;
  final String confirmAction;
  final VoidCallback? onCancel;
  final VoidCallback? onConfirm;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.content,
    this.cancelAction = "Cancel",
    this.confirmAction = "Confirm",
    this.onCancel,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    void defaultOnTap() {
      NavigationHelper.justNavigateBack(context);
    }

    ThemeData theme = Theme.of(context);
    TextStyle buttonStyle =
        TextStyle(color: ColorHelper.getButtonTextColor(theme));
    return AlertDialog(
      titlePadding: const EdgeInsets.all(uiPaddingX2),
      contentPadding: const EdgeInsets.all(uiPaddingX2),
      backgroundColor: ColorHelper.getTileColor(theme),
      actionsPadding: const EdgeInsets.symmetric(
          horizontal: uiPaddingHalf, vertical: uiPaddingX2),
      insetPadding: const EdgeInsets.all(uiPadding),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Text(title,
                  textScaler: const TextScaler.linear(uiTextScalerAlertTitle))),
          IconButton(
            onPressed: () => NavigationHelper.justNavigateBack(context),
            icon: const Icon(Icons.close_outlined),
          )
        ],
      ),
      content: content,
      actions: <Widget>[
        TextButton(
            child: Text(cancelAction, style: buttonStyle),
            onPressed: () {
              onCancel?.call();
              defaultOnTap();
            }),
        TextButton(
          child: Text(confirmAction, style: buttonStyle),
          onPressed: () {
            onConfirm?.call();
            defaultOnTap();
          },
        ),
      ],
    );
  }
}
