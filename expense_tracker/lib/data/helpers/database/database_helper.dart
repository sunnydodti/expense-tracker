import 'dart:async';
import 'dart:io';

import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../constants/db_constants.dart';
import 'category_helper.dart';
import 'expense_helper.dart';
import 'expense_item_helper.dart';
import 'migration_helper.dart';
import 'profile_helper.dart';
import 'tag_helper.dart';
import 'user_helper.dart';

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
    String path = '${directory.path}/${DBConstants.databaseName}';

    if (Platform.isWindows | Platform.isLinux){
      sqfliteFfiInit();
      path = inMemoryDatabasePath;
      databaseFactory = databaseFactoryFfi;
    }

    return openDatabase(
      path,
      version: DBConstants.databaseVersion,
      onCreate: createDatabase,
      onUpgrade: upgradeDatabase,
      onOpen: (db) {
        _logger.i(path);
        _logger.i("Database is open");
      },
    );
  }

  FutureOr<void> upgradeDatabase(Database db, int oldVersion, int newVersion) {
    // if upgrading from version 1
    if (oldVersion == 1) {
        upgradeFromV1toV2(db);
      upgradeFromV2toV3(db);
    }

    // if upgrading from version 2
    if (oldVersion == 2) {
      upgradeFromV2toV3(db);
    }
  }

  void createDatabase(Database database, int newVersion) async {
    // version 1
    await ExpenseHelper.createTable(database);

    await ExpenseItemHelper.createTable(database);

    await CategoryHelper.createTable(database);
    await CategoryHelper.populateDefaults(database);

    await TagHelper.createTable(database);
    await TagHelper.populateDefaults(database);

    // version 2

    // version3
    await UserHelper.createTable(database);
    await UserHelper.populateDefaults(database);
    await ProfileHelper.createTable(database);
    await ProfileHelper.populateDefaults(database);
  }

  void upgradeFromV1toV2(Database database) async {
    MigrationHelper.migrateV1toV2(database);
  }

  void upgradeFromV2toV3(Database database) async {
    MigrationHelper.migrateV2toV3(database);
  }

  Future<ExpenseHelper> get expenseHelper async =>
      ExpenseHelper(await getDatabase);

  Future<ExpenseItemHelper> get expenseItemHelper async =>
      ExpenseItemHelper(await getDatabase);

  Future<CategoryHelper> get categoryHelper async =>
      CategoryHelper(await getDatabase);

  Future<TagHelper> get tagHelper async => TagHelper(await getDatabase);

  Future<ProfileHelper> get profileHelper async =>
      ProfileHelper(await getDatabase);

  Future<UserHelper> get userHelper async => UserHelper(await getDatabase);
}
