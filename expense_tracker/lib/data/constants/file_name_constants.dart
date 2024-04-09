import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileConstants {
  static ExportedFileConstants export = ExportedFileConstants();

  static Future<String> exportFilePath() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
}

class ExportedFileConstants {
  final String zip = "expense_tracker_{0}.zip";
  final String expenses = "expenses.json";
  final String categories = "categories.json";
  final String tags = "tags.json";
}
