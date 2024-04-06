import 'package:faker/faker.dart';

import '../data/constants/DBConstants.dart';
import '../data/database/database_helper.dart';
import '../data/database/expense_helper.dart';
import '../models/expense.dart';

class ExpenseService {
  late final DatabaseHelper _databaseHelper;
  late final ExpenseHelper _expenseHelper;

  ExpenseService._(this._databaseHelper, this._expenseHelper);

  static Future<ExpenseService> create() async {
    final databaseHelper = DatabaseHelper();
    await databaseHelper.initializeDatabase();
    final expenseHelper = await databaseHelper.expenseHelper;
    return ExpenseService._(databaseHelper, expenseHelper);
  }

  Future<bool> addExpense(ExpenseFormModel expense) async {
    expense.createdAt ??= DateTime.now();
    expense.modifiedAt ??= DateTime.now();
    int id = await _expenseHelper.addExpense(expense.toMap());
    return id > 0 ? true : false;
  }

  Future<bool> updateExpense(ExpenseFormModel expense) async {
    expense.modifiedAt ??= DateTime.now();
    int result = await _expenseHelper.updateExpense(expense);
    return result > 0 ? true : false;
  }

  Future<List<Expense>> fetchExpenses() async {
    List<Map<String, dynamic>> expenseMapList = await _expenseHelper.getExpenses();
    return expenseMapList
        .map((expenseMap) => Expense.fromMap(expenseMap))
        .toList();
  }
  Future<List<Map<String, dynamic>>> fetchExpenseMaps() async {
    return await _expenseHelper.getExpenses();
  }

  Future<int> deleteAllExpenses() async {
    return _expenseHelper.deleteAllExpenses();
  }

  Future<void> populateDatabase({int count = 1}) async {
    List<Map<String, dynamic>> expenseMapList = [];
    for (int i = 0; i <= count-1; i++) {
      var expense = generateRandomExpense();
      expenseMapList.add(expense);
    }
    await _expenseHelper.populateDatabase(
      expenseMapList,
    );
  }

  Map<String, dynamic> generateRandomExpense() {
    double amount = faker.randomGenerator.decimal() * (1000.0 - 1.0) + 1.0;
    var expense = {
      DBConstants.expense.title: faker.food.dish(),
      DBConstants.expense.currency: "INR",
      DBConstants.expense.amount: double.parse(amount.toStringAsFixed(2)),
      DBConstants.expense.transactionType:
      faker.randomGenerator.boolean() ? 'income' : 'expense',
      DBConstants.expense.date: faker.date.dateTime().toIso8601String(),
      DBConstants.expense.category:
      faker.randomGenerator.boolean() ? 'Food' : 'Shopping',
      DBConstants.expense.tags:
      faker.randomGenerator.boolean() ? 'home' : 'work',
      DBConstants.expense.note: faker.lorem.sentence(),
      DBConstants.expense.containsNestedExpenses:
      faker.randomGenerator.boolean() ? 1 : 0,
      DBConstants.expense.expenses: 'Nested expenses data',
      // Add appropriate nested expenses data
      DBConstants.expense.createdAt: faker.date.dateTime().toIso8601String(),
      DBConstants.expense.modifiedAt: faker.date.dateTime().toIso8601String(),
    };
    return expense;
  }
}
