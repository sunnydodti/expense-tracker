import 'package:expense_tracker/data/database/database_helper.dart';
import 'package:expense_tracker/models/expense.dart';

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

  Future<List<Expense>> fetchExpenses() async {
    return _databaseHelper.getExpenses();
  }

  Future<int> deleteAllExpenses() async {
    return _databaseHelper.deleteAllExpenses();
  }

}