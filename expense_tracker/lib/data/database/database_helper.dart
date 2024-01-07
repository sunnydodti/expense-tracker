import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:expense_tracker/data/db_constants/DBExpenseTableConstants.dart';

import '../../models/expense_new.dart';

import 'package:faker/faker.dart';



class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  Database? _database;
  Random random = Random();
  // Private constructor to prevent external instantiation
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
            ${DBExpenseTableConstants.expenseColId} INTEGER PRIMARY KEY AUTOINCREMENT,
            ${DBExpenseTableConstants.expenseColTitle} TEXT,
            ${DBExpenseTableConstants.expenseColCurrency} TEXT,
            ${DBExpenseTableConstants.expenseColAmount} REAL,
            ${DBExpenseTableConstants.expenseColTransactionType} TEXT,
            ${DBExpenseTableConstants.expenseColDate} DATE,
            ${DBExpenseTableConstants.expenseColCategory} TEXT,
            ${DBExpenseTableConstants.expenseColTags} TEXT,
            ${DBExpenseTableConstants.expenseColNote} TEXT,
            ${DBExpenseTableConstants.expenseColContainsNestedExpenses} INTEGER,
            ${DBExpenseTableConstants.expenseColExpenses} TEXT
          )
        ''');
    populateDatabase(database);
  }

  // CRUD operations
  // CREATE
  Future<int> insertExpense(Expense expense) async {
    return await _database!.insert(
      DBExpenseTableConstants.expenseTable,
      expense.toMap(),
    );
  }

  // READ
  Future<List<Expense>> getExpenses() async {
    final List<Map<String, dynamic>> expenseMaps =
    await _database!.query(DBExpenseTableConstants.expenseTable);

    return expenseMaps.map((expenseMap) => Expense.fromMap(expenseMap)).toList();
  }

  // UPDATE
  Future<int> updateExpense(Expense expense) async {
    return await _database!.update(
      DBExpenseTableConstants.expenseTable,
      expense.toMap(),
      where: '${DBExpenseTableConstants.expenseColId} = ?',
      whereArgs: [expense.id],
    );
  }

  // DELETE
  Future<int> deleteExpense(int id) async {
    return await _database!.delete(
      DBExpenseTableConstants.expenseTable,
      where: '${DBExpenseTableConstants.expenseColId} = ?',
      whereArgs: [id],
    );
  }

  // GET COUNT
  Future<int> getExpenseCount() async {
    final count = Sqflite.firstIntValue(await _database!.rawQuery(
      'SELECT COUNT(*) FROM ${DBExpenseTableConstants.expenseTable}',
    ));
    return count ?? 0;
  }

  // Get all Expenses (map) from database
  Future<List<Map<String, dynamic>>> getExpenseMapList() async {
    Database? database = await getDatabase;
    var result = await database.query(
      DBExpenseTableConstants.expenseTable
    );
    return result;
  }

  // Get all Expenses (object) from database
  // Future<List<Expense>> getExpenseList() async {
  //   var expenseMapList = await getExpenseMapList();
  //   List<Expense> expenseList = <Expense>[];
  //
  //   for ( int i = 0; i < expenseMapList.length; i++ ){
  //     expenseList.add(Expense.fromMap(expenseMapList[i]));
  //   }
  //
  //   return expenseList;
  // }

  void populateDatabase(Database database) async {
    // Populate the database with 10 entries
    debugPrint("populating db");
    for (int i = 1; i <= 10; i++) {
      double amount = faker.randomGenerator.decimal() * (1000.0 - 1.0) + 1.0;
      var expense  = {
        DBExpenseTableConstants.expenseColTitle: faker.food.dish(),
        DBExpenseTableConstants.expenseColCurrency: "₹",
        DBExpenseTableConstants.expenseColAmount: double.parse(amount.toStringAsFixed(2)),
        DBExpenseTableConstants.expenseColTransactionType: faker.randomGenerator.boolean() ? 'income' : 'expense',
        DBExpenseTableConstants.expenseColDate: faker.date.dateTime().toIso8601String(),
        DBExpenseTableConstants.expenseColCategory: faker.randomGenerator.boolean() ? 'Food' : 'Shopping',
        DBExpenseTableConstants.expenseColTags: faker.randomGenerator.boolean() ? 'home' : 'work',
        DBExpenseTableConstants.expenseColNote: faker.lorem.sentence(),
        DBExpenseTableConstants.expenseColContainsNestedExpenses: faker.randomGenerator.boolean() ? 1 : 0,
        DBExpenseTableConstants.expenseColExpenses: 'Nested expenses data', // Add appropriate nested expenses data
      };
      debugPrint("expense $i - !!!$expense!!!)");
      await database.insert(
        DBExpenseTableConstants.expenseTable,
        expense,
      );
    }
  }
}