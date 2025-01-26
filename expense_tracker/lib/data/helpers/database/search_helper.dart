import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';

import '../../../models/profile.dart';
import '../../../models/search.dart';
import '../../constants/db_constants.dart';
import 'profile_helper.dart';

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
      List<Map<String, dynamic>> defaultProfileMap =
          await ProfileHelper.getDefaultProfileMap(database);
      Profile defaultProfile = Profile.fromMap(defaultProfileMap.first);

      _logger.i("creating table ${DBConstants.search.table}");
      await database.execute('''CREATE TABLE ${DBConstants.search.table} (
        ${DBConstants.search.id} INTEGER PRIMARY KEY AUTOINCREMENT, 
        ${DBConstants.search.title} TEXT,
        ${DBConstants.search.amount} REAL,
        ${DBConstants.search.profileId} INTEGER NOT NULL DEFAULT ${defaultProfile.id},
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

  Future<List<Map<String, dynamic>>> getLatestSearches(
      {required int profileId, int limit = 10}) async {
    _logger.i("getting latest searches for profile $profileId");
    Database database = getDatabase;
    return await database.query(
      DBConstants.search.table,
      where: "${DBConstants.search.profileId} = ?",
      whereArgs: [profileId],
      orderBy: "${DBConstants.common.modifiedAt} DESC",
      limit: limit,
    );
  }

  Future<List<Map<String, dynamic>>> getSearchByTitle(String searchTitle) async {
    _logger.i("getting search $searchTitle");
    Database database = getDatabase;
    return await database.query(DBConstants.search.table,
        where: '${DBConstants.search.title} = ?', whereArgs: [searchTitle]);
  }

  Future<List<Map<String, dynamic>>> getSearchById(int id) async {
    _logger.i("getting search by id $id");
    Database database = getDatabase;
    return await database.query(DBConstants.search.table,
        where: '${DBConstants.search.id} = ?', whereArgs: [id]);
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