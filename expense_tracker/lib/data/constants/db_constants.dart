class DBConstants {
  static String databaseName = "expense_tracker";

  static ExpenseConstants expense = ExpenseConstants();
  static ExpenseItemConstants expenseItem = ExpenseItemConstants();
  static CategoryConstants category = CategoryConstants();
  static TagConstants tag = TagConstants();
}

class ExpenseConstants {
  final String table = "expenses";
  final String triggerModifiedAt = "update_modified_at_expenses";

  final String id = "id";
  final String title = "title";
  final String currency = "currency";
  final String amount = "amount";
  final String transactionType = "transaction_type";
  final String date = "date";
  final String category = "category";
  final String tags = "tags";
  final String tag = "tag";
  final String note = "note";
  final String containsNestedExpenses = "contains_nested_expenses";
  final String expenses = "expenses";

  final String createdAt = "created_at";
  final String modifiedAt = "modified_at";
}

class ExpenseItemConstants {
  final String table = "expense_items";
  final String triggerModifiedAt = "update_modified_at_expense_items";

  final String id = "id";
  final String expenseId = "expense_id";
  final String name = "name";
  final String amount = "amount";

  final String createdAt = "created_at";
  final String modifiedAt = "modified_at";
}

class CategoryConstants {
  final String table = "categories";
  final String triggerModifiedAt = "update_modified_at_categories";

  final String id = "id";
  final String name = "name";

  final String createdAt = "created_at";
  final String modifiedAt = "modified_at";
}

class TagConstants {
  final String table = "tags";
  final String triggerModifiedAt = "update_modified_at_tags";

  final String id = "id";
  final String name = "name";

  final String createdAt = "created_at";
  final String modifiedAt = "modified_at";
}

class CurrencyConstants {
  final String table = "currencies";

  final String id = "id";
  final String name = "name";
  final String symbol = "symbol";
  final String country = "country";

  final String createdAt = "created_at";
  final String modifiedAt = "modified_at";
}

class TransactionTypeConstants {
  final String table = "transaction_types";

  final String id = "id";
  final String type = "type";

  final String createdAt = "created_at";
  final String modifiedAt = "modified_at";
}
