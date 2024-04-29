import 'package:flutter/foundation.dart';

import '../models/expense_item.dart';

class ExpenseItemsProvider extends ChangeNotifier {

  ExpenseItemsProvider() {
    _init();
  }

  Future<void> _init() async {}

  final List<ExpenseItemFormModel> _expenseItems = [];

  /// get list of all expenseItems
  List<ExpenseItemFormModel> get expenseItems => _expenseItems;

  /// add an expense item.
  void addExpenseItem(ExpenseItemFormModel expenseItem) {
    _expenseItems.insert(0, expenseItem);
    notifyListeners();
  }

  /// delete an expense by uuid.
  void deleteExpenseItem(String uuid) {
    _expenseItems.removeWhere((expenseItem) => expenseItem.uuid == uuid);
    notifyListeners();
  }
}
