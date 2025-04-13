import 'dart:html';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

/// Web-specific implementation of WebServiceImpl
class WebServiceImpl {
  /// Downloads binary data as a file in the browser
  static void downloadBlobData(List<int> bytes, String fileName) {
    final blob = Blob([bytes]);
    final url = Url.createObjectUrlFromBlob(blob);
    final anchor = AnchorElement(href: url);
    anchor.setAttribute('download', fileName);
    anchor.click();
    Url.revokeObjectUrl(url);
  }

  static Uint8List? getFileBytes(PlatformFile importFile) {
    return importFile.bytes;
  }
}