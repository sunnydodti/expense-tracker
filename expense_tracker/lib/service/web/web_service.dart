import 'package:flutter/foundation.dart' show kIsWeb;
import 'web_service_impl.dart';

/// Service for web-specific functionality
class WebService {
  /// Downloads data as a file in web browser
  /// No-op on non-web platforms
  static void downloadBlobData(List<int> bytes, String fileName) {
    if (kIsWeb) {
      WebServiceImpl.downloadBlobData(bytes, fileName);
    }
  }
}