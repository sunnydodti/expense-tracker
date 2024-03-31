import 'package:expense_tracker/service/expense_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/expense_new.dart';

class ExpenseProvider extends ChangeNotifier {
  final ExpenseService _expenseService = ExpenseService();

  // List<Expense> _expenses = Expense.fromMapList(_expenseMapList());
  List<Expense> _expenses = [];

  List<Expense> get expenses => _expenses;

  void addExpense(Expense expense) {
    _expenses.add(expense);
    notifyListeners();
  }

  void insertExpense(int index, Expense expense) {
    _expenses.insert(index, expense);
    notifyListeners();
  }

  Expense? getExpense(int id) {
    try {
      return _expenses.firstWhere((expense) => expense.id == id);
    } catch (e) {
      return null;
    }
  }

  void editExpense(Expense editedExpense) {
    final index = _expenses.indexWhere((expense) => expense.id == editedExpense.id);
    if (index != -1) {
      _expenses[index] = editedExpense;
      notifyListeners();
    }
  }

  void deleteExpense(int id) {
    _expenses.removeWhere((expense) => expense.id == id);
    notifyListeners();
  }

  void _deleteExpenses() {
    _expenseService.deleteAllExpenses();
    _expenses = [];
    notifyListeners();
  }

  Future<void> refreshExpenses({bool notify = true}) async {
    try {
      List<Expense> updatedExpenses = await _fetchExpenses();
      _expenses = updatedExpenses;

      if (notify) notifyListeners();

    } catch (e) {
      debugPrint('Error refreshing expenses: $e');
    }
  }

  Future<List<Expense>> _fetchExpenses() async {
    return _expenseService.fetchExpenses();
  }

  static List<Map<String, dynamic>> _expenseMapList() {
    return [];

    // return [
    //   {
    //     'title': 'Butter chicken',
    //     'currency': '₹',
    //     'amount': 721.86,
    //     'transaction_type': 'income',
    //     'date': '1637-10-24T12:52:38.207182',
    //     'category': 'Food',
    //     'tags': 'home',
    //     'note': 'Sodales ut eu sem integer vitae.',
    //     'contains_nested_expenses': false,
    //     'expenses': 'Nested expenses data',
    //     'createdAt' : DateTime.now().toIso8601String(),
    //     'modifiedAt' : DateTime.now().toIso8601String(),
    //   },
    //   {
    //     'title': 'Cream pie',
    //     'currency': '₹',
    //     'amount': 385.9,
    //     'transaction_type': 'income',
    //     'date': '2560-09-06T08:25:25.700878',
    //     'category': 'Food',
    //     'tags': 'home',
    //     'note': 'Volutpat commodo sed egestas egestas fringilla phasellus.',
    //     'contains_nested_expenses': false,
    //     'expenses': 'Nested expenses data',
    //     'createdAt' : DateTime.now().toIso8601String(),
    //     'modifiedAt' : DateTime.now().toIso8601String(),
    //   },
    //   {
    //     'title': 'Biryani',
    //     'currency': '₹',
    //     'amount': 317.22,
    //     'transaction_type': 'income',
    //     'date': '1410-10-04T12:16:05.011882',
    //     'category': 'Food',
    //     'tags': 'work',
    //     'note': 'Adipiscing elit pellentesque habitant morbi tristique senectus et netus.',
    //     'contains_nested_expenses': false,
    //     'expenses': 'Nested expenses data',
    //     'createdAt' : DateTime.now().toIso8601String(),
    //     'modifiedAt' : DateTime.now().toIso8601String(),
    //   },
    //   {
    //     'title': 'Mie goreng',
    //     'currency': '₹',
    //     'amount': 393.1,
    //     'transaction_type': 'expense',
    //     'date': '2033-05-30T07:12:06.227737',
    //     'category': 'Food',
    //     'tags': 'home',
    //     'note': 'Sagittis id consectetur purus ut faucibus pulvinar elementum integer.',
    //     'contains_nested_expenses': false,
    //     'expenses': 'Nested expenses data',
    //     'createdAt' : DateTime.now().toIso8601String(),
    //     'modifiedAt' : DateTime.now().toIso8601String(),
    //   },
    // ];
  }
}
