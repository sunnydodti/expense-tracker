import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';

import '../data/constants/db_constants.dart';
import '../data/constants/shared_preferences_constants.dart';
import '../data/helpers/database/database_helper.dart';
import '../data/helpers/database/user_helper.dart';
import '../models/user.dart';
import 'shared_preferences_service.dart';

class UserService {
  late final UserHelper _userHelper;
  static late SharedPreferencesService _sharedPreferencesService;
  static final Logger _logger =
      Logger(printer: SimplePrinter(), level: Level.info);

  UserService._(this._userHelper);

  static Future<UserService> create() async {
    final databaseHelper = DatabaseHelper();
    await databaseHelper.initializeDatabase();
    final userHelper = await databaseHelper.userHelper;
    _sharedPreferencesService = SharedPreferencesService();

    return UserService._(userHelper);
  }

  Future<List<User>> getUsers() async {
    try {
      final List<Map<String, dynamic>> users = await _userHelper.getUsers();
      List<User> tgs = users.map((userMap) => User.fromMap(userMap)).toList();
      return tgs;
    } catch (e, stackTrace) {
      _logger.e("Error getting users: $e - \n$stackTrace");
      return [];
    }
  }

  Future<User?> getDefaultUser() async {
    try {
      String userName = UserHelper.defaultUser;
      final List<Map<String, dynamic>> user =
          await _userHelper.getUserByUserName(userName);
      _sharedPreferencesService.initializeUserPreferences();
      return User.fromMap(user.first);
    } catch (e, stackTrace) {
      _logger.e("Error getting users: $e - \n$stackTrace");
      return null;
    }
  }

  Future<User?> getSelectedUser() async {
    try {
      String? userName = await _getUserNameOrDefault();
      final List<Map<String, dynamic>> user =
          await _userHelper.getUserByUserName(userName!);
      dynamic userMap = user.first;
      return User.fromMap(userMap);
    } catch (e, stackTrace) {
      _logger.e("Error getting users: $e - \n$stackTrace");
      return null;
    }
  }

  Future<String?> _getUserNameOrDefault() async {
    String? userName = await _sharedPreferencesService
        .getStringPreference(SharedPreferencesConstants.user.USER);
    if (userName == null){
      _sharedPreferencesService.initializeUserPreferences();
      userName = await _sharedPreferencesService
          .getStringPreference(SharedPreferencesConstants.user.USER);
    }
    return userName;
  }

  Future<List<Map<String, dynamic>>> getUserMaps() async {
    try {
      return await _userHelper.getUsers();
    } on Exception catch (e, stackTrace) {
      _logger.e("Error getting users: $e - \n$stackTrace");
      return [];
    }
  }

  Future<User?> getUserByName(String userName) async {
    try {
      final List<Map<String, dynamic>> user =
          await _userHelper.getUserByUserName(userName);
      return User.fromMap(user.first);
    } catch (e, stackTrace) {
      _logger.e("Error getting user ($userName): $e - \n$stackTrace");
      return null;
    }
  }

  Future<int> addUser(UserFormModel user) async {
    try {
      final result = await _userHelper.addUser(user.toMap());
      return result;
    } catch (e, stackTrace) {
      _logger.e("Error adding user: $e - \n$stackTrace");
      return -1;
    }
  }

  Future<int> updateUser(UserFormModel user) async {
    try {
      final result = await _userHelper.updateUser(user);
      return result;
    } catch (e, stackTrace) {
      _logger.e("Error updating user: $e - \n$stackTrace");
      return -1;
    }
  }

  Future<int> deleteUser(int id) async {
    try {
      final result = await _userHelper.deleteUser(id);
      return result;
    } catch (e, stackTrace) {
      _logger.e("Error deleting user: $e - \n$stackTrace");
      return -1;
    }
  }

  Future<int> deleteAllUsers() async {
    try {
      final result = await _userHelper.deleteAllUsers();
      return result;
    } catch (e, stackTrace) {
      _logger.e("Error deleting users - $e - \n$stackTrace");
      return -1;
    }
  }

  User? getMatchingUser(String userName, List<User> users) {
    try {
      if (userName.isEmpty) return null;
      final matchingUsers = users.where((user) => user.userName == userName);
      return matchingUsers.isNotEmpty ? matchingUsers.first : null;
    } on Exception catch (e, stackTrace) {
      _logger.e("Error getting user ($userName): $e - \n$stackTrace");
      return null;
    }
  }

  Future<bool> importUser(Map<String, dynamic> user,
      {safeImport = true}) async {
    _logger.i(
        "importing user ${user[DBConstants.user.id]} - ${user[DBConstants.user.userName]}");
    try {
      if (await isDuplicateUser(user[DBConstants.user.userName])) {
        _logger.i("found duplicate user: ${user[DBConstants.user.userName]}");
        if (safeImport) return false;
        _logger.i("safeImport: $safeImport - discarding existing user");
        await _userHelper.deleteUserByUserName(user[DBConstants.user.userName]);
      }
      if (await _userHelper.addUser(user) > 0) {
        _logger.i("imported user ${user[DBConstants.user.userName]}");
        return true;
      }
    } on Exception catch (e, stackTrace) {
      _logger.e(
          "Error importing user (${user[DBConstants.user.userName]}): $e - \n$stackTrace");
    }
    return false;
  }

  Future<bool> isDuplicateUser(String userName) async {
    int count = await getUserCount(userName);
    if (count > 0) return true;
    return false;
  }

  Future<int> getUserCount(String userName) async {
    _logger.i("checking if user exists $userName");
    final List<Map<String, dynamic>> result =
        await _userHelper.getUserCountByName(userName);
    int? count = Sqflite.firstIntValue(result);
    if (count == null) return 0;
    return count;
  }
}
