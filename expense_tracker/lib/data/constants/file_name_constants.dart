import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileConstants {
  static ExportedFileConstants export = ExportedFileConstants();
}

class ExportedFileConstants {
  final String zip = "expense_tracker_{0}.zip";
  final String expenses = "expenses.json";
  final String categories = "categories.json";
  final String tags = "tags.json";

  Future<String> filePath() async {
    final Directory? directory = await getExternalStorageDirectory();
    return directory!.path;
  }
}
