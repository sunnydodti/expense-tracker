import 'package:expense_tracker/data/constants/DBConstants.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class ExpenseHelper {
  final Database _database;

  ExpenseHelper(this._database);

  Database get getDatabase => _database;

  Future<void> createTable(Database db) async {
    await db.execute(
      'CREATE TABLE expenses(id INTEGER PRIMARY KEY, ...)',
    );
  }

  // CRUD operations
  // CREATE
  Future<int> addExpense(ExpenseFormModel expense) async {
    expense.createdAt ??= DateTime.now();
    expense.modifiedAt ??= DateTime.now();
    debugPrint("inserting");
    debugPrint(expense.toMap().toString());
    Database database = getDatabase;
    return await database.insert(
      DBConstants.expense.table,
      expense.toMap(),
    );
  }

  // READ
  Future<List<Expense>> getExpenses() async {
    Database database = getDatabase;
    final List<Map<String, dynamic>> expenseMaps =
    await database.query(DBConstants.expense.table);
    return expenseMaps
        .map((expenseMap) => Expense.fromMap(expenseMap))
        .toList();
  }

  // UPDATE
  Future<int> updateExpense(ExpenseFormModel expense) async {
    expense.modifiedAt ??= DateTime.now();
    debugPrint("updating");
    debugPrint(expense.toMap().toString());
    Database database = getDatabase;
    return database.update(
      DBConstants.expense.table,
      expense.toMap(),
      where: '${DBConstants.expense.id} = ?',
      whereArgs: [expense.id],
    );
  }

  Future<int> updateExpenseV2(ExpenseFormModel expense) async {
    expense.modifiedAt ??= DateTime.now();
    debugPrint("updating");
    debugPrint(expense.toMap().toString());
    Database database = getDatabase;
    return database.rawUpdate('''
      UPDATE ${DBConstants.expense.table}
      SET ${DBConstants.expense.amount} = ?
      WHERE ${DBConstants.expense.id} = ? 
      ''',[
      expense.amount,
      expense.id
    ]);
  }

  // DELETE
  Future<int> deleteExpense(int id) async {
    Database database = getDatabase;
    return await database.delete(
      DBConstants.expense.table,
      where: '${DBConstants.expense.id} = ?',
      whereArgs: [id],
    );
  }

  // DELETE ALL
  Future<int> deleteAllExpenses() async {
    Database database = getDatabase;
    return await database.delete(DBConstants.expense.table);
  }

  // GET COUNT
  Future<int> getExpenseCount() async {
    Database database = getDatabase;
    final count = Sqflite.firstIntValue(await database.rawQuery(
      'SELECT COUNT(*) FROM ${DBConstants.expense.table}',
    ));
    return count ?? 0;
  }

  // Get all Expenses (map) from database
  Future<List<Map<String, dynamic>>> getExpenseMapList() async {
    Database database = getDatabase;
    var result = await database.query(DBConstants.expense.table);
    return result;
  }

  Future<void> populateDatabase() async {
    Database database = getDatabase;
    // Populate the database with x entries
    debugPrint("populating db");
    for (int i = 1; i <= 1; i++) {
      var expense = generateRandomExpense();
      debugPrint("expense $i - !!!$expense!!!)");
      await database.insert(
        DBConstants.expense.table,
        expense,
      );
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
      DBConstants.expense.createdAt:
      faker.date.dateTime().toIso8601String(),
      DBConstants.expense.modifiedAt:
      faker.date.dateTime().toIso8601String(),
    };
    return expense;
  }

}