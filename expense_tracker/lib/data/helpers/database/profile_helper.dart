import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';

import '../../../models/profile.dart';
import '../../constants/db_constants.dart';

class ProfileHelper {
  final Database _database;
  static final Logger _logger =
  Logger(printer: SimplePrinter(), level: Level.info);

  ProfileHelper(this._database);

  Database get getDatabase => _database;

  static final List<String> defaultProfiles = [
    'default'
  ];

  static Future<void> createTable(Database database) async {
    var result = await database.rawQuery(
        """SELECT name FROM sqlite_master WHERE type = 'table' AND name = '${DBConstants.profile.table}'""");
    if (result.isEmpty) {
      _logger.i("creating table ${DBConstants.profile.table}");
      await database.execute('''CREATE TABLE ${DBConstants.profile.table} (
        ${DBConstants.profile.id} INTEGER PRIMARY KEY AUTOINCREMENT, 
        ${DBConstants.profile.name} TEXT UNIQUE,
        ${DBConstants.common.createdAt} TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        ${DBConstants.common.modifiedAt} TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
        ''');

      _logger.i("creating trigger ${DBConstants.profile.triggerModifiedAt}");
      await database.execute('''
        CREATE TRIGGER ${DBConstants.profile.triggerModifiedAt}
        AFTER UPDATE ON ${DBConstants.profile.table}
        BEGIN
          UPDATE ${DBConstants.profile.table}
          SET modified_at = CURRENT_TIMESTAMP
          WHERE ROWID = NEW.ROWID;
        END;
      ''');
    }
  }

  static Future<void> populateDefaults(Database database) async {
    var result = await database.rawQuery(
        '''SELECT name FROM sqlite_master WHERE type = 'table' AND name = '${DBConstants.profile.table}' ''');

    try {
      _logger.i("populating default ${DBConstants.profile.table}");
      if (result.isNotEmpty) {
        for (String category in defaultProfiles) {
          await database.execute(
              '''insert into ${DBConstants.profile.table} (${DBConstants.profile.name}) values ('$category')''');
        }
      }
    } on Exception catch (e, stackTrace) {
      _logger.e("Error at populating default profiles $e - \n$stackTrace");
    }
  }

  Future<int> addProfile(Map<String, dynamic> profileMap) async {
    _logger.i("adding profile ${profileMap[DBConstants.profile.name]}");
    _logger.i(profileMap.toString());
    Database database = getDatabase;
    return await database.insert(DBConstants.profile.table, profileMap);
  }

  Future<List<Map<String, dynamic>>> getProfiles() async {
    _logger.i("getting profiles");
    Database database = getDatabase;
    return await database.query(DBConstants.profile.table);
  }

  Future<List<Map<String, dynamic>>> getProfileByName(String profileName) async {
    _logger.i("getting profile $profileName");
    Database database = getDatabase;
    return await database.query(DBConstants.profile.table,
        where: '${DBConstants.profile.name} = ?', whereArgs: [profileName]);
  }

  Future<int> updateProfile(ProfileFormModel profile) async {
    _logger.i("updating profile ${profile.id} - ${profile.name}");
    _logger.i(profile.toMap().toString());
    Database database = getDatabase;
    return database.update(DBConstants.profile.table, profile.toMap(),
        where: '${DBConstants.profile.id} = ?', whereArgs: [profile.id]);
  }

  Future<int> deleteProfile(int id) async {
    _logger.i("deleting ${DBConstants.profile.table} - $id");
    Database database = getDatabase;
    return await database.delete(DBConstants.profile.table,
        where: '${DBConstants.profile.id} = ?', whereArgs: [id]);
  }

  Future<int> deleteProfileByName(String profileName) async {
    _logger.i("deleting ${DBConstants.profile.table} - $profileName");
    Database database = getDatabase;
    return await database.delete(DBConstants.profile.table,
        where: '${DBConstants.profile.name} = ?', whereArgs: [profileName]);
  }

  Future<int> deleteAllProfiles() async {
    _logger.i("deleting ${DBConstants.profile.table}");
    Database database = getDatabase;
    return await database.delete(DBConstants.profile.table);
  }

  Future<int> getProfilesCount() async {
    _logger.i("getting ${DBConstants.profile.table} count");
    Database database = getDatabase;
    final count = Sqflite.firstIntValue(await database
        .rawQuery('SELECT COUNT(*) as count FROM ${DBConstants.profile.table}'));
    return count ?? 0;
  }

  Future<List<Map<String, dynamic>>> getProfileCountByName(String profileName) async {
    _logger.i("checking if profile exists $profileName");
    Database database = getDatabase;
    return database.rawQuery(
        """
        SELECT COUNT(*) as count FROM ${DBConstants.profile.table} 
        WHERE ${DBConstants.profile.name} = '$profileName'
        """);
  }

  static Future<List<Map<String, dynamic>>> getDefaultProfile(Transaction transaction) {
    return transaction.rawQuery(
      """
      SELECT * FROM ${DBConstants.profile.table} 
      WHERE ${DBConstants.profile.name} = '${defaultProfiles.first}'
      """
    );
  }
}
