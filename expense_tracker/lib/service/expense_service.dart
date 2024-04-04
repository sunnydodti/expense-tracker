import '../data/database/database_helper.dart';
import '../data/database/expense_helper.dart';
import '../models/expense.dart';

class ExpenseService {
  late final DatabaseHelper _databaseHelper;
  late final ExpenseHelper _expenseHelper;

  ExpenseService._(this._databaseHelper, this._expenseHelper);

  static Future<ExpenseService> create() async {
    final databaseHelper = DatabaseHelper();
    await databaseHelper.initializeDatabase();
    final expenseHelper = await databaseHelper.expenseHelper;
    return ExpenseService._(databaseHelper, expenseHelper);
  }

  Future<bool> addExpense(ExpenseFormModel expense) async {
    int id = await _expenseHelper.addExpense(expense);
    return id > 0 ? true : false;
  }

  Future<bool> updateExpense(ExpenseFormModel expense) async {
    int result = await _expenseHelper.updateExpense(expense);
    return result > 0 ? true : false;
  }

  Future<List<Expense>> fetchExpenses() async {
    return _expenseHelper.getExpenses();
  }

  Future<int> deleteAllExpenses() async {
    return _expenseHelper.deleteAllExpenses();
  }
}
