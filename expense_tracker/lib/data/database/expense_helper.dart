import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../../models/expense.dart';
import '../constants/DBConstants.dart';

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
  Future<int> addExpense(Map<String, dynamic> expenseMap) async {
    debugPrint("inserting");
    debugPrint(expenseMap.toString());
    Database database = getDatabase;
    return await database.insert(
      DBConstants.expense.table,
      expenseMap,
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

  Future<int> updateExpenseV2(Map<String, dynamic> expenseMap) async {
    debugPrint("updating");
    debugPrint(expenseMap.toString());
    Database database = getDatabase;
    return database.rawUpdate('''
      UPDATE ${DBConstants.expense.table}
      SET ${DBConstants.expense.amount} = ?
      WHERE ${DBConstants.expense.id} = ? 
      ''', [
      expenseMap[DBConstants.expense.amount],
      expenseMap[DBConstants.expense.id]
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

  Future<void> populateDatabase(List<Map<String, dynamic>> expenses) async {
    Database database = getDatabase;
    debugPrint("populating db");
    for (var expense in expenses) {
      debugPrint("expense - !!!$expense!!!)");
      await database.insert(
        DBConstants.expense.table,
        expense,
      );
    }
  }
}
