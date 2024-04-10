import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';

import '../../models/tag.dart';
import '../constants/db_constants.dart';

class TagHelper {
  final Database _database;
  static final Logger _logger =
      Logger(printer: SimplePrinter(), level: Level.info);

  TagHelper(this._database);

  Database get getDatabase => _database;

  static final List<String> defaultTags = [
    'home',
    'work',
    'college',
    'friends',
    'family',
  ];

  static Future<void> createTable(Database database) async {
    var result = await database.rawQuery(
        """SELECT name FROM sqlite_master WHERE type = 'table' AND name = '${DBConstants.tag.table}'""");
    if (result.isEmpty) {
      _logger.i("creating table ${DBConstants.tag.table}");
      await database.execute('''CREATE TABLE ${DBConstants.tag.table} (
        ${DBConstants.tag.id} INTEGER PRIMARY KEY AUTOINCREMENT, 
        ${DBConstants.tag.name} TEXT,
        ${DBConstants.tag.createdAt} TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        ${DBConstants.tag.modifiedAt} TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
        ''');

      _logger.i("creating trigger ${DBConstants.tag.triggerModifiedAt}");
      await database.execute('''
        CREATE TRIGGER ${DBConstants.tag.triggerModifiedAt}
        AFTER UPDATE ON ${DBConstants.tag.table}
        BEGIN
          UPDATE ${DBConstants.tag.table}
          SET modified_at = CURRENT_TIMESTAMP
          WHERE ROWID = NEW.ROWID;
        END;
      ''');
    }
  }

  static Future<void> populateDefaults(Database database) async {
    var result = await database.rawQuery(
        '''SELECT name FROM sqlite_master WHERE type = 'table' AND name = '${DBConstants.tag.table}' ''');

    try {
      _logger.i("populating default ${DBConstants.tag.table}");
      if (result.isNotEmpty) {
        for (String category in defaultTags) {
          await database.execute(
              '''insert into ${DBConstants.tag.table} (${DBConstants.tag.name}) values ('$category')''');
        }
      }
    } on Exception catch (e, stackTrace) {
      _logger.e("Error at populating default tags $e - \n$stackTrace");
    }
  }

  Future<int> addTag(Map<String, dynamic> tagMap) async {
    _logger.i("adding tag ${tagMap[DBConstants.tag.name]}");
    _logger.i(tagMap.toString());
    Database database = getDatabase;
    return await database.insert(
      DBConstants.tag.table,
      tagMap,
    );
  }

  Future<List<Map<String, dynamic>>> getTags() async {
    _logger.i("getting tags");
    Database database = getDatabase;
    return await database.query(DBConstants.tag.table);
  }

  Future<List<Map<String, dynamic>>> getTagByName(String tagName) async {
    _logger.i("getting tag $tagName");
    Database database = getDatabase;
    return await database.query(
      DBConstants.tag.table,
      where: '${DBConstants.tag.name} = ?',
      whereArgs: [tagName],
    );
  }

  Future<int> updateTag(TagFormModel tag) async {
    _logger.i("updating tag ${tag.id} - ${tag.name}");
    _logger.i(tag.toMap().toString());
    Database database = getDatabase;
    return database.update(
      DBConstants.tag.table,
      tag.toMap(),
      where: '${DBConstants.tag.id} = ?',
      whereArgs: [tag.id],
    );
  }

  Future<int> deleteTag(int id) async {
    _logger.i("deleting ${DBConstants.tag.table} - $id");
    Database database = getDatabase;
    return await database.delete(
      DBConstants.tag.table,
      where: '${DBConstants.tag.id} = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteTagByName(String tagName) async {
    _logger.i("deleting ${DBConstants.tag.table} - $tagName");
    Database database = getDatabase;
    return await database.delete(
      DBConstants.tag.table,
      where: '${DBConstants.tag.name} = ?',
      whereArgs: [tagName],
    );
  }

  Future<int> deleteAllTags() async {
    _logger.i("deleting ${DBConstants.tag.table}");
    Database database = getDatabase;
    return await database.delete(DBConstants.tag.table);
  }

  Future<int> getTagsCount() async {
    _logger.i("getting ${DBConstants.tag.table} count");
    Database database = getDatabase;
    final count = Sqflite.firstIntValue(await database.rawQuery(
      'SELECT COUNT(*) as count FROM ${DBConstants.tag.table}',
    ));
    return count ?? 0;
  }

  Future<List<Map<String, dynamic>>> getTagCountByName(String tagName) async {
    _logger.i("checking if tag exists $tagName");
    Database database = getDatabase;
    return database.rawQuery(
        """SELECT COUNT(*) as count FROM ${DBConstants.tag.table} where ${DBConstants.tag.name} = '$tagName'"""
    );
  }
}
