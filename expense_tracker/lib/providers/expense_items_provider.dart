import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import '../models/expense_item.dart';
import '../service/expense_item_service.dart';

class ExpenseItemsProvider extends ChangeNotifier {
  late final Future<ExpenseItemService> _expenseItemService;

  static final Logger _logger =
      Logger(printer: SimplePrinter(), level: Level.info);

  ExpenseItemsProvider() {
    _init();
  }

  Future<void> _init() async {
    _expenseItemService = ExpenseItemService.create();
  }

  List<ExpenseItemFormModel> _expenseItems = [];
  List<ExpenseItemFormModel> _expenseItemsDeleted = [];

  /// get list of all expenseItems
  List<ExpenseItemFormModel> get expenseItems => _expenseItems;

  List<ExpenseItemFormModel> get expenseItemsDeleted => _expenseItemsDeleted;

  List<int> get expenseItemsDeletedIds {
    List<int> ids = [];
    for (var expenseItem in _expenseItemsDeleted) {
      ids.add(expenseItem.id!);
    }
    return ids;
  }

  /// add an expense item.
  void addExpenseItem(ExpenseItemFormModel expenseItem) {
    _expenseItems.insert(0, expenseItem);
    notifyListeners();
  }

  /// delete an expense by uuid.
  void deleteExpenseItem(String uuid) {
    _expenseItemsDeleted.add(
        _expenseItems.firstWhere((expenseItem) => expenseItem.uuid == uuid));
    _expenseItems.removeWhere((expenseItem) => expenseItem.uuid == uuid);
    notifyListeners();
  }

  /// refresh expense Items from db
  Future<void> fetchExpenseItems(
      {required int expenseId, bool notify = true}) async {
    try {
      ExpenseItemService service = await _expenseItemService;
      _expenseItems = await service.getExpenseItemsForEdit(expenseId);

      if (notify) notifyListeners();
    } catch (e, stackTrace) {
      _logger.e('Error refreshing expenses: $e - \n$stackTrace');
    }
  }
}
