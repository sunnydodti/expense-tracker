import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';

import '../../models/expense_category.dart';
import '../constants/db_constants.dart';

class CategoryHelper {
  final Database _database;
  static final Logger _logger =
      Logger(printer: SimplePrinter(), level: Level.info);

  CategoryHelper(this._database);

  Database get getDatabase => _database;

  static final List<String> defaultCategories = [
    "Food",
    "Transport",
    "Shopping",
    "Entertainment",
    "Health",
    "Bills",
    "Others"
  ];

  static Future<void> createTable(Database database) async {
    var result = await database.rawQuery(
        """SELECT name FROM sqlite_master WHERE type = 'table' AND name = '${DBConstants.category.table}'""");

    if (result.isEmpty) {
      _logger.i("creating table ${DBConstants.category.table}");
      await database.execute('''CREATE TABLE ${DBConstants.category.table} (
        ${DBConstants.category.id} INTEGER PRIMARY KEY AUTOINCREMENT, 
        ${DBConstants.category.name} TEXT,
        ${DBConstants.category.createdAt} TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        ${DBConstants.category.modifiedAt} TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
        ''');

      _logger.i("creating trigger ${DBConstants.category.triggerModifiedAt}");
      await database.execute('''
        CREATE TRIGGER ${DBConstants.category.triggerModifiedAt}
        AFTER UPDATE ON ${DBConstants.category.table}
        BEGIN
          UPDATE ${DBConstants.category.table}
          SET modified_at = CURRENT_TIMESTAMP
          WHERE ROWID = NEW.ROWID;
        END;
      ''');
    }
  }

  static Future<void> populateDefaults(Database database) async {
    var result = await database.rawQuery(
        '''SELECT name FROM sqlite_master WHERE type = 'table' AND name = '${DBConstants.category.table}' ''');

    try {
      if (result.isNotEmpty) {
        _logger.i("populating default ${DBConstants.category.table}");
        for (String category in defaultCategories) {
          await database.execute(
              '''insert into ${DBConstants.category.table} (${DBConstants.category.name}) values ('$category')''');
        }
      }
    } on Exception catch (e, stackTrace) {
      _logger.e("Error at populating default categories $e - $stackTrace");
    }
  }

  Future<int> addCategory(Map<String, dynamic> categoryMap) async {
    _logger.i("adding category ${categoryMap[DBConstants.category.name]}");
    _logger.i(categoryMap.toString());
    Database database = getDatabase;
    return await database.insert(DBConstants.category.table, categoryMap);
  }

  Future<List<Map<String, dynamic>>> getCategories() async {
    _logger.i("getting categories");
    Database database = getDatabase;
    return await database.query(DBConstants.category.table);
  }

  Future<List<Map<String, dynamic>>> getCategoryByName(
      String categoryName) async {
    _logger.i("getting category $categoryName}");
    Database database = getDatabase;
    return await database.query(DBConstants.category.table,
        where: '${DBConstants.category.name} = ?', whereArgs: [categoryName]);
  }

  Future<int> updateCategory(CategoryFormModel category) async {
    _logger.i("updating category ${category.id} - ${category.name}");
    _logger.i(category.toMap().toString());
    Database database = getDatabase;
    return database.update(DBConstants.category.table, category.toMap(),
        where: '${DBConstants.category.id} = ?', whereArgs: [category.id]);
  }

  Future<int> deleteCategory(int id) async {
    _logger.i("deleting ${DBConstants.category.table} - $id");
    Database database = getDatabase;
    return await database.delete(DBConstants.category.table,
        where: '${DBConstants.category.id} = ?', whereArgs: [id]);
  }

  Future<int> deleteCategoryByName(String categoryName) async {
    _logger.i("deleting ${DBConstants.category.table} - $categoryName");
    Database database = getDatabase;
    return await database.delete(DBConstants.category.table,
        where: '${DBConstants.category.name} = ?', whereArgs: [categoryName]);
  }

  Future<int> deleteAllCategories() async {
    _logger.i("deleting ${DBConstants.category.table}");
    Database database = getDatabase;
    return await database.delete(DBConstants.category.table);
  }

  Future<int> getCategoryCount() async {
    _logger.i("getting ${DBConstants.category.table} count");
    Database database = getDatabase;
    final count = Sqflite.firstIntValue(await database
        .rawQuery('SELECT COUNT(*) FROM ${DBConstants.category.table}'));
    return count ?? 0;
  }

  Future<List<Map<String, dynamic>>> getCategoryCountByName(
      String categoryName) async {
    _logger.i("checking if category exists $categoryName");
    Database database = getDatabase;
    return database.rawQuery(
        """SELECT COUNT(*) as count FROM ${DBConstants.category.table} where ${DBConstants.category.name} = '$categoryName'""");
  }
}
