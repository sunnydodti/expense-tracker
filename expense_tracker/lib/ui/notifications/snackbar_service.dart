import 'dart:async';

import 'package:flutter/material.dart';

class SnackBarService {
  //region Section 1: SnackBarWithContext

  static showSnackBarWithContext(BuildContext context, String message,
      {bool removeCurrent = false, int duration = 2}) {
    if (removeCurrent) ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: duration),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static showErrorSnackBarWithContext(BuildContext context, String message,
      {bool removeCurrent = false, int duration = 2}) {
    if (removeCurrent) ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: duration),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static showSuccessSnackBarWithContext(BuildContext context, String message,
      {bool removeCurrent = false, int duration = 2}) async {
    if (removeCurrent) ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: duration),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static Future<bool> showUndoSnackBarWithContext(
      BuildContext context, String message,
      {bool removeCurrent = false, int duration = 2}) async {
    if (removeCurrent) ScaffoldMessenger.of(context).removeCurrentSnackBar();
    Completer<bool> completer = Completer<bool>();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: duration),
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

  static void emptyFunction() {}

  static showUndoSnackBarWithContextAndCallback(
      BuildContext context, String message, Function onUndo,
      {bool removeCurrent = false,
      int duration = 2,
      Function onNotUndo = emptyFunction}) async {
    if (removeCurrent) ScaffoldMessenger.of(context).removeCurrentSnackBar();
    bool isUndoPressed = false;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: duration),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            isUndoPressed = true;
            onUndo();
          },
        ),
      ),
    );
    await Future.delayed(const Duration(seconds: 5));
    debugPrint("undo: $isUndoPressed");
    if (isUndoPressed == false) onNotUndo();
  }
//endregion

//region Section 2: SnackBarWithoutContext

//endregion
}
