import 'package:flutter/material.dart';
import 'package:share/share.dart';

class ShareFileDialog {
  static Future<void> show(BuildContext context,
      {String title = 'Share File',
      String content = 'Do you want to share this file?',
      required String filePath,
      bool showFileName = false}) async {
    final fileName = _extractFileName(filePath);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title.toString()),
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
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Share.shareFiles([filePath]);
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
            child: const Text('Share'),
          ),
        ],
      ),
    );
  }

  static String _extractFileName(String filePath) {
    final lastIndex = filePath.lastIndexOf('/');
    return filePath.substring(lastIndex + 1);
  }
}
