import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../../models/category.dart';
import '../constants/db_constants.dart';

class CategoryHelper {
  final Database _database;

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
      await database.execute('''CREATE TABLE ${DBConstants.category.table} (
        ${DBConstants.category.id} INTEGER PRIMARY KEY AUTOINCREMENT, 
        ${DBConstants.category.name} TEXT,
        ${DBConstants.category.createdAt} TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        ${DBConstants.category.modifiedAt} TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
        ''');
    }
  }

  static Future<void> populateDefaults(Database database) async {
    var result = await database.rawQuery(
        '''SELECT name FROM sqlite_master WHERE type = 'table' AND name = '${DBConstants.category.table}' ''');

    try {
      if (result.isNotEmpty) {
        for (String category in defaultCategories) {
          await database.execute(
              '''insert into ${DBConstants.category.table} (${DBConstants.category.name}) values ('$category')''');
        }
      }
    } on Exception catch (e) {
      debugPrint("Error at Defaults $e");
    }
  }

  Future<int> addCategory(Map<String, dynamic> categoryMap) async {
    debugPrint("adding category");
    debugPrint(categoryMap.toString());
    Database database = getDatabase;
    return await database.insert(
      DBConstants.category.table,
      categoryMap,
    );
  }

  Future<List<Map<String, dynamic>>> getCategories() async {
    Database database = getDatabase;
    return await database.query(DBConstants.category.table);
  }

  Future<List<Map<String, dynamic>>> getCategoryByName(
      String categoryName) async {
    Database database = getDatabase;
    return await database.query(
      DBConstants.category.table,
      where: '${DBConstants.category.name} = ?',
      whereArgs: [categoryName],
    );
  }

  Future<int> updateCategory(CategoryFormModel category) async {
    debugPrint("updating ${DBConstants.category.table}");
    debugPrint(category.toMap().toString());
    Database database = getDatabase;
    return database.update(
      DBConstants.category.table,
      category.toMap(),
      where: '${DBConstants.category.id} = ?',
      whereArgs: [category.id],
    );
  }

  Future<int> deleteCategory(int id) async {
    debugPrint("deleting ${DBConstants.category.table} - $id");
    Database database = getDatabase;
    return await database.delete(
      DBConstants.category.table,
      where: '${DBConstants.category.id} = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAllCategories() async {
    Database database = getDatabase;
    return await database.delete(DBConstants.category.table);
  }

  Future<int> getCategoryCount() async {
    Database database = getDatabase;
    final count = Sqflite.firstIntValue(await database.rawQuery(
      'SELECT COUNT(*) FROM ${DBConstants.category.table}',
    ));
    return count ?? 0;
  }
}
