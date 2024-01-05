import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:expense_tracker/data/db_constants/DBExpenseTableConstants.dart';

import '../../models/expense_new.dart';



class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  late Database _database;

  // Private constructor to prevent external instantiation
  DatabaseHelper._createInstance();

  factory DatabaseHelper(){
    _databaseHelper ??= DatabaseHelper._createInstance();
    return _databaseHelper!;
  }

  Future<Database> initializeDatabase() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = '${directory.path}expense_tracker.db';

    var expenseTrackerDatabase = await openDatabase(
      path,
      version: 1,
      onCreate: createDatabase,
    );
    return expenseTrackerDatabase;
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
  }

  Future<Database> get database async{
    return _database ??= await initializeDatabase();
  }

  // CRUD operations
  // CREATE
  Future<int> insertExpense(Expense expense) async {
    return await _database.insert(
      DBExpenseTableConstants.expenseTable,
      expense.toMap(),
    );
  }

  // READ
  Future<List<Expense>> getExpenses() async {
    final List<Map<String, dynamic>> expenseMaps =
    await _database.query(DBExpenseTableConstants.expenseTable);

    return expenseMaps.map((expenseMap) => Expense.fromMap(expenseMap)).toList();
  }

  // UPDATE
  Future<int> updateExpense(Expense expense) async {
    return await _database.update(
      DBExpenseTableConstants.expenseTable,
      expense.toMap(),
      where: '${DBExpenseTableConstants.expenseColId} = ?',
      whereArgs: [expense.id],
    );
  }

  // DELETE
  Future<int> deleteExpense(int id) async {
    return await _database.delete(
      DBExpenseTableConstants.expenseTable,
      where: '${DBExpenseTableConstants.expenseColId} = ?',
      whereArgs: [id],
    );
  }

  // GET COUNT
  Future<int> getExpenseCount() async {
    final count = Sqflite.firstIntValue(await _database.rawQuery(
      'SELECT COUNT(*) FROM ${DBExpenseTableConstants.expenseTable}',
    ));
    return count ?? 0;
  }

}