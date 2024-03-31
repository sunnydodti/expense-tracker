import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:expense_tracker/data/db_constants/DBExpenseTableConstants.dart';

import '../../models/expense.dart';
import '../../models/expense_new.dart';

import 'package:faker/faker.dart';



class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static Database? _database;
  DatabaseHelper._createInstance();

  factory DatabaseHelper(){
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
          CREATE TABLE ${DBExpenseTableConstants.expenseTable}(
            ${DBExpenseTableConstants.id} INTEGER PRIMARY KEY AUTOINCREMENT,
            ${DBExpenseTableConstants.title} TEXT,
            ${DBExpenseTableConstants.currency} TEXT,
            ${DBExpenseTableConstants.amount} REAL,
            ${DBExpenseTableConstants.transactionType} TEXT,
            ${DBExpenseTableConstants.date} DATE,
            ${DBExpenseTableConstants.category} TEXT,
            ${DBExpenseTableConstants.tags} TEXT,
            ${DBExpenseTableConstants.note} TEXT,
            ${DBExpenseTableConstants.containsNestedExpenses} INTEGER,
            ${DBExpenseTableConstants.expenses} TEXT,
            ${DBExpenseTableConstants.createdAt} TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            ${DBExpenseTableConstants.modifiedAt} TIMESTAMP DEFAULT CURRENT_TIMESTAMP
          )
        ''');

    await database.execute('''
      CREATE TRIGGER update_modified_at
      AFTER UPDATE ON ${DBExpenseTableConstants.expenseTable}
      FOR EACH ROW
      BEGIN
        UPDATE ${DBExpenseTableConstants.expenseTable}
        SET modified_at = CURRENT_TIMESTAMP
        WHERE ${DBExpenseTableConstants.id} = OLD.${DBExpenseTableConstants.id};
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
      DBExpenseTableConstants.expenseTable,
      expense.toMap(),
    );
  }

  // READ
  Future<List<Expense>> getExpenses() async {
    Database database = await getDatabase;
    final List<Map<String, dynamic>> expenseMaps = await database.query(DBExpenseTableConstants.expenseTable);
    return expenseMaps.map((expenseMap) => Expense.fromMap(expenseMap)).toList();
  }

  // UPDATE
  Future<int> updateExpense(Expense expense) async {
    Database database = await getDatabase;
    return await database.update(
      DBExpenseTableConstants.expenseTable,
      expense.toMap(),
      where: '${DBExpenseTableConstants.id} = ?',
      whereArgs: [expense.id],
    );
  }

  // DELETE
  Future<int> deleteExpense(int id) async {
    Database database = await getDatabase;
    return await database.delete(
      DBExpenseTableConstants.expenseTable,
      where: '${DBExpenseTableConstants.id} = ?',
      whereArgs: [id],
    );
  }

  // DELETE ALL
  Future<int> deleteAllExpenses() async {
    Database database = await getDatabase;
    return await database.delete(DBExpenseTableConstants.expenseTable);
  }


  // GET COUNT
  Future<int> getExpenseCount() async {
    Database database = await getDatabase;
    final count = Sqflite.firstIntValue(await database.rawQuery(
      'SELECT COUNT(*) FROM ${DBExpenseTableConstants.expenseTable}',
    ));
    return count ?? 0;
  }

  // Get all Expenses (map) from database
  Future<List<Map<String, dynamic>>> getExpenseMapList() async {
    Database database = await getDatabase;
    var result = await database.query(
      DBExpenseTableConstants.expenseTable
    );
    return result;
  }

  Future<void> populateDatabase() async {
    Database database = await getDatabase;
    // Populate the database with 10 entries
    debugPrint("populating db");
    for (int i = 1; i <= 1; i++) {
      var expense = generateRandomExpense();
      debugPrint("expense $i - !!!$expense!!!)");
      await database.insert(
        DBExpenseTableConstants.expenseTable,
        expense,
      );
    }
  }
  Map<String, dynamic> generateRandomExpense() {
    double amount = faker.randomGenerator.decimal() * (1000.0 - 1.0) + 1.0;
    var expense  = {
      DBExpenseTableConstants.title: faker.food.dish(),
      DBExpenseTableConstants.currency: "₹",
      DBExpenseTableConstants.amount: double.parse(amount.toStringAsFixed(2)),
      DBExpenseTableConstants.transactionType: faker.randomGenerator.boolean() ? 'income' : 'expense',
      DBExpenseTableConstants.date: faker.date.dateTime().toIso8601String(),
      DBExpenseTableConstants.category: faker.randomGenerator.boolean() ? 'Food' : 'Shopping',
      DBExpenseTableConstants.tags: faker.randomGenerator.boolean() ? 'home' : 'work',
      DBExpenseTableConstants.note: faker.lorem.sentence(),
      DBExpenseTableConstants.containsNestedExpenses: faker.randomGenerator.boolean() ? 1 : 0,
      DBExpenseTableConstants.expenses: 'Nested expenses data', // Add appropriate nested expenses data
      DBExpenseTableConstants.createdAt: faker.date.dateTime().toIso8601String(),
      DBExpenseTableConstants.modifiedAt: faker.date.dateTime().toIso8601String(),
    };
    return expense;
  }
}