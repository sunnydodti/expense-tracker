import 'package:flutter/material.dart';

import '../../../data/helpers/color_helper.dart';

class MessageDialog extends StatelessWidget {
  final String title;
  final String message;

  const MessageDialog({Key? key, required this.title, required this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return AlertDialog(
      backgroundColor: ColorHelper.getTileColor(theme),
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
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
