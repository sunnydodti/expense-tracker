import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';

import 'expense_helper.dart';
import 'expense_item_helper.dart';

class MigrationHelper {
  static final Logger _logger =
      Logger(printer: SimplePrinter(), level: Level.info);

  static Future<void> migrateV1toV2(Database database) async {
    _logger.i("migrating database from v1 to v2");
    database.transaction((Transaction txn) async {
      try {
        await ExpenseItemHelper.createTable(database);
        await ExpenseHelper.upgradeTableV1toV2(txn);
        await ExpenseItemHelper.addPreviousExpensesAsExpenseItem(
            txn, await ExpenseHelper.getAllExpenses(database));
      } catch (e, stackTrace) {
        _logger.e("Error migrating for v1 to v2 - $e - \n$stackTrace");
      }
    });
  }
}
