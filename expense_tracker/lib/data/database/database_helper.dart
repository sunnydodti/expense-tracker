import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../constants/db_constants.dart';
import 'category_helper.dart';
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
    final String path = '${directory.path}/${DBConstants.databaseName}.db';

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
    await ExpenseHelper.createTable(database);
    await CategoryHelper.createTable(database);
  }

  Future<ExpenseHelper> get expenseHelper async =>
      ExpenseHelper(await getDatabase);

  Future<CategoryHelper> get categoryHelper async => CategoryHelper(await getDatabase);
}
