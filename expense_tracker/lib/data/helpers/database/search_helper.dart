import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';

import '../../../models/search.dart';
import '../../constants/db_constants.dart';

class SearchHelper {
  final Database _database;
  static final Logger _logger =
      Logger(printer: SimplePrinter(), level: Level.info);

  SearchHelper(this._database);

  Database get getDatabase => _database;

  static Future<void> createTable(Database database) async {
    var result = await database.rawQuery(
        """SELECT 1 FROM sqlite_master WHERE type = 'table' AND name = '${DBConstants.search.table}'""");
    if (result.isEmpty) {
      _logger.i("creating table ${DBConstants.search.table}");
      await database.execute('''CREATE TABLE ${DBConstants.search.table} (
        ${DBConstants.search.id} INTEGER PRIMARY KEY AUTOINCREMENT, 
        ${DBConstants.search.title} TEXT,
        ${DBConstants.search.amount} REAL,
        ${DBConstants.common.createdAt} TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        ${DBConstants.common.modifiedAt} TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
        ''');

      _logger.i("creating trigger ${DBConstants.search.triggerModifiedAt}");
      await database.execute('''
        CREATE TRIGGER ${DBConstants.search.triggerModifiedAt}
        AFTER UPDATE ON ${DBConstants.search.table}
        BEGIN
          UPDATE ${DBConstants.search.table}
          SET ${DBConstants.common.modifiedAt} = CURRENT_TIMESTAMP
          WHERE ROWID = NEW.ROWID;
        END;
      ''');
    }
  }

  Future<int> addSearch(Map<String, dynamic> searchMap) async {
    _logger.i("adding search ${searchMap[DBConstants.search.title]}");
    _logger.i(searchMap.toString());
    Database database = getDatabase;
    return await database.insert(DBConstants.search.table, searchMap);
  }

  Future<List<Map<String, dynamic>>> getSearches() async {
    _logger.i("getting searches");
    Database database = getDatabase;
    return await database.query(DBConstants.search.table);
  }

  Future<List<Map<String, dynamic>>> getLatestSearches({int limit = 10}) async {
    _logger.i("getting latest searches");
    Database database = getDatabase;
    return await database.query(
      DBConstants.search.table,
      orderBy: "${DBConstants.common.createdAt} DESC",
      limit: 10,
    );
  }

  Future<List<Map<String, dynamic>>> getSearchByTitle(String searchTitle) async {
    _logger.i("getting search $searchTitle");
    Database database = getDatabase;
    return await database.query(DBConstants.search.table,
        where: '${DBConstants.search.title} = ?', whereArgs: [searchTitle]);
  }

  Future<int> updateSearch(SearchFormModel search) async {
    _logger.i("updating search ${search.id} - ${search.title}");
    _logger.i(search.toMap().toString());
    Database database = getDatabase;
    return database.update(DBConstants.search.table, search.toMap(),
        where: '${DBConstants.search.id} = ?', whereArgs: [search.id]);
  }

  Future<int> deleteSearch(int id) async {
    _logger.i("deleting ${DBConstants.search.table} - $id");
    Database database = getDatabase;
    return await database.delete(DBConstants.search.table,
        where: '${DBConstants.search.id} = ?', whereArgs: [id]);
  }

  Future<int> deleteSearchByTitle(String searchTitle) async {
    _logger.i("deleting ${DBConstants.search.table} - $searchTitle");
    Database database = getDatabase;
    return await database.delete(DBConstants.search.table,
        where: '${DBConstants.search.title} = ?', whereArgs: [searchTitle]);
  }

  Future<int> deleteAllSearches() async {
    _logger.i("deleting ${DBConstants.search.table}");
    Database database = getDatabase;
    return await database.delete(DBConstants.search.table);
  }

  Future<int> getSearchesCount() async {
    _logger.i("getting ${DBConstants.search.table} count");
    Database database = getDatabase;
    final count = Sqflite.firstIntValue(await database
        .rawQuery('SELECT COUNT(*) as count FROM ${DBConstants.search.table}'));
    return count ?? 0;
  }

  Future<List<Map<String, dynamic>>> getSearchCountByTitle(String searchTitle) async {
    _logger.i("checking if search exists $searchTitle");
    Database database = getDatabase;
    return database.rawQuery(
        """SELECT COUNT(*) as count FROM ${DBConstants.search.table} where ${DBConstants.search.title} = '$searchTitle'""");
  }
}