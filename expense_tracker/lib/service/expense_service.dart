import 'package:expense_tracker/data/database/database_helper.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/models/expense_new.dart';

class ExpenseService {
  static final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<bool> addExpense(ExpenseFormModel expense) async {
    int id = await _databaseHelper.addExpense(expense);
    return id > 0 ? true : false;
  }

  Future<bool> updateExpense(ExpenseFormModel expense) async {
    int result = await _databaseHelper.updateExpense(expense);
    return result > 0 ? true : false;
  }

  Future<List<ExpenseV2>> getExpenses() async {
    List<Map<String, dynamic>> expenseList = await _databaseHelper.getExpenseMapList();
    return _mapToModelList(expenseList);
  }

  Future<List<Expense>> fetchExpenses() async {
    return _databaseHelper.getExpenses();
  }

  List<ExpenseV2> _mapToModelList(List<Map<String, dynamic>> expenseMapList) =>
    expenseMapList.map((expenseMap) => ExpenseV2.fromMap(expenseMap)).toList();

  Future<int> deleteAllExpenses() async {
    return _databaseHelper.deleteAllExpenses();
  }

}