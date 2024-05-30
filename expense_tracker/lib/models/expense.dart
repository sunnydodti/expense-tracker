import 'package:intl/intl.dart';

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
  bool containsExpenseItems;

  DateTime createdAt;
  DateTime modifiedAt;

  Expense(
      this.id,
      this.title,
      this.currency,
      this.amount,
      this.transactionType,
      this.date,
      this.category,
      this.containsExpenseItems,
      this.createdAt,
      this.modifiedAt,
      [this.tags,
      this.note]);

  // Methods
  // Expense Object to map
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
    map[DBConstants.expense.containsExpenseItems] =
        _parseBoolAsInt(containsExpenseItems);
    map[DBConstants.common.createdAt] = createdAt;
    map[DBConstants.common.modifiedAt] = modifiedAt;
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
        _parseIntAsBool(map[DBConstants.expense.containsExpenseItems]),
        DateTime.parse(map[DBConstants.common.createdAt]),
        DateTime.parse(map[DBConstants.common.modifiedAt]));

    expense.tags = map[DBConstants.expense.tags];
    expense.note = map[DBConstants.expense.note];
    return expense;
  }

  String shareData() {
    String sharedData = "";
    sharedData += "Title                   \t\t: $title\n";
    sharedData += "Amount               \t: $amount\n";
    sharedData += "Transaction Type  \t\t: $transactionType\n";
    sharedData +=
        "Date                   \t: ${DateFormat('dd-MM-yy').format(date)}\n";
    sharedData += "Category             \t\t: $category\n";
    if (note != null) {
      sharedData += "Tags                    \t: $tags\n";
    }
    if (note != null) {
      sharedData += "Note                   \t: $note\n";
    }
    return sharedData;
  }

  String shareDataV2() {
    String sharedData = '''
Title: $title
Amount: $amount
Transaction Type: $transactionType
Date: ${DateFormat('dd-MM-yy').format(date)}
Category: $category''';
    if (tags != null) {
      sharedData += '\nTags: $tags';
    }
    if (note != null) {
      sharedData += '\nNote: $note';
    }
    return sharedData;
  }
}

bool _parseIntAsBool(int value) {
  return value != 0;
}

int _parseBoolAsInt(bool value) {
  return value ? 1 : 0;
}

class ExpenseFormModel {
  int? id;
  String title;
  String currency;
  double amount;
  String transactionType;
  DateTime date;
  String category;
  String? tags;
  String? note;
  bool containsExpenseItems;
  DateTime? createdAt;
  DateTime? modifiedAt;

  ExpenseFormModel(
    this.title,
    this.currency,
    this.amount,
    this.transactionType,
    this.date,
    this.category,
    this.containsExpenseItems, [
    this.tags,
    this.note,
  ]);

  ExpenseFormModel.withId(this.id, this.title, this.currency, this.amount,
      this.transactionType, this.date, this.category, this.containsExpenseItems,
      [this.tags, this.note]);

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
    map[DBConstants.expense.containsExpenseItems] =
        _parseBoolAsInt(containsExpenseItems);

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
        tags = map[DBConstants.expense.tags],
        note = map[DBConstants.expense.note],
        containsExpenseItems =
            _parseIntAsBool(map[DBConstants.expense.containsExpenseItems]),
        createdAt = map[DBConstants.common.createdAt],
        modifiedAt = map[DBConstants.common.modifiedAt];
}
