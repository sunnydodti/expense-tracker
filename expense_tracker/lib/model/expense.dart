import 'package:expense_tracker/model/transaction_type.dart';

class Expense {
  // create id, date, date, category, list of tags, note, amount, currency, containsNestedExpenses, expenses[list of expenses<Expense>]
  String? id; // required
  String? currency; // required
  double? amount; // required
  TransactionType? transactionType; // required
  String? category; // required
  List<String>? tags;
  DateTime? date; // required
  String? note;
  bool? containsNestedExpenses; // required
  List<Expense>? expenses;

  Expense.empty();

  // create a constructor that will take in all the above parameters
  Expense.full({
    required this.id,
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

  Expense.minimal({
    required this.id,
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
  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense.full(
      id: map['id'],
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

  List<Expense>? getExpenses() {
    return expenses;
  }

  void setExpenses(List<Expense> expenses) {
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
  void addExpense(Expense expense) {
    expenses?.add(expense);
  }

  bool removeExpense(Expense expense) {
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
    for (Expense expense in expenses!) {
      total += expense.getTotalAmount();
    }
    return total + amount!;
  }
}
