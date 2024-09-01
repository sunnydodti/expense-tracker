import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';

import '../../../models/enums/sort_criteria.dart';
import '../../../models/expense.dart';
import '../../../models/expense_filters.dart';
import '../../../models/profile.dart';
import '../../../models/user.dart';
import '../../constants/db_constants.dart';
import 'profile_helper.dart';
import 'user_helper.dart';

class ExpenseHelper {
  final Database _database;
  static final Logger _logger =
      Logger(printer: SimplePrinter(), level: Level.info);

  ExpenseHelper(this._database);

  Database get getDatabase => _database;

  static Future<void> createTable(Database database) async {
    var result = await database.rawQuery(
        """SELECT name FROM sqlite_master WHERE type = 'table' AND name = '${DBConstants.expense.table}'""");

    if (result.isEmpty) {
      _logger.i("creating table ${DBConstants.expense.table}");
      await database.execute('''
          CREATE TABLE ${DBConstants.expense.table}(
            ${DBConstants.expense.id} INTEGER PRIMARY KEY AUTOINCREMENT,
            ${DBConstants.expense.title} TEXT,
            ${DBConstants.expense.currency} TEXT,
            ${DBConstants.expense.amount} REAL,
            ${DBConstants.expense.transactionType} TEXT,
            ${DBConstants.expense.date} DATE,
            ${DBConstants.expense.category} TEXT,
            ${DBConstants.expense.tags} TEXT,
            ${DBConstants.expense.note} TEXT,
            ${DBConstants.expense.containsExpenseItems} INTEGER DEFAULT 0,
            ${DBConstants.common.createdAt} TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            ${DBConstants.common.modifiedAt} TIMESTAMP DEFAULT CURRENT_TIMESTAMP
          )
        ''');

      _logger.i("creating trigger ${DBConstants.expense.triggerModifiedAt}");
      await database.execute('''
      CREATE TRIGGER ${DBConstants.expense.triggerModifiedAt}
      AFTER UPDATE ON ${DBConstants.expense.table}
      BEGIN
        UPDATE ${DBConstants.expense.table}
        SET modified_at = CURRENT_TIMESTAMP
        WHERE ROWID = NEW.ROWID;
      END;
    ''');
    }
  }

  //region db update v2
  static Future<void> upgradeTableV1toV2(Transaction transaction) async {
    var result = await transaction.rawQuery(
        """SELECT name FROM sqlite_master WHERE type = 'table' AND name = '${DBConstants.expense.table}'""");
    if (result.isNotEmpty) {
      _logger.i("updating table ${DBConstants.expense.table}");
      _logger.i(
          "\trenaming ${DBConstants.expense.containsNestedExpenses} to ${DBConstants.expense.containsExpenseItems}");
      await transaction.execute('''
          ALTER TABLE ${DBConstants.expense.table}
          RENAME COLUMN ${DBConstants.expense.containsNestedExpenses} TO ${DBConstants.expense.containsExpenseItems}
        ''');
    }
  }

  //region db update v3
  static Future<void> upgradeTableV2toV3(Transaction transaction) async {
    var result = await transaction.rawQuery(
        """SELECT name FROM sqlite_master WHERE type = 'table' AND name = '${DBConstants.expense.table}'""");
    if (result.isNotEmpty) {
      _logger.i("updating table ${DBConstants.expense.table}");
      _logger.i(
          "\tadding ${DBConstants.expense.profileId} column");
      List<Map<String, dynamic>> defaultProfileMap = await ProfileHelper.getDefaultProfile(transaction);
      Profile defaultProfile = Profile.fromMap(defaultProfileMap.first);
      await transaction.execute('''
          ALTER TABLE ${DBConstants.expense.table}
          ADD COLUMN ${DBConstants.expense.profileId} INTEGER NOT NULL DEFAULT ${defaultProfile.id}
        ''');

      _logger.i(
          "\tadding ${DBConstants.expense.userId} column");
      List<Map<String, dynamic>> defaultUserMap = await UserHelper.getDefaultUser(transaction);
      User defaultUser = User.fromMap(defaultProfileMap.first);
      await transaction.execute('''
          ALTER TABLE ${DBConstants.expense.table}
          ADD COLUMN ${DBConstants.expense.profileId} INTEGER NOT NULL DEFAULT ${defaultUser.id}
        ''');
    }
  }

  static Future<List<Map<String, dynamic>>> getAllExpenses(
      Database database) async {
    _logger.i("getting expenses");
    return await database.query(DBConstants.expense.table);
  }

  static setContainsExpensesTrue(
      Transaction transaction, List<Map<String, dynamic>> allExpenses) {
    transaction.execute('''
    UPDATE ${DBConstants.expense.table}
    SET ${DBConstants.expense.containsExpenseItems} = 1
    ''');
  }

  //endregion

