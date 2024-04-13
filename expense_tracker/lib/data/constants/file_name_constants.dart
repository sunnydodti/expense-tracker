import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileConstants {
  static ExportConstants export = ExportConstants();
  static CacheConstants cache = CacheConstants();
}

class ExportConstants {
  final String folder = "export";

  final String zip = "expense_tracker_{0}.zip";
  final String expenses = "expenses.json";
  final String categories = "categories.json";
  final String tags = "tags.json";
}

class CacheConstants {
  final String json = "json";

  // final String tags = "tags.json";
}
