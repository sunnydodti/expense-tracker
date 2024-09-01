import 'package:flutter/material.dart';

import '../../../data/helpers/color_helper.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final Widget content;
  String cancelAction;
  String confirmAction;
  VoidCallback? onCancel;
  VoidCallback? onConfirm;

  ConfirmationDialog({
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
    defaultOnTap() {
      Navigator.pop(context);
    }

    ThemeData theme = Theme.of(context);
    TextStyle buttonStyle =
        TextStyle(color: ColorHelper.getButtonTextColor(theme));
    return AlertDialog(
      backgroundColor: ColorHelper.getTileColor(theme),
      title: Text(title),
      content: content,
      actions: <Widget>[
        TextButton(
            child: Text(cancelAction, style: buttonStyle),
            onPressed: () {
              if (onCancel != null) onCancel!();
              defaultOnTap();
            }),
        TextButton(
          child: Text(confirmAction, style: buttonStyle),
          onPressed: () {
            if (onConfirm != null) onConfirm!();
            defaultOnTap();
          },
        ),
      ],
    );
  }
}
