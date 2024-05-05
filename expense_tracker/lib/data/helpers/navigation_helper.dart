import 'package:flutter/material.dart';

class NavigationHelper {
  static void navigateToScreen(BuildContext context, Widget screenWidget) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => screenWidget,
      ),
    );
  }

  static navigateBack(BuildContext context) => Navigator.pop(context);

  static navigateBackWithBool(BuildContext context, bool result) =>
      Navigator.pop(context, result);

  static navigateToRoute(BuildContext context, Widget widget) {
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false, // Set opaque to false for transparency
        pageBuilder: (BuildContext context, _, __) => widget,
      ),
    );
  }
}
