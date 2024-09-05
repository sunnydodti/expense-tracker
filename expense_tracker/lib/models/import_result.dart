class ImportResult {
  bool result = false;
  String message = "Unable to import file";
  String? path;

  ImportExpenseResult expense = ImportExpenseResult();
  ImportExpenseItemsResult expenseItems = ImportExpenseItemsResult();
  ImportCategoriesResult category = ImportCategoriesResult();
  ImportTagResult tag = ImportTagResult();
  ImportUserResult user = ImportUserResult();
  ImportProfileResult profile = ImportProfileResult();

  ImportResult();

  String? get outputPath => path!.substring('/storage/emulated/0'.length);
}

class ImportResultBase {
  int total = 0;
  int successCount = 0;

  int get failCount => total - successCount;
}

class ImportExpenseResult extends ImportResultBase {}

class ImportExpenseItemsResult extends ImportResultBase {}

class ImportCategoriesResult extends ImportResultBase {}

class ImportTagResult extends ImportResultBase {}

class ImportUserResult extends ImportResultBase {}

class ImportProfileResult extends ImportResultBase {}
