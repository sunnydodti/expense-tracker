import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../data/helpers/color_helper.dart';

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
          backgroundColor: ColorHelper.getTileColor(theme),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title.toString()),
              IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.clear))
            ],
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(content),
              if (showFileName) const SizedBox(height: 10),
              if (showFileName) Text(fileName),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: actionColor),
              ),
            ),
            TextButton(
              onPressed: () {
                XFile file = XFile(filePath);
                Share.shareXFiles([file]);
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
              child: Text(
                'Share',
                style: TextStyle(color: actionColor),
              ),
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