  // CRUD operations
  // CREATE
  Future<int> addExpense(Map<String, dynamic> expenseMap) async {
    _logger.i("adding expense ${expenseMap[DBConstants.expense.title]}");
    _logger.i(expenseMap.toString());
    Database database = getDatabase;
    return await database.insert(DBConstants.expense.table, expenseMap);
  }

  Future<List<Map<String, dynamic>>> getExpense(int id) async {
    _logger.i("getting expense $id}");
    Database database = getDatabase;
    return await database.query(DBConstants.expense.table,
        where: '${DBConstants.expense.id} = ?', whereArgs: [id]);
  }

  // READ
  Future<List<Map<String, dynamic>>> getExpenses() async {
    _logger.i("getting expenses");
    Database database = getDatabase;
    return await database.query(DBConstants.expense.table);
  }

  Future<List<Map<String, dynamic>>> getSortedAndFilteredExpenses(
    SortCriteria sortCriteria,
    bool isAscendingSort,
    ExpenseFilters filters,
    Profile? profile,
  ) async {
    profile == null
        ? _logger.i("getting sorted and filtered expenses")
        : _logger.i(
            "getting sorted and filtered expenses for profile - ${profile.name}");

    Database database = getDatabase;
    String tableName = DBConstants.expense.table;

    String whereClause = '1=1';
    List<dynamic> whereArgs = [];

    if (profile != null) {
      whereClause += ''' AND ${DBConstants.expense.profileId} = ?''';
      whereArgs.add(profile.id);
    }

    if (filters.isApplied) {
      if (filters.filterByYear) {
        whereClause +=
            ''' AND strftime('%Y', ${DBConstants.expense.date}) = ?''';
        whereArgs.add(filters.selectedYear);
      }
      if (filters.filterByMonth) {
        whereClause +=
            ''' AND strftime('%m', ${DBConstants.expense.date}) = ?''';
        whereArgs.add(getMonthNumber(filters.selectedMonth));
      }
    }

    String orderBy = '';
    orderBy = getOrderByCriteria(sortCriteria, orderBy);

    orderBy += getSortOrder(isAscendingSort, sortCriteria);

    return await database.query(
      tableName,
      where: whereClause.isEmpty ? null : whereClause,
      whereArgs: whereClause.isEmpty ? null : whereArgs,
      orderBy: orderBy,
    );
  }

  // UPDATE
  Future<int> updateExpense(ExpenseFormModel expense) async {
    _logger.i("updating expense ${expense.id} - ${expense.title}");
    _logger.i(expense.toMap().toString());
    Database database = getDatabase;
    return database.update(DBConstants.expense.table, expense.toMap(),
        where: '${DBConstants.expense.id} = ?', whereArgs: [expense.id]);
  }

  // DELETE
  Future<int> deleteExpense(int id) async {
    _logger.i("deleting ${DBConstants.expense.table} - $id");
    Database database = getDatabase;
    return await database.delete(DBConstants.expense.table,
        where: '${DBConstants.expense.id} = ?', whereArgs: [id]);
  }

  // DELETE ALL
  Future<int> deleteAllExpenses() async {
    _logger.i("deleting ${DBConstants.expense.table}");
    Database database = getDatabase;
    return await database.delete(DBConstants.expense.table);
  }

  // GET COUNT
  Future<int> getExpenseCount() async {
    _logger.i("getting ${DBConstants.expense.table} count");
    Database database = getDatabase;
    final count = Sqflite.firstIntValue(await database
        .rawQuery('SELECT COUNT(*) FROM ${DBConstants.expense.table}'));
    return count ?? 0;
  }

  Future<void> populateExpense(List<Map<String, dynamic>> expenses) async {
    Database database = getDatabase;
    _logger.i("populating ${DBConstants.expense.table}");
    for (var expense in expenses) {
      _logger.i("expense - !!!$expense!!!)");
      await database.insert(
        DBConstants.expense.table,
        expense,
      );
    }
  }

  String getOrderByCriteria(SortCriteria sortCriteria, String orderBy) {
    switch (sortCriteria) {
      case SortCriteria.createdDate:
        orderBy = 'created_at';
        break;
      case SortCriteria.modifiedDate:
        orderBy = 'modified_at';
        break;
      case SortCriteria.expenseDate:
        orderBy = 'date';
        break;
      case SortCriteria.expenseAmount:
        orderBy = 'amount';
        break;
    }
    return orderBy;
  }

  String getMonthNumber(String monthName) {
    DateTime date = DateFormat('MMMM').parse(monthName);
    return DateFormat('MM').format(date);
  }

  String getSortOrder(bool isAscendingSort, SortCriteria sortCriteria) {
    if (sortCriteria == SortCriteria.expenseAmount) {
      return isAscendingSort ? ' DESC' : ' ASC';
    }
    return isAscendingSort ? ' ASC' : ' DESC';
  }
}
