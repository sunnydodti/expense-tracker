class ImportResult {
  bool result = false;
  String message = "Unable to import file";
  String? path;

  ImportExpenseResult expense = ImportExpenseResult();
  ImportCategoriesResult category = ImportCategoriesResult();
  ImportTagResult tag = ImportTagResult();

  ImportResult();

  String? get outputPath => path!.substring('/storage/emulated/0'.length);
}

class ImportExpenseResult {
  int total = 0;
  int successCount = 0;

  int get failCount => total - successCount;
}

class ImportCategoriesResult {
  int total = 0;
  int successCount = 0;

  int get failCount => total - successCount;
}

class ImportTagResult {
  int total = 0;
  int successCount = 0;

  int get failCount => total - successCount;
}
