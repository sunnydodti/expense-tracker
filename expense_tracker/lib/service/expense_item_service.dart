import 'package:logger/logger.dart';

import '../data/helpers/database/database_helper.dart';
import '../data/helpers/database/expense_item_helper.dart';
import '../models/expense.dart';
import '../models/expense_item.dart';

class ExpenseItemService {
  late final ExpenseItemHelper _expenseItemHelper;
  static final Logger _logger =
      Logger(printer: SimplePrinter(), level: Level.info);

  ExpenseItemService._(this._expenseItemHelper);

  static Future<ExpenseItemService> create() async {
    final databaseHelper = DatabaseHelper();
    await databaseHelper.initializeDatabase();
    final expenseItemHelper = await databaseHelper.expenseItemHelper;
    return ExpenseItemService._(expenseItemHelper);
  }

  Future<bool> addExpenseItem(ExpenseItemFormModel expenseItem) async {
    try {
      int id = await _expenseItemHelper.addExpenseItem(expenseItem.toMap());
      return id > 0 ? true : false;
    } on Exception catch (e, stackTrace) {
      _logger.e(
          "Error adding expense item(${expenseItem.name}): $e - \n$stackTrace");
      return false;
    }
  }

  Future<void> addExpenseItems(List<ExpenseItemFormModel> expenseItems) async {
    try {
      var result = await _expenseItemHelper
          .addExpenseItems(convertExpenseItemsToMapList(expenseItems));
      // return id > 0 ? true : false;
      int a = 0;
    } on Exception catch (e, stackTrace) {
      _logger.e(
          "Error adding ${expenseItems.length} expense items for expense ${expenseItems[0].expenseId}: $e - \n$stackTrace");
      // return false;
    }
  }

  List<Map<String, dynamic>> convertExpenseItemsToMapList(
      List<ExpenseItemFormModel> expenseItems) {
    return expenseItems.map((expenseItem) => expenseItem.toMap()).toList();
  }

  Future<Expense?> getExpenseItem(int id) async {
    try {
      final List<Map<String, dynamic>> expenses =
          await _expenseItemHelper.getExpenseItem(id);
      return Expense.fromMap(expenses.first);
    } catch (e, stackTrace) {
      _logger.e("Error getting expense ($id) - $e - \n$stackTrace");
      return null;
    }
  }

  // Future<bool> updateExpenseItem(ExpenseFormModel expense) async {
  //   try {
  //     int result = await _expenseItemHelper.updateExpenseItem(expense);
  //     return result > 0 ? true : false;
  //   } on Exception catch (e, stackTrace) {
  //     _logger
  //         .e("Error updating expense (${expense.title}): $e - \n$stackTrace");
  //     return false;
  //   }
  // }

  Future<List<ExpenseItem>> getExpenseItems(int expenseId) async {
    List<Map<String, dynamic>> expenseMapList =
        await _expenseItemHelper.getExpenseItemsByExpenseId(expenseId);
    return expenseMapList
        .map((expenseMap) => ExpenseItem.fromMap(expenseMap))
        .toList();
  }

  Future<List<ExpenseItemFormModel>> getExpenseItemsForEdit(int expenseId) async {
    List<Map<String, dynamic>> expenseMapList =
        await _expenseItemHelper.getExpenseItemsByExpenseId(expenseId);
    return expenseMapList
        .map((expenseMap) => ExpenseItemFormModel.fromMap(expenseMap))
        .toList();
  }

  // Future<List<Map<String, dynamic>>> getExpenseMaps() async {
  //   try {
  //     return await _expenseItemHelper.getExpenses();
  //   } on Exception catch (e, stackTrace) {
  //     _logger.e("Error getting expenses: $e - \n$stackTrace");
  //     return [];
  //   }
  // }

  // Future<int> deleteAllExpenses() async {
  //   try {
  //     return _expenseItemHelper.deleteAllExpenses();
  //   } on Exception catch (e, stackTrace) {
  //     _logger.e("Error deleting expenses: $e - \n$stackTrace");
  //     return -1;
  //   }
  // }

  // Future<bool> importExpenseItem(Map<String, dynamic> expense) async {
  //   try {
  //     if (await _expenseItemHelper.addExpenseItem(expense) > 0) return true;
  //   } on Exception catch (e, stackTrace) {
  //     _logger.e(
  //         "Error importing expense (${expense[DBConstants.expense.title]}): $e - \n$stackTrace");
  //   }
  //   return false;
  // }

  // Future<bool> importExpenseV2(Map<String, dynamic> expense,
  //     {safeImport = true}) async {
  //   _logger.i(
  //       "importing expense ${expense[DBConstants.expense.id]} - ${expense[DBConstants.expense.title]}");
  //   try {
  //     Expense expenseI = Expense.fromMap(expense);
  //     if (await isDuplicateExpenseItem(expenseI)) {
  //       _logger.i("found duplicate expense: ${expenseI.title}");
  //       if (safeImport) return false;
  //       _logger.i("safeImport: $safeImport - discarding existing expense");
  //       await _expenseItemHelper.deleteExpenseItem(expenseI.id);
  //     }
  //     if (await _expenseItemHelper.addExpenseItem(expense) > 0) {
  //       _logger.i("imported expense ${expenseI.title}");
  //       return true;
  //     }
  //   } on Exception catch (e, stackTrace) {
  //     _logger.e(
  //         "Error importing expense (${expense[DBConstants.expense.title]}): $e - \n$stackTrace");
  //   }
  //   return false;
  // }

  // Future<bool> isDuplicateExpenseItem(Expense expense) async {
  //   Expense? existingExpense = await getExpenseItem(expense.id);
  //   if (existingExpense == null) return false;
  //   if (existingExpense.title == expense.title &&
  //       existingExpense.amount == expense.amount) return true;
  //   return false;
  // }
}
