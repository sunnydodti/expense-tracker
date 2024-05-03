class FileConstants {
  static ExportConstants export = ExportConstants();
  static CacheConstants cache = CacheConstants();
}

class ExportConstants {
  final String folder = "export";

  final String zip = "export_et_{0}.zip";
  final String extension = ".zip";
  final String expenses = "expenses.json";
  final String expenseItems = "expenseItems.json";
  final String categories = "categories.json";
  final String tags = "tags.json";
  final String version = "version.json";
}

class CacheConstants {
  final String json = "json";
}
