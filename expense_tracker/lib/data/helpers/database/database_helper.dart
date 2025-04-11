import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import '../../constants/db_constants.dart';
import 'category_helper.dart';
import 'expense_helper.dart';
import 'expense_item_helper.dart';
import 'migration_helper.dart';
import 'profile_helper.dart';
import 'search_helper.dart';
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
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
      databaseFactoryOrNull = databaseFactoryFfiWeb;
    }
    return _database ??= await initializeDatabase();
  }

  Future<Database> initializeDatabase() async {
    String path = "";
    if (kIsWeb) {
      path = "/assets/db/${DBConstants.databaseName}";
    } else if (Platform.isWindows | Platform.isLinux) {
      final Directory directory = await getApplicationDocumentsDirectory();
      String pSeparator = Platform.pathSeparator;
      path =
          '${directory.path}${pSeparator}databases$pSeparator${DBConstants.databaseName}';
    } else {
      final Directory directory = await getApplicationDocumentsDirectory();
      path = '${directory.path}/${DBConstants.databaseName}';
    }

    return await openDatabase(
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

  Future<void> upgradeDatabase(
      Database db, int oldVersion, int newVersion) async {
    // if upgrading from version 1
    if (oldVersion == 1) {
      await upgradeFromV1toV2(db);
      await upgradeFromV2toV3(db);
      await upgradeFromV3toV4(db);
    }

    // if upgrading from version 2
    if (oldVersion == 2) {
      await upgradeFromV2toV3(db);
      await upgradeFromV3toV4(db);
    }

    // if upgrading from version 3
    if (oldVersion == 3) {
      await upgradeFromV3toV4(db);
    }
  }

  void createDatabase(Database database, int newVersion) async {
    // version3
    await UserHelper.createTable(database);
    await UserHelper.populateDefaults(database);
    await ProfileHelper.createTable(database);
    await ProfileHelper.populateDefaults(database);

    // version 1
    await ExpenseHelper.createTable(database);

    await ExpenseItemHelper.createTable(database);

    await CategoryHelper.createTable(database);
    await CategoryHelper.populateDefaults(database);

    await TagHelper.createTable(database);
    await TagHelper.populateDefaults(database);

    // version 2

    // version 4
    await SearchHelper.createTable(database);
  }

  Future upgradeFromV1toV2(Database database) async {
    MigrationHelper.migrateV1toV2(database);
  }

  Future upgradeFromV2toV3(Database database) async {
    MigrationHelper.migrateV2toV3(database);
  }

  Future upgradeFromV3toV4(Database database) async {
    MigrationHelper.migrateV3toV4(database);
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
  Future<SearchHelper> get searchHelper async =>
      SearchHelper(await getDatabase);
}
