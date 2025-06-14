import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';

import '../../constants/db_constants.dart';
import 'expense_helper.dart';
import 'expense_item_helper.dart';
import 'profile_helper.dart';
import 'search_helper.dart';
import 'user_helper.dart';

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

  static Future<void> migrateV2toV3(Database database) async {
    _logger.i("migrating database from v2 to v3");
    database.transaction((Transaction txn) async {
      try {
        await UserHelper.createTable(database);
        await UserHelper.populateDefaults(database);

        await ProfileHelper.createTable(database);
        await ProfileHelper.populateDefaults(database);

        _logger.i("upgrading table ${DBConstants.expense.table}");
        await ExpenseHelper.upgradeTableV2toV3(txn);

      } catch (e, stackTrace) {
        _logger.e("Error migrating for v2 to v3 - $e - \n$stackTrace");
      }
    });
  }

  static Future<void> migrateV3toV4(Database database) async {
    _logger.i("migrating database from v3 to v4");
    database.transaction((Transaction txn) async {
      try {
        await SearchHelper.createTable(database);

      } catch (e, stackTrace) {
        _logger.e("Error migrating for v3 to v4 - $e - \n$stackTrace");
      }
    });
  }
}
