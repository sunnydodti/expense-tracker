import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../data/constants/ui_constants.dart';
import '../../data/helpers/color_helper.dart';
import '../../data/helpers/navigation_helper.dart';

class ShareFileDialog {
  static Future<void> show(BuildContext context,
      {String title = 'Share File',
      String content = 'Do you want to share this file?',
      required String filePath,
      bool showFileName = false}) async {
    final fileName = _extractFileName(filePath);

    await showDialog(
      context: context,
      builder: (context) {
        ThemeData theme = Theme.of(context);
        Color? actionColor = ColorHelper.getButtonTextColor(theme);
        return AlertDialog(
          titlePadding: const EdgeInsets.all(uiPaddingX2),
          contentPadding: const EdgeInsets.all(uiPaddingX2),
          backgroundColor: ColorHelper.getTileColor(theme),
          actionsPadding: const EdgeInsets.symmetric(
            horizontal: uiPaddingHalf,
            vertical: uiPaddingX2,
          ),
          insetPadding: const EdgeInsets.all(uiPadding),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title.toString(),
                  textScaler: const TextScaler.linear(uiTextScalerAlertTitle),
                ),
              ),
              IconButton(
                onPressed: () => NavigationHelper.justNavigateBack(context),
                icon: const Icon(Icons.clear),
              )
            ],
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!kIsWeb) Text(content),
              if (showFileName) const SizedBox(height: 10),
              if (showFileName) Text(fileName),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => NavigationHelper.justNavigateBack(context),
              child: Text('Close', style: TextStyle(color: actionColor)),
            ),
            if (!kIsWeb)
              TextButton(
                onPressed: () {
                  XFile file = XFile(filePath);
                  Share.shareXFiles([file]);
                  NavigationHelper.justNavigateBack(context);
                },
                child: Text('Share', style: TextStyle(color: actionColor)),
              ),
          ],
        );
      },
    );
  }

  static String _extractFileName(String filePath) {
    final lastIndex = filePath.lastIndexOf('/');
    return filePath.substring(lastIndex + 1);
  }
}
