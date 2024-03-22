import 'dart:async';

import 'package:flutter/material.dart';

class SnackBarService {
  static void showSnackBarWithContext(BuildContext context, String message, {bool removeCurrent = false}) {
    if (removeCurrent) ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void showErrorSnackBarWithContext(BuildContext context, String message, {bool removeCurrent = false}) {
    if (removeCurrent) ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void showSuccessSnackBarWithContext(BuildContext context, String message, {bool removeCurrent = false}) {
    if (removeCurrent) ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static Future<bool> showUndoSnackBar(BuildContext context, String message, {bool removeCurrent = false}) async {
    if (removeCurrent) ScaffoldMessenger.of(context).removeCurrentSnackBar();
    Completer<bool> completer = Completer<bool>();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            completer.complete(true);
          },
        ),
      ),
    );
    await Future.delayed(const Duration(seconds: 5));

    if (!completer.isCompleted) {
      completer.complete(false);
    }
    return completer.future;
  }
}
