import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';

import '../../models/expense.dart';
import '../constants/db_constants.dart';

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
            ${DBConstants.expense.containsNestedExpenses} INTEGER,
            ${DBConstants.expense.expenses} TEXT,
            ${DBConstants.expense.createdAt} TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            ${DBConstants.expense.modifiedAt} TIMESTAMP DEFAULT CURRENT_TIMESTAMP
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

  // CRUD operations
  // CREATE
  Future<int> addExpense(Map<String, dynamic> expenseMap) async {
    _logger.i("adding expense ${expenseMap[DBConstants.expense.title]}");
    _logger.i(expenseMap.toString());
    Database database = getDatabase;
    return await database.insert(
      DBConstants.expense.table,
      expenseMap,
    );
  }

  Future<List<Map<String, dynamic>>> getExpense(int id) async {
    _logger.i("getting expense $id}");
    Database database = getDatabase;
    return await database.query(
      DBConstants.expense.table,
      where: '${DBConstants.expense.id} = ?',
      whereArgs: [id],
    );
  }

  // READ
  Future<List<Map<String, dynamic>>> getExpenses() async {
    _logger.i("getting expenses");
    Database database = getDatabase;
    return await database.query(DBConstants.expense.table);
  }

  // UPDATE
  Future<int> updateExpense(ExpenseFormModel expense) async {
    _logger.i("updating expense ${expense.id} - ${expense.title}");
    _logger.i(expense.toMap().toString());
    Database database = getDatabase;
    return database.update(
      DBConstants.expense.table,
      expense.toMap(),
      where: '${DBConstants.expense.id} = ?',
      whereArgs: [expense.id],
    );
  }

  Future<int> updateExpenseV2(Map<String, dynamic> expenseMap) async {
    _logger.i(
        "updating expense V2 ${expenseMap[DBConstants.expense.id]} - ${expenseMap[DBConstants.expense.title]}");
    _logger.i(expenseMap.toString());
    Database database = getDatabase;
    return database.rawUpdate('''
      UPDATE ${DBConstants.expense.table}
      SET ${DBConstants.expense.amount} = ?
      WHERE ${DBConstants.expense.id} = ? 
      ''', [
      expenseMap[DBConstants.expense.amount],
      expenseMap[DBConstants.expense.id]
    ]);
  }

  // DELETE
  Future<int> deleteExpense(int id) async {
    _logger.i("deleting ${DBConstants.expense.table} - $id");
    Database database = getDatabase;
    return await database.delete(
      DBConstants.expense.table,
      where: '${DBConstants.expense.id} = ?',
      whereArgs: [id],
    );
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
    final count = Sqflite.firstIntValue(await database.rawQuery(
      'SELECT COUNT(*) FROM ${DBConstants.expense.table}',
    ));
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
}
