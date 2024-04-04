class DBConstants {
  /// Expense
  static ExpenseConstants expense = ExpenseConstants();
}

class ExpenseConstants {
  final String table = "expense_table";

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

class CategoryConstants {
  final String table = "categories";

  final String id = "id";
  final String name = "name";
}

class TagConstants {
  final String table = "tags";

  final String id = "id";
  final String name = "name";
}

class CurrencyConstants {
  final String table = "currencies";

  final String id = "id";
  final String name = "name";
  final String symbol = "symbol";
  final String country = "country";
}

class TransactionTypeConstants {
  final String table = "transaction_types";

  final String id = "id";
  final String type = "type";
}
