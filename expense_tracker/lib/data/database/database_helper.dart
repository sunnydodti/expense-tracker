import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../constants/DBConstants.dart';
import 'expense_helper.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static Database? _database;

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    _databaseHelper ??= DatabaseHelper._createInstance();
    return _databaseHelper!;
  }

  Future<Database> get getDatabase async {
    return _database ??= await initializeDatabase();
  }

  Future<Database> initializeDatabase() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = '${directory.path}/expense_tracker.db';

    return openDatabase(
      path,
      version: 1,
      onCreate: createDatabase,
      onOpen: (db) {
        debugPrint(path);
        debugPrint("Database is open");
      },
    );
  }

  void createDatabase(Database database, int newVersion) async {
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

  Future<ExpenseHelper> get expenseHelper async =>
      ExpenseHelper(await getDatabase);
// CategoryHelper get categoryHelper => CategoryHelper(_database);
}
