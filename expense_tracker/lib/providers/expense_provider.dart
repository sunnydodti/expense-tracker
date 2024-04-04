import 'package:expense_tracker/service/expense_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/expense.dart';
import '../models/enums/transaction_type.dart';

class ExpenseProvider extends ChangeNotifier {
  late final Future<ExpenseService> _expenseService;

  ExpenseProvider() {
    _init();
  }

  Future<void> _init() async {
    _expenseService = ExpenseService.create();
  }

  // List<Expense> _expenses = Expense.fromMapList(_expenseMapList());
  List<Expense> _expenses = [];

  /// get list of all expenses
  List<Expense> get expenses => _expenses;

  /// returns the total balance after all expenses
  double getTotalBalance() {
    double totalIncome = 0;
    double totalExpense = 0;
    double totalReimbursement = 0;

    // Iterate through expenses and sum amounts based on transaction type
    for (var expense in _expenses) {
      if (expense.transactionType == TransactionType.expense.name) {
        totalExpense += expense.amount;
        continue;
      }
      if (expense.transactionType == TransactionType.income.name) {
        totalIncome += expense.amount;
        continue;
      }
      if (expense.transactionType == TransactionType.reimbursement.name) {
        totalReimbursement += expense.amount;
        continue;
      }
    }

    // Calculate total balance
    double totalBalance = totalIncome - totalExpense - totalReimbursement;
    return totalBalance;
  }

  /// returns the sum of all income
  double getTotalIncome() {
    double totalIncome = 0;
    for (var expense in _expenses) {
      if (expense.transactionType == TransactionType.income.name) {
        totalIncome += expense.amount;
      }
    }
    return totalIncome;
  }

  /// returns the sum of all expense
  double getTotalExpenses() {
    double totalExpenses = 0;
    for (var expense in _expenses) {
      if (expense.transactionType == TransactionType.expense.name) {
        totalExpenses += expense.amount;
      }
    }
    return totalExpenses;
  }

  /// add an expense. this does not add in db
  void addExpense(Expense expense) {
    _expenses.add(expense);
    notifyListeners();
  }

  /// insert an expense. this does not insert in db
  void insertExpense(int index, Expense expense) {
    _expenses.insert(index, expense);
    notifyListeners();
  }

  /// get expense by id. this does not get from db
  Expense? getExpense(int id) {
    try {
      return _expenses.firstWhere((expense) => expense.id == id);
    } catch (e) {
      return null;
    }
  }

  /// edit an expense. this does not edit in db
  void editExpense(Expense editedExpense) {
    final index =
        _expenses.indexWhere((expense) => expense.id == editedExpense.id);
    if (index != -1) {
      _expenses[index] = editedExpense;
      notifyListeners();
    }
  }

  /// delete an expense at index. this does not delete in db
  void deleteExpense(int id) {
    _expenses.removeWhere((expense) => expense.id == id);
    notifyListeners();
  }

  ///delete all expense. this does not delete in db
  void _deleteExpenses() async {
    ExpenseService expenseService = await _expenseService;
    expenseService.deleteAllExpenses();
    _expenses = [];
    notifyListeners();
  }

  /// refresh expenses from db
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
    ExpenseService expenseService = await _expenseService;
    return await expenseService.fetchExpenses();
  }
}

