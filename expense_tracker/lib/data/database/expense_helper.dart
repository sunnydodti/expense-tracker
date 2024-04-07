import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../../models/expense.dart';
import '../constants/db_constants.dart';

class ExpenseHelper {
  final Database _database;

  ExpenseHelper(this._database);

  Database get getDatabase => _database;

  static Future<void> createTable(Database database) async {
    await database.execute('''
          CREATE TABLE ${DBConstants.expense.table}(
            ${DBConstants.expense.id} INTEGER PRIMARY KEY AUTOINCREMENT,
            ${DBConstants.expense.title} TEXT,
            ${DBConstants.expense.currency} TEXT,
            ${DBConstants.expense.amount} REAL,
            ${DBConstants.expense.transactionType} TEXT,
            ${DBConstants.expense.date} DATE,
            ${DBConstants.expense.category} TEXT,
            ${DBConstants.expense.tags} TEXT,
            ${DBConstants.expense.note} TEXT,
            ${DBConstants.expense.containsNestedExpenses} INTEGER,
            ${DBConstants.expense.expenses} TEXT,
            ${DBConstants.expense.createdAt} TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            ${DBConstants.expense.modifiedAt} TIMESTAMP DEFAULT CURRENT_TIMESTAMP
          )
        ''');

    await database.execute('''
      CREATE TRIGGER update_modified_at
      AFTER UPDATE ON ${DBConstants.expense.table}
      FOR EACH ROW
      BEGIN
        UPDATE ${DBConstants.expense.table}
        SET modified_at = CURRENT_TIMESTAMP
        WHERE ${DBConstants.expense.id} = OLD.${DBConstants.expense.id};
      END;
    ''');
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
  Future<List<Map<String, dynamic>>> getExpenses() async {
    Database database = getDatabase;
    return await database.query(DBConstants.expense.table);
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

  Future<void> populateExpense(List<Map<String, dynamic>> expenses) async {
    Database database = getDatabase;
    debugPrint("populating ${DBConstants.expense.table}");
    for (var expense in expenses) {
      debugPrint("expense - !!!$expense!!!)");
      await database.insert(
        DBConstants.expense.table,
        expense,
      );
    }
  }
}
