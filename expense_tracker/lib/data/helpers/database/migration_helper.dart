import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';

import '../../constants/db_constants.dart';
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
        _logger.i("upgrading table ${DBConstants.expense.table}");
        await ExpenseHelper.upgradeTableV1toV2(txn);
        List<Map<String, dynamic>> allExpenses =
            await ExpenseHelper.getAllExpenses(database);
        _logger.i(
            "adding existing ${DBConstants.expense.table} as ${DBConstants.expenseItem.table}");
        await ExpenseItemHelper.addPreviousExpensesAsExpenseItem(
            txn, allExpenses);
        _logger.i(
            "setting ${DBConstants.expense.containsExpenseItems} as true ${DBConstants.expense.table}");
        await ExpenseHelper.setContainsExpensesTrue(txn, allExpenses);
      } catch (e, stackTrace) {
        _logger.e("Error migrating for v1 to v2 - $e - \n$stackTrace");
      }
    });
  }
}
