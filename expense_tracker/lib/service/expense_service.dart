import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../data/constants/db_constants.dart';
import '../data/database/database_helper.dart';
import '../data/database/expense_helper.dart';
import '../models/expense.dart';

class ExpenseService {
  late final ExpenseHelper _expenseHelper;
  static final Logger _logger =
      Logger(printer: SimplePrinter(), level: Level.info);

  ExpenseService._(this._expenseHelper);

  static Future<ExpenseService> create() async {
    final databaseHelper = DatabaseHelper();
    await databaseHelper.initializeDatabase();
    final expenseHelper = await databaseHelper.expenseHelper;
    return ExpenseService._(expenseHelper);
  }

  Future<bool> addExpense(ExpenseFormModel expense) async {
    try {
      int id = await _expenseHelper.addExpense(expense.toMap());
      return id > 0 ? true : false;
    } on Exception catch (e) {
      _logger.e("Error adding expense (${expense.title}): $e");
      return false;
    }
  }

  Future<bool> updateExpense(ExpenseFormModel expense) async {
    try {
      int result = await _expenseHelper.updateExpense(expense);
      return result > 0 ? true : false;
    } on Exception catch (e) {
      _logger.e("Error updating expense (${expense.title}): $e");
      return false;
    }
  }

  Future<List<Expense>> fetchExpenses() async {
    List<Map<String, dynamic>> expenseMapList =
        await _expenseHelper.getExpenses();
    return expenseMapList
        .map((expenseMap) => Expense.fromMap(expenseMap))
        .toList();
  }

  Future<List<Map<String, dynamic>>> fetchExpenseMaps() async {
    try {
      return await _expenseHelper.getExpenses();
    } on Exception catch (e) {
      _logger.e("Error getting expenses: $e");
      return [];
    }
  }

  Future<int> deleteAllExpenses() async {
    try {
      return _expenseHelper.deleteAllExpenses();
    } on Exception catch (e) {
      _logger.e("Error deleting expenses: $e");
      return -1;
    }
  }

  Future<void> populateExpense({int count = 1}) async {
    try {
      List<Map<String, dynamic>> expenseMapList = [];
      for (int i = 0; i <= count - 1; i++) {
        var expense = generateRandomExpense();
        expenseMapList.add(expense);
      }
      await _expenseHelper.populateExpense(
        expenseMapList,
      );
    } on Exception catch (e) {
      _logger.e("Error populating expense: $e");
    }
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

  Future<bool> importExpense(Map<String, dynamic> expense) async {
    try {
      if (await _expenseHelper.addExpense(expense) > 0) return true;
    } on Exception catch (e) {
      _logger.e(
          "Error importing expense (${expense[DBConstants.expense.title]}): $e");
    }
    return false;
  }

  /// sorting and filtering
  List<Expense> sortAndFilter<T>(List<Expense> data,
      {String sortBy = "date", bool ascending = false}) {
    // final filterFunction = (item) => item['price'] > 10; // Filter based on price

    // final filteredData = data.where((item) => filterFunction(item)).toList();

    final sortedByDate = data.toList();

    if (sortBy == DBConstants.expense.date) {
      sortedByDate.sort((a, b) {
        final compareValue = a.date.compareTo(b.date);
        return compareValue * (ascending ? 1 : -1);
      });
    }

    if (sortBy == DBConstants.expense.modifiedAt) {
      sortedByDate.sort((a, b) {
        final compareValue = a.modifiedAt.compareTo(b.modifiedAt);
        return compareValue * (ascending ? 1 : -1);
      });
    }
    return sortedByDate;
  }
}
