import 'package:expense_tracker/data/db_constants/DBExpenseTableConstants.dart';
import 'package:expense_tracker/models/transaction_type.dart';

class ExpenseOld {
  // create id, date, date, category, list of tags, note, amount, currency, containsNestedExpenses, expenses[list of expenses<Expense>]
  String? id; // required
  String? title; // required
  String? currency; // required
  double? amount; // required
  TransactionType? transactionType; // required
  DateTime? date; // required
  String? category; // required
  List<String>? tags;
  String? note;
  bool? containsNestedExpenses; // required
  List<ExpenseOld>? expenses;

  ExpenseOld.empty();

  // create a constructor that will take in all the above parameters
  ExpenseOld.full({
    required this.id,
    required this.title,
    required this.currency,
    required this.amount,
    required this.transactionType,
    required this.category,
    required this.tags,
    required this.date,
    required this.note,
    required this.containsNestedExpenses,
    required this.expenses,
  });

  ExpenseOld.minimal({
    required this.id,
    required this.title,
    required this.currency,
    required this.amount,
    required this.transactionType,
    required this.category,
    required this.date,
    required this.containsNestedExpenses,
  });

  // create a method that will return a map of the expense
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'currency': currency,
      'amount': amount,
      'transactionType': transactionType,
      'category': category,
      'tags': tags,
      'date': date,
      'note': note,
      'containsNestedExpenses': containsNestedExpenses,
      'expenses': expenses,
    };
  }

  // create a method that will return a expense from a map
  factory ExpenseOld.fromMap(Map<String, dynamic> map) {
    return ExpenseOld.full(
      id: map['id'],
      title: map['title'],
      currency: map['currency'],
      amount: map['amount'],
      transactionType: map['transactionType'],
      category: map['category'],
      tags: map['label'],
      date: map['date'],
      note: map['note'],
      containsNestedExpenses: map['containsNestedExpenses'],
      expenses: map['expenses'],
    );
  }

  // create getters and setters for all the above parameters
  String? getId() {
    return id;
  }

  void setId(String id) {
    this.id = id;
  }

  String? getTitle() {
    return title;
  }

  void setTitle(String title) {
    this.title = title;
  }

  DateTime? getDate() {
    return date;
  }

  void setDate(DateTime date) {
    this.date = date;
  }

  String? getCategory() {
    return category;
  }

  void setCategory(String category) {
    this.category = category;
  }

  List<String>? getLabel() {
    return tags;
  }

  void setLabel(List<String> tags) {
    this.tags = tags;
  }

  String? getNote() {
    return note;
  }

  void setNote(String note) {
    this.note = note;
  }

  double? getAmount() {
    return amount;
  }

  void setAmount(double amount) {
    this.amount = amount;
  }

  String? getCurrency() {
    return currency;
  }

  void setCurrency(String currency) {
    this.currency = currency;
  }

  bool? getContainsNestedExpenses() {
    return containsNestedExpenses;
  }

  void setContainsNestedExpenses(bool containsNestedExpenses) {
    this.containsNestedExpenses = containsNestedExpenses;
  }

  List<ExpenseOld>? getExpenses() {
    return expenses;
  }

  void setExpenses(List<ExpenseOld> expenses) {
    this.expenses = expenses;
  }

  TransactionType? getTransactionType() {
    return transactionType;
  }

  void setTransactionType(TransactionType transactionType) {
    this.transactionType = transactionType;
  }

  // create a method that will return a string representation of the expense
  @override
  String toString() {
    return 'Expense{id: $id, currency: $currency, amount: $amount, transactionType: $transactionType, category: $category, label: $tags, date: $date, note: $note, containsNestedExpenses: $containsNestedExpenses, expenses: $expenses}';
  }

  //create a methods to add and remove expenses from the list of expenses
  void addExpense(ExpenseOld expense) {
    expenses?.add(expense);
  }

  bool removeExpense(ExpenseOld expense) {
    return expenses!.remove(expense);
  }

  //create a methods to add and remove tags from the list of tags
  void addLabel(String label) {
    tags!.add(label);
  }

  bool removeLabel(String label) {
    return tags!.remove(label);
  }

  // create a method that will return the total amount of the expense
  double getTotalAmount() {
    double total = 0;
    for (ExpenseOld expense in expenses!) {
      total += expense.getTotalAmount();
    }
    return total + amount!;
  }
}

class ExpenseV2 {
  int id;
  String title;
  String currency;
  double amount;
  String transactionType;
  DateTime date;
  String category;
  List<String>? tags;
  String? tag;
  String? note;
  bool? containsNestedExpenses;
  List<ExpenseV2>? expenses;

