import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show Uint8List;

class WebServiceImpl {
  static void downloadBlobData(List<int> bytes, String fileName) {}

  static Uint8List? getFileBytes(PlatformFile importFile) {
    final file = File(importFile.path!);
    if (file.existsSync()) {
      return file.readAsBytesSync();
    } else {
      return null;
    }
  }
}
