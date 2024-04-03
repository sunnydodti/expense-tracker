import 'dart:io';

import 'package:expense_tracker/data/db_constants/DBConstants.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:faker/faker.dart';

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
          CREATE TABLE ${DBConstants.expense.expenseTable}(
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
      AFTER UPDATE ON ${DBConstants.expense.expenseTable}
      FOR EACH ROW
      BEGIN
        UPDATE ${DBConstants.expense.expenseTable}
        SET modified_at = CURRENT_TIMESTAMP
        WHERE ${DBConstants.expense.id} = OLD.${DBConstants.expense.id};
      END;
    ''');
  }

  // CRUD operations
  // CREATE
  Future<int> addExpense(ExpenseFormModel expense) async {
    expense.createdAt ??= DateTime.now();
    expense.modifiedAt ??= DateTime.now();
    debugPrint("inserting");
    debugPrint(expense.toMap().toString());
    Database database = await getDatabase;
    return await database.insert(
      DBConstants.expense.expenseTable,
      expense.toMap(),
    );
  }

  // READ
  Future<List<Expense>> getExpenses() async {
    Database database = await getDatabase;
    final List<Map<String, dynamic>> expenseMaps =
        await database.query(DBConstants.expense.expenseTable);
    return expenseMaps
        .map((expenseMap) => Expense.fromMap(expenseMap))
        .toList();
  }

  // UPDATE
  Future<int> updateExpense(ExpenseFormModel expense) async {
    expense.modifiedAt ??= DateTime.now();
    debugPrint("updating");
    debugPrint(expense.toMap().toString());
    Database database = await getDatabase;
    return database.update(
      DBConstants.expense.expenseTable,
      expense.toMap(),
      where: '${DBConstants.expense.id} = ?',
      whereArgs: [expense.id],
    );
  }

  Future<int> updateExpenseV2(ExpenseFormModel expense) async {
    expense.modifiedAt ??= DateTime.now();
    debugPrint("updating");
    debugPrint(expense.toMap().toString());
    Database database = await getDatabase;
    return database.rawUpdate('''
      UPDATE ${DBConstants.expense.expenseTable}
      SET ${DBConstants.expense.amount} = ?
      WHERE ${DBConstants.expense.id} = ? 
      ''',[
        expense.amount,
        expense.id
    ]);
  }

  // DELETE
  Future<int> deleteExpense(int id) async {
    Database database = await getDatabase;
    return await database.delete(
      DBConstants.expense.expenseTable,
      where: '${DBConstants.expense.id} = ?',
      whereArgs: [id],
    );
  }

  // DELETE ALL
  Future<int> deleteAllExpenses() async {
    Database database = await getDatabase;
    return await database.delete(DBConstants.expense.expenseTable);
  }

  // GET COUNT
  Future<int> getExpenseCount() async {
    Database database = await getDatabase;
    final count = Sqflite.firstIntValue(await database.rawQuery(
      'SELECT COUNT(*) FROM ${DBConstants.expense.expenseTable}',
    ));
    return count ?? 0;
  }

  // Get all Expenses (map) from database
  Future<List<Map<String, dynamic>>> getExpenseMapList() async {
    Database database = await getDatabase;
    var result = await database.query(DBConstants.expense.expenseTable);
    return result;
  }

  Future<void> populateDatabase() async {
    Database database = await getDatabase;
    // Populate the database with x entries
    debugPrint("populating db");
    for (int i = 1; i <= 1; i++) {
      var expense = generateRandomExpense();
      debugPrint("expense $i - !!!$expense!!!)");
      await database.insert(
        DBConstants.expense.expenseTable,
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
