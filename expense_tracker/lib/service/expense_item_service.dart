import 'package:logger/logger.dart';

import '../data/constants/db_constants.dart';
import '../data/helpers/database/database_helper.dart';
import '../data/helpers/database/expense_item_helper.dart';
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
          "Error adding expense item(${expenseItem.name}) for expense ${expenseItem.expenseId}: $e - \n$stackTrace");
      return false;
    }
  }

  Future<bool> addExpenseItems(List<ExpenseItemFormModel> expenseItems) async {
    try {
      var result = await _expenseItemHelper
          .addExpenseItems(convertExpenseItemsToMapList(expenseItems));
      return result.isNotEmpty ? true : false;
    } on Exception catch (e, stackTrace) {
      _logger.e(
          "Error adding ${expenseItems.length} expense items for expense ${expenseItems[0].expenseId}: $e - \n$stackTrace");
      return false;
    }
  }

  List<Map<String, dynamic>> convertExpenseItemsToMapList(
      List<ExpenseItemFormModel> expenseItems) {
    return expenseItems.map((expenseItem) => expenseItem.toMap()).toList();
  }

  Future<ExpenseItem?> getExpenseItem(int id) async {
    try {
      final List<Map<String, dynamic>> expenses =
          await _expenseItemHelper.getExpenseItem(id);
      return ExpenseItem.fromMap(expenses.first);
    } catch (e, stackTrace) {
      _logger.e("Error getting expense ($id) - $e - \n$stackTrace");
      return null;
    }
  }

  Future<bool> updateExpenseItem(ExpenseItemFormModel expenseItem) async {
    try {
      if (await doesExistExpenseItem(expenseItem.id!)) {
        int result = await _expenseItemHelper.updateExpenseItem(expenseItem);
        return result > 0 ? true : false;
      }
      return false;
    } on Exception catch (e, stackTrace) {
      _logger.e(
          "Error updating expense item(${expenseItem.name}) for expense ${expenseItem.expenseId}: $e - \n$stackTrace");
      return false;
    }
  }

  Future<bool> updateExpenseItems(
      List<ExpenseItemFormModel> expenseItems) async {
    try {
      List<ExpenseItemFormModel> expenseItemsToUpdate = [];
      List<ExpenseItemFormModel> expenseItemsNew = [];
      for (var expenseItem in expenseItems) {
        if (expenseItem.id == null) {
          expenseItemsNew.add(expenseItem);
        } else {
          expenseItemsToUpdate.add(expenseItem);
        }
      }
      var result =
          await _expenseItemHelper.updateExpenseItems(expenseItemsToUpdate);
      result += await _expenseItemHelper
          .addExpenseItems(convertExpenseItemsToMapList(expenseItemsNew));
      return result.isNotEmpty ? true : false;
    } on Exception catch (e, stackTrace) {
      _logger.e(
          "Error updating (${expenseItems.length}) expense items for expense ${expenseItems[0].expenseId}: $e - \n$stackTrace");
      return false;
    }
  }

  Future<List<ExpenseItem>> getExpenseItems(int expenseId) async {
    List<Map<String, dynamic>> expenseMapList =
        await _expenseItemHelper.getExpenseItemsByExpenseId(expenseId);
    return expenseMapList
        .map((expenseMap) => ExpenseItem.fromMap(expenseMap))
        .toList();
  }

  Future<List<ExpenseItemFormModel>> getExpenseItemsForEdit(
      int expenseId) async {
    List<Map<String, dynamic>> expenseMapList =
        await _expenseItemHelper.getExpenseItemsByExpenseId(expenseId);
    return expenseMapList
        .map((expenseMap) => ExpenseItemFormModel.fromMap(expenseMap))
        .toList();
  }

  Future<List<Map<String, dynamic>>> getExpenseItemsMaps() async {
    try {
      return await _expenseItemHelper.getExpenseItems();
    } on Exception catch (e, stackTrace) {
      _logger.e("Error getting expense Items: $e - \n$stackTrace");
      return [];
    }
  }

  Future<int> deleteExpenseItem(int id) async {
    try {
      return _expenseItemHelper.deleteExpenseItem(id);
    } on Exception catch (e, stackTrace) {
      _logger.e("Error deleting expenses: $e - \n$stackTrace");
      return -1;
    }
  }

  Future<int> deleteExpenseItems(List<int> ids) async {
    int count = 0;
    try {
      for (int id in ids) {
        count += await deleteExpenseItem(id);
      }
    } on Exception catch (e, stackTrace) {
      _logger.e("Error deleting expenses: $e - \n$stackTrace");
      return -1;
    }
    return count;
  }

  Future<int> deleteAllExpenseItems() async {
    try {
      return _expenseItemHelper.deleteAllExpenseItems();
    } on Exception catch (e, stackTrace) {
      _logger.e("Error deleting expenses: $e - \n$stackTrace");
      return -1;
    }
  }

  Future<bool> importExpenseItem(Map<String, dynamic> expense) async {
    try {
      if (await _expenseItemHelper.addExpenseItem(expense) > 0) return true;
    } on Exception catch (e, stackTrace) {
      _logger.e(
          "Error importing expense Item(${expense[DBConstants.expenseItem.name]}): $e - \n$stackTrace");
    }
    return false;
  }

  Future<bool> isDuplicateExpenseItem(ExpenseItem expenseItem) async {
    ExpenseItem? existingExpenseItem = await getExpenseItem(expenseItem.id);
    if (existingExpenseItem == null) return false;
    if (existingExpenseItem.name == expenseItem.name &&
        existingExpenseItem.amount == expenseItem.amount) return true;
    return false;
  }

  Future<bool> doesExistExpenseItem(int expenseItemId) async {
    ExpenseItem? existingExpenseItem = await getExpenseItem(expenseItemId);
    if (existingExpenseItem == null) return false;
    return true;
  }
}
