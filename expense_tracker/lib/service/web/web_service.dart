import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'web_service_impl.dart';

class WebService {
  static void downloadBlobData(List<int> bytes, String fileName) {
    if (kIsWeb) {
      WebServiceImpl.downloadBlobData(bytes, fileName);
    }
  }

  static Uint8List? getFileBytes(PlatformFile file) {
      return WebServiceImpl.getFileBytes(file);
  }
}
