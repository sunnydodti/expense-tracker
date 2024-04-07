import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileConstants {
  static const String exportedFileName = "expense_tracker_{0}.json";

  static Future<String> exportFilePath() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
}
