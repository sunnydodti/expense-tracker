import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';

import '../../../models/expense_item.dart';
import '../../constants/db_constants.dart';

class ExpenseItemHelper {
  final Database _database;
  static final Logger _logger =
      Logger(printer: SimplePrinter(), level: Level.info);

  ExpenseItemHelper(this._database);

  Database get getDatabase => _database;

  static Future<void> createTable(Database database) async {
    var result = await database.rawQuery(
        """SELECT name FROM sqlite_master WHERE type = 'table' AND name = '${DBConstants.expenseItem.table}'""");

    if (result.isEmpty) {
      _logger.i("creating table ${DBConstants.expenseItem.table}");
      await database.execute('''
          CREATE TABLE ${DBConstants.expenseItem.table}(
            ${DBConstants.expenseItem.id} INTEGER PRIMARY KEY AUTOINCREMENT,
            ${DBConstants.expenseItem.expenseId} INTEGER,
            ${DBConstants.expenseItem.name} TEXT,
            ${DBConstants.expenseItem.amount} REAL,
            ${DBConstants.expenseItem.quantity} INTEGER,
            ${DBConstants.common.createdAt} TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            ${DBConstants.common.modifiedAt} TIMESTAMP DEFAULT CURRENT_TIMESTAMP
          )
        ''');

      _logger
          .i("creating trigger ${DBConstants.expenseItem.triggerModifiedAt}");
      await database.execute('''
      CREATE TRIGGER ${DBConstants.expenseItem.triggerModifiedAt}
      AFTER UPDATE ON ${DBConstants.expenseItem.table}
      BEGIN
        UPDATE ${DBConstants.expenseItem.table}
        SET ${DBConstants.common.modifiedAt} = CURRENT_TIMESTAMP
        WHERE ROWID = NEW.ROWID;
      END;
    ''');
    }
  }

  /// migration db v1 to v2
  static Future<int> addPreviousExpensesAsExpenseItem(
      Transaction transaction, List<Map<String, dynamic>> expenses) async {
    int count = 0;
    for (var expense in expenses) {
      var expenseId = expense[DBConstants.expense.id];
      _logger.i("expense id for expense item $expenseId");
      ExpenseItemFormModel expenseItem = ExpenseItemFormModel.forMigration(
        name: expense[DBConstants.expense.title],
        amount: expense[DBConstants.expense.amount],
        quantity: 1,
        expenseId: expenseId,
      );
      count += await addConvertedExpenseItem(expenseItem.toMap(), transaction);
    }
    return count;
  }

  // CRUD operations
  // CREATE
  Future<int> addExpenseItem(Map<String, dynamic> expenseMap) async {
    _logger.i(
        "adding expense item ${expenseMap[DBConstants.expenseItem.name]} - expense: ${expenseMap[DBConstants.expenseItem.expenseId]}");
    _logger.i(expenseMap.toString());
    Database database = getDatabase;
    return await database.insert(DBConstants.expenseItem.table, expenseMap);
  }

  Future<List<Object?>> addExpenseItems(
      List<Map<String, dynamic>> expenseItemMapList) async {
    _logger.i(
        "adding ${expenseItemMapList.length} expense items - expense: ${expenseItemMapList.isNotEmpty ? expenseItemMapList[0][DBConstants.expenseItem.expenseId] : 'unknown'}");
    Database database = getDatabase;
    Batch batch = database.batch();
    for (var expenseItemMap in expenseItemMapList) {
      _logger.i(expenseItemMap.toString());
      batch.insert(DBConstants.expenseItem.table, expenseItemMap);
    }
    return await batch.commit();
  }

  static Future<int> addConvertedExpenseItem(
      Map<String, dynamic> expenseMap, Transaction transaction) async {
    _logger.i(
        "adding converted expense item ${expenseMap[DBConstants.expenseItem.name]} - expense: ${expenseMap[DBConstants.expenseItem.expenseId]}");
    _logger.i(expenseMap.toString());
    return await transaction.insert(DBConstants.expenseItem.table, expenseMap);
  }

  Future<List<Map<String, dynamic>>> getExpenseItem(int id) async {
    _logger.i("getting expense item $id");
    Database database = getDatabase;
    return await database.query(DBConstants.expenseItem.table,
        where: '${DBConstants.expenseItem.id} = ?', whereArgs: [id]);
  }

  // READ
  Future<List<Map<String, dynamic>>> getExpenseItems() async {
    _logger.i("getting expense items");
    Database database = getDatabase;
    return await database.query(DBConstants.expenseItem.table);
  }

  Future<List<Map<String, dynamic>>> getExpenseItemsByExpenseId(
      int expenseId) async {
    _logger.i("getting expense items for expense - $expenseId");
    Database database = getDatabase;
    return await database.query(DBConstants.expenseItem.table,
        where: '${DBConstants.expenseItem.expenseId} = ?',
        whereArgs: [expenseId]);
  }

  // UPDATE
  Future<int> updateExpenseItem(ExpenseItemFormModel expenseItem) async {
    _logger.i("updating expense item ${expenseItem.id} - ${expenseItem.name}");
    _logger.i(expenseItem.toMap().toString());
    Database database = getDatabase;
    return database.update(DBConstants.expenseItem.table, expenseItem.toMap(),
        where: '${DBConstants.expenseItem.id} = ?',
        whereArgs: [expenseItem.id]);
  }

  Future<List<Object?>> updateExpenseItems(
      List<ExpenseItemFormModel> expenseItems) async {
    Database database = getDatabase;
    Batch batch = database.batch();

    for (var expenseItem in expenseItems) {
      _logger.i(expenseItem.toString());
      batch.update(DBConstants.expenseItem.table, expenseItem.toMap(),
          where: '${DBConstants.expenseItem.id} = ?',
          whereArgs: [expenseItem.id]);
    }
    return await batch.commit();
  }

  // DELETE
  Future<int> deleteExpenseItem(int id) async {
    _logger.i("deleting ${DBConstants.expenseItem.table} - $id");
    Database database = getDatabase;
    return await database.delete(DBConstants.expenseItem.table,
        where: '${DBConstants.expenseItem.id} = ?', whereArgs: [id]);
  }

  // Future<int> deleteExpenseItems(List<int> ids) async {
  //   _logger.i("deleting (${ids.length}) ${DBConstants.expenseItem.table}");
  //   Database database = getDatabase;
  //   return await database.delete(DBConstants.expenseItem.table,
  //       where: '${DBConstants.expenseItem.id} = ?', whereArgs: [id]);
  // }

  // DELETE ALL
  Future<int> deleteAllExpenseItems() async {
    _logger.i("deleting ${DBConstants.expenseItem.table}");
    Database database = getDatabase;
    return await database.delete(DBConstants.expenseItem.table);
  }

  // GET COUNT
  Future<int> getExpenseItemsCount() async {
    _logger.i("getting ${DBConstants.expenseItem.table} count");
    Database database = getDatabase;
    final count = Sqflite.firstIntValue(await database
        .rawQuery('SELECT COUNT(*) FROM ${DBConstants.expenseItem.table}'));
    return count ?? 0;
  }

  Future<int> getExpenseItemsCountForExpense(int expenseId) async {
    _logger.i("getting ${DBConstants.expenseItem.table} count");
    Database database = getDatabase;
    final count = Sqflite.firstIntValue(await database.rawQuery('''
        SELECT COUNT(*) 
        FROM ${DBConstants.expenseItem.table}
        WHERE ${DBConstants.expenseItem.expenseId} = $expenseId
        '''));
    return count ?? 0;
  }
}
