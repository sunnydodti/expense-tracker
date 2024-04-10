import '../data/constants/db_constants.dart';

class Expense {
  int id;
  String title;
  String currency;
  double amount;
  String transactionType;
  DateTime date;
  String category;
  String? tags;
  String? note;

  List<Expense>? expenses;
  DateTime createdAt;
  DateTime modifiedAt;

  Expense(this.id, this.title, this.currency, this.amount, this.transactionType,
      this.date, this.category, this.createdAt, this.modifiedAt,
      [this.tags, this.note, this.expenses]);

  // Methods
  //  // Expense Object to map
  // Getter for the Map representation
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};
    map[DBConstants.expense.id] = id;
    map[DBConstants.expense.title] = title;
    map[DBConstants.expense.currency] = currency;
    map[DBConstants.expense.amount] = amount;
    map[DBConstants.expense.transactionType] = transactionType;
    map[DBConstants.expense.date] = date.toIso8601String();
    map[DBConstants.expense.category] = category;
    map[DBConstants.expense.tags] = tags;
    map[DBConstants.expense.note] = note;
    map[DBConstants.expense.expenses] =
        expenses?.map((expense) => expense.toMap()).toList();
    map[DBConstants.expense.createdAt] = createdAt;
    map[DBConstants.expense.modifiedAt] = modifiedAt;
    return map;
  }

  static List<Expense> fromMapList(List<Map<String, dynamic>> expenseMapList) {
    return expenseMapList.isEmpty
        ? []
        : expenseMapList
            .map((expenseMap) => Expense.fromMap(expenseMap))
            .toList();
  }

  //  // map to Expense Object
  static Expense fromMap(Map<String, dynamic> map) {
    Expense expense = Expense(
        map[DBConstants.expense.id],
        map[DBConstants.expense.title],
        map[DBConstants.expense.currency],
        map[DBConstants.expense.amount],
        map[DBConstants.expense.transactionType],
        DateTime.parse(map[DBConstants.expense.date]),
        map[DBConstants.expense.category],
        DateTime.parse(map[DBConstants.expense.createdAt]),
        DateTime.parse(map[DBConstants.expense.modifiedAt]));

    expense.id = map[DBConstants.expense.id];
    expense.tags = map[DBConstants.expense.tags];
    // expense.tag = map[DBExpenseTableConstants.tag];
    expense.note = map[DBConstants.expense.note];
    // expense.containsNestedExpenses = _parseIntAsBool(map[DBExpenseTableConstants.containsNestedExpenses]!);
    expense.createdAt = DateTime.parse(map[DBConstants.expense.createdAt]);
    expense.modifiedAt = DateTime.parse(map[DBConstants.expense.modifiedAt]);
    return expense;
  }

  static bool _parseIntAsBool(int value) {
    return value != 0;
  }
}

class ExpenseFormModel {
  int? id;
  String title;
  String currency;
  double amount;
  String transactionType;
  DateTime date;
  String category;
  bool containsNestedExpenses;
  String? tags;
  String? note;
  List<ExpenseFormModel>? expenses;
  DateTime? createdAt;
  DateTime? modifiedAt;

  ExpenseFormModel(this.title, this.currency, this.amount, this.transactionType,
      this.date, this.category, this.containsNestedExpenses,
      [this.tags, this.note, this.expenses]);

  ExpenseFormModel.withId(
      this.id,
      this.title,
      this.currency,
      this.amount,
      this.transactionType,
      this.date,
      this.category,
      this.containsNestedExpenses,
      [this.tags,
      this.note,
      this.expenses]);

  // Methods
  //  // Expense Object to map
  // Getter for the Map representation
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};
    if (id != null) map[DBConstants.expense.id] = id;
    map[DBConstants.expense.title] = title;
    map[DBConstants.expense.currency] = currency;
    map[DBConstants.expense.amount] = amount;
    map[DBConstants.expense.transactionType] = transactionType;
    map[DBConstants.expense.date] = date.toIso8601String();
    map[DBConstants.expense.category] = category;
    map[DBConstants.expense.tags] = tags;
    map[DBConstants.expense.note] = note;
    map[DBConstants.expense.containsNestedExpenses] = containsNestedExpenses;
    map[DBConstants.expense.expenses] =
        expenses?.map((expense) => expense.toMap()).toList();
    return map;
  }

  //  // map to Expense Object
  ExpenseFormModel.fromMap(Map<String, dynamic> map)
      : id = map[DBConstants.expense.id],
        title = map[DBConstants.expense.title],
        currency = map[DBConstants.expense.currency],
        amount = map[DBConstants.expense.amount],
        transactionType = map[DBConstants.expense.transactionType],
        date = DateTime.parse(map[DBConstants.expense.date]),
        category = map[DBConstants.expense.category],
        // tags = map[DBExpenseTableConstants.Tags]?.cast<String>(),
        tags = map[DBConstants.expense.tags],
        note = map[DBConstants.expense.note],
        containsNestedExpenses =
            map[DBConstants.expense.containsNestedExpenses],
        createdAt = map[DBConstants.expense.createdAt],
        modifiedAt = map[DBConstants.expense.modifiedAt],
        expenses =
            (map[DBConstants.expense.expenses] as List<Map<String, dynamic>>?)
                ?.map((expenseMap) => ExpenseFormModel.fromMap(expenseMap))
                .toList();
}
