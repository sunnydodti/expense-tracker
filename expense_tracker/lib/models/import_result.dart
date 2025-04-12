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

  String importSuccessMessage() {
    String message = "Import complete";

    if (expense.total > 0) {
      message += "\nExpenses:        ${expense.successCount}/${expense.total}";
    }
    if (expenseItems.total > 0) {
      message +=
          "\nExpenseItems:    ${expenseItems.successCount}/${expenseItems.total}";
    }
    if (category.total > 0) {
      message +=
          "\nCategories:      ${category.successCount}/${category.total}";
    }
    if (tag.total > 0) {
      message += "\nTags:             ${tag.successCount}/${tag.total}";
    }
    if (user.total > 0) {
      message += "\nUsers:           ${user.successCount}/${user.total}";
    }
    if (profile.total > 0) {
      message += "\nProfiles:        ${profile.successCount}/${profile.total}";
    }
    return message;
  }
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
