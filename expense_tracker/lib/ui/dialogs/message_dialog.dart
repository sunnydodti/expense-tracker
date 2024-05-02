import 'package:flutter/material.dart';

class MessageDialog extends StatelessWidget {
  final String title;
  final String message;

  const MessageDialog(
      {Key? key, required this.title, required this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
