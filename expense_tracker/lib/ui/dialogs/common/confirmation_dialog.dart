import 'package:flutter/material.dart';

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

    return AlertDialog(
      title: Text(title),
      content: content,
      actions: <Widget>[
        TextButton(
            child: Text(cancelAction),
            onPressed: () {
              if (onCancel != null) onCancel!();
              defaultOnTap();
            }),
        TextButton(
          child: Text(confirmAction),
          onPressed: () {
            if (onConfirm != null) onConfirm!();
            defaultOnTap();
          },
        ),
      ],
    );
  }
}
