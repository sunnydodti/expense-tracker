class DBConstants {
  static String databaseName = "expense_tracker.db";
  static int databaseVersion = 4;

  static DatabaseVersionConstants version = DatabaseVersionConstants();

  static CommonConstants common = CommonConstants();
  static ExpenseConstants expense = ExpenseConstants();
  static ExpenseItemConstants expenseItem = ExpenseItemConstants();
  static CategoryConstants category = CategoryConstants();
  static TagConstants tag = TagConstants();
  static UserConstants user = UserConstants();
  static ProfileConstants profile = ProfileConstants();
  static SearchConstants search = SearchConstants();
}

class CommonConstants {
  final String createdAt = "created_at";
  final String modifiedAt = "modified_at";
  static String id = "id";
}

class ExpenseConstants {
  final String table = "expenses";
  final String triggerModifiedAt = "update_modified_at_expenses";

  final String id = CommonConstants.id;
  final String title = "title";
  final String currency = "currency";
  final String amount = "amount";
  final String transactionType = "transaction_type";
  final String date = "date";
  final String category = "category";
  final String tags = "tags";
  final String note = "note";
  final String containsNestedExpenses = "contains_nested_expenses"; // dropped
  final String containsExpenseItems = "contains_expense_items";
  final String expenses = "expenses"; // dropped
  final String profileId = "profile_id";
  final String userId = "user_id";
}

class ExpenseItemConstants {
  final String table = "expense_items";
  final String triggerModifiedAt = "update_modified_at_expense_items";

  final String id = CommonConstants.id;
  final String expenseId = "expense_id";
  final String name = "name";
  final String amount = "amount";
  final String quantity = "quantity";
}

class CategoryConstants {
  final String table = "categories";
  final String triggerModifiedAt = "update_modified_at_categories";

  final String id = CommonConstants.id;
  final String name = "name";
}

class TagConstants {
  final String table = "tags";
  final String triggerModifiedAt = "update_modified_at_tags";

  final String id = CommonConstants.id;
  final String name = "name";
}

class CurrencyConstants {
  final String table = "currencies";

  final String id = CommonConstants.id;
  final String name = "name";
  final String symbol = "symbol";
  final String country = "country";
}

class TransactionTypeConstants {
  final String table = "transaction_types";

  final String id = CommonConstants.id;
  final String type = "type";
}

class DatabaseVersionConstants {
  final String databaseVersionKey = "database_version";
  final int databaseVersion = 3;
  final String appVersionKey = "app_version";
  final String appVersion = "0.0.9";
  final String createdAt = "created_at";
}

class UserConstants {
  final String table = "users";
  final String triggerModifiedAt = "update_modified_at_users";

  final String id = CommonConstants.id;
  final String name = "name";
  final String userName = "user_name";
  final String email = "email";
}

class ProfileConstants {
  final String table = "profiles";
  final String triggerModifiedAt = "update_modified_at_profiles";

  final String id = CommonConstants.id;
  final String name = "name";
}

class SearchConstants {
  final String table = "search";
  final String triggerModifiedAt = "update_modified_at_search";

  final String id = CommonConstants.id;
  final String title = "name";
  final String amount = "amount";
  final String profileId = "profile_id";
}