  DateTime createdAt;
  DateTime modifiedAt;

  ExpenseV2({
    required this.id,
    required this.title,
    required this.currency,
    required this.amount,
    required this.transactionType,
    required this.date,
    required this.category,
    required this.createdAt,
    required this.modifiedAt,
    this.tags,
    this.tag,
    this.note,
    containsNestedExpenses,
    expenses,
  }){
   this.expenses =  expenses ?? List.empty(growable: true);
   this.containsNestedExpenses = containsNestedExpenses ?? false;
  }

  factory ExpenseV2.fromMap(Map<String, dynamic> map) {
    return ExpenseV2(
      id: map[DBExpenseTableConstants.id],
      title: map[DBExpenseTableConstants.title],
      currency: map[DBExpenseTableConstants.currency],
      amount: map[DBExpenseTableConstants.amount],
      transactionType: map[DBExpenseTableConstants.transactionType],
      date: DateTime.parse(map[DBExpenseTableConstants.date]),
      category: map[DBExpenseTableConstants.category],
      tags: List<String>.from(map[DBExpenseTableConstants.tags]),
      tag: map[DBExpenseTableConstants.tag],
      note: map[DBExpenseTableConstants.note],
      containsNestedExpenses: map[DBExpenseTableConstants.containsNestedExpenses] ?? false,
      expenses: map[DBExpenseTableConstants.expenses] != null ? List<ExpenseV2>.from(map[DBExpenseTableConstants.expenses].map((x) => ExpenseV2.fromMap(x))) : List.empty(growable: true),
      createdAt: DateTime.parse(map[DBExpenseTableConstants.createdAt]),
      modifiedAt: DateTime.parse(map[DBExpenseTableConstants.modifiedAt]),
    );
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

  ExpenseFormModel(
      this.title,
      this.currency,
      this.amount,
      this.transactionType,
      this.date,
      this.category,
      this.containsNestedExpenses,
      [this.tags, this.note, this.expenses]
      );

  // Expense.empty();

  ExpenseFormModel.withId(
      this.id,
      this.title,
      this.currency,
      this.amount,
      this.transactionType,
      this.date,
      this.category,
      this.containsNestedExpenses,
      [this.tags, this.note, this.expenses]
      );

  // Methods
  //  // Expense Object to map
  // Getter for the Map representation
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};
    if (id != null) map[DBExpenseTableConstants.id] = id;
    map[DBExpenseTableConstants.title] = title;
    map[DBExpenseTableConstants.currency] = currency;
    map[DBExpenseTableConstants.amount] = amount;
    map[DBExpenseTableConstants.transactionType] = transactionType;
    map[DBExpenseTableConstants.date] = date.toIso8601String();
    map[DBExpenseTableConstants.category] = category;
    map[DBExpenseTableConstants.tags] = tags;
    map[DBExpenseTableConstants.note] = note;
    map[DBExpenseTableConstants.containsNestedExpenses] = containsNestedExpenses;
    map[DBExpenseTableConstants.expenses] = expenses?.map((expense) => expense.toMap()).toList();
    map[DBExpenseTableConstants.createdAt] = createdAt!.toIso8601String();
    map[DBExpenseTableConstants.modifiedAt] = modifiedAt!.toIso8601String();
    return map;
  }

  //  // map to Expense Object
  ExpenseFormModel.fromMap(Map<String, dynamic> map)
      : id = map[DBExpenseTableConstants.id],
        title = map[DBExpenseTableConstants.title],
        currency = map[DBExpenseTableConstants.currency],
        amount = map[DBExpenseTableConstants.amount],
        transactionType = map[DBExpenseTableConstants.transactionType],
        date = DateTime.parse(map[DBExpenseTableConstants.date]),
        category = map[DBExpenseTableConstants.category],
  // tags = map[DBExpenseTableConstants.Tags]?.cast<String>(),
        tags = map[DBExpenseTableConstants.tags],
        note = map[DBExpenseTableConstants.note],
        containsNestedExpenses = map[DBExpenseTableConstants.containsNestedExpenses],
        createdAt = map[DBExpenseTableConstants.createdAt],
        modifiedAt = map[DBExpenseTableConstants.modifiedAt],
        expenses = (map[DBExpenseTableConstants.expenses] as List<Map<String, dynamic>>?)
            ?.map((expenseMap) => ExpenseFormModel.fromMap(expenseMap))
            .toList();

}

