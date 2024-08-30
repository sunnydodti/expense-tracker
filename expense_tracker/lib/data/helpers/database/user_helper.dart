import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';

import '../../../models/user.dart';
import '../../constants/db_constants.dart';

class UserHelper {
  final Database _database;
  static final Logger _logger =
  Logger(printer: SimplePrinter(), level: Level.info);

  UserHelper(this._database);

  Database get getDatabase => _database;

  static final List<String> defaultUsers = [
    'user'
  ];

  static Future<void> createTable(Database database) async {
    var result = await database.rawQuery(
        """SELECT name FROM sqlite_master WHERE type = 'table' AND name = '${DBConstants.user.table}'""");
    if (result.isEmpty) {
      _logger.i("creating table ${DBConstants.user.table}");
      await database.execute('''CREATE TABLE ${DBConstants.user.table} (
        ${DBConstants.user.id} INTEGER PRIMARY KEY AUTOINCREMENT, 
        ${DBConstants.user.name} TEXT,
        ${DBConstants.common.createdAt} TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        ${DBConstants.common.modifiedAt} TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
        ''');

      _logger.i("creating trigger ${DBConstants.user.triggerModifiedAt}");
      await database.execute('''
        CREATE TRIGGER ${DBConstants.user.triggerModifiedAt}
        AFTER UPDATE ON ${DBConstants.user.table}
        BEGIN
          UPDATE ${DBConstants.user.table}
          SET modified_at = CURRENT_TIMESTAMP
          WHERE ROWID = NEW.ROWID;
        END;
      ''');
    }
  }

  static Future<void> populateDefaults(Database database) async {
    var result = await database.rawQuery(
        '''SELECT name FROM sqlite_master WHERE type = 'table' AND name = '${DBConstants.user.table}' ''');

    try {
      _logger.i("populating default ${DBConstants.user.table}");
      if (result.isNotEmpty) {
        for (String category in defaultUsers) {
          await database.execute(
              '''insert into ${DBConstants.user.table} (${DBConstants.user.name}) values ('$category')''');
        }
      }
    } on Exception catch (e, stackTrace) {
      _logger.e("Error at populating default users $e - \n$stackTrace");
    }
  }

  Future<int> addUser(Map<String, dynamic> userMap) async {
    _logger.i("adding user ${userMap[DBConstants.user.name]}");
    _logger.i(userMap.toString());
    Database database = getDatabase;
    return await database.insert(DBConstants.user.table, userMap);
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    _logger.i("getting users");
    Database database = getDatabase;
    return await database.query(DBConstants.user.table);
  }

  Future<List<Map<String, dynamic>>> getUserByName(String userName) async {
    _logger.i("getting user $userName");
    Database database = getDatabase;
    return await database.query(DBConstants.user.table,
        where: '${DBConstants.user.name} = ?', whereArgs: [userName]);
  }

  Future<int> updateUser(UserFormModel user) async {
    _logger.i("updating user ${user.id} - ${user.userName}");
    _logger.i(user.toMap().toString());
    Database database = getDatabase;
    return database.update(DBConstants.user.table, user.toMap(),
        where: '${DBConstants.user.id} = ?', whereArgs: [user.id]);
  }

  Future<int> deleteUser(int id) async {
    _logger.i("deleting ${DBConstants.user.table} - $id");
    Database database = getDatabase;
    return await database.delete(DBConstants.user.table,
        where: '${DBConstants.user.id} = ?', whereArgs: [id]);
  }

  Future<int> deleteUserByName(String userName) async {
    _logger.i("deleting ${DBConstants.user.table} - $userName");
    Database database = getDatabase;
    return await database.delete(DBConstants.user.table,
        where: '${DBConstants.user.name} = ?', whereArgs: [userName]);
  }

  Future<int> deleteAllUsers() async {
    _logger.i("deleting ${DBConstants.user.table}");
    Database database = getDatabase;
    return await database.delete(DBConstants.user.table);
  }

  Future<int> getUsersCount() async {
    _logger.i("getting ${DBConstants.user.table} count");
    Database database = getDatabase;
    final count = Sqflite.firstIntValue(await database
        .rawQuery('SELECT COUNT(*) as count FROM ${DBConstants.user.table}'));
    return count ?? 0;
  }

  Future<List<Map<String, dynamic>>> getUserCountByName(String userName) async {
    _logger.i("checking if user exists $userName");
    Database database = getDatabase;
    return database.rawQuery(
        """
        SELECT COUNT(*) as count FROM ${DBConstants.user.table} 
        WHERE ${DBConstants.user.name} = '$userName'
        """);
  }

  static Future<List<Map<String, dynamic>>> getDefaultUser(Transaction transaction) {
    return transaction.rawQuery(
        """
      SELECT * FROM ${DBConstants.user.table} 
      WHERE ${DBConstants.user.name} = '${defaultUsers.first}'
      """
    );
  }
}
