import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class ExportResult {
  bool result = false;
  String message = "unable to export";
  String? path;

  ExportResult();

  String? get _androidPath =>
      path != null && path!.startsWith('/storage/emulated/0')
          ? path!.substring('/storage/emulated/0'.length)
          : path;

  String? get _iosPath => path;

  String? get _desktopPath => path;

  String? get _webPath => path;

  String? get outputPath {
    if (path == null) return null;

    if (kIsWeb) return _webPath;
    if (Platform.isAndroid) return _androidPath;
    if (Platform.isIOS) return _iosPath;

    return _desktopPath;
  }
}
