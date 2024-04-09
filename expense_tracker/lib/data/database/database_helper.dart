import 'dart:io';

import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../constants/db_constants.dart';
import 'category_helper.dart';
import 'expense_helper.dart';
import 'tag_helper.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static final Logger _logger =
      Logger(printer: SimplePrinter(), level: Level.info);

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
        _logger.i(path);
        _logger.i("Database is open");
      },
    );
  }

  void createDatabase(Database database, int newVersion) async {
    await ExpenseHelper.createTable(database);

    await CategoryHelper.createTable(database);
    await CategoryHelper.populateDefaults(database);

    await TagHelper.createTable(database);
    await TagHelper.populateDefaults(database);
  }

  Future<ExpenseHelper> get expenseHelper async =>
      ExpenseHelper(await getDatabase);

  Future<CategoryHelper> get categoryHelper async =>
      CategoryHelper(await getDatabase);

  Future<TagHelper> get tagHelper async => TagHelper(await getDatabase);
}
