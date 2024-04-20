import 'package:faker/faker.dart';
import 'package:logger/logger.dart';

import '../data/constants/db_constants.dart';
import '../data/helpers/database/database_helper.dart';
import '../data/helpers/database/expense_helper.dart';
import '../models/enums/sort_criteria.dart';
import '../models/expense.dart';
import '../models/expense_filters.dart';
import 'sort_filter_service.dart';

class ExpenseService {
  late final ExpenseHelper _expenseHelper;
  static final Logger _logger =
      Logger(printer: SimplePrinter(), level: Level.info);
  final SortFilterService sortFilterService = SortFilterService.create();

  ExpenseService._(this._expenseHelper);

  static Future<ExpenseService> create() async {
    final databaseHelper = DatabaseHelper();
    await databaseHelper.initializeDatabase();
    final expenseHelper = await databaseHelper.expenseHelper;
    return ExpenseService._(expenseHelper);
  }

  Future<bool> addExpense(ExpenseFormModel expense) async {
    try {
      int id = await _expenseHelper.addExpense(expense.toMap());
      return id > 0 ? true : false;
    } on Exception catch (e, stackTrace) {
      _logger.e("Error adding expense (${expense.title}): $e - \n$stackTrace");
      return false;
    }
  }

  Future<Expense?> getExpense(int id) async {
    try {
      final List<Map<String, dynamic>> expenses =
          await _expenseHelper.getExpense(id);
      return Expense.fromMap(expenses.first);
    } catch (e, stackTrace) {
      _logger.e("Error getting expense ($id) - $e - \n$stackTrace");
      return null;
    }
  }

  Future<bool> updateExpense(ExpenseFormModel expense) async {
    try {
      int result = await _expenseHelper.updateExpense(expense);
      return result > 0 ? true : false;
    } on Exception catch (e, stackTrace) {
      _logger
          .e("Error updating expense (${expense.title}): $e - \n$stackTrace");
      return false;
    }
  }

  Future<List<Expense>> getExpenses() async {
    List<Map<String, dynamic>> expenseMapList =
        await _expenseHelper.getExpenses();
    return expenseMapList
        .map((expenseMap) => Expense.fromMap(expenseMap))
        .toList();
  }

  Future<List<Expense>> getSortedAndFilteredExpenses() async {
    SortCriteria? sortCriteria =
        await sortFilterService.getPreferenceSortCriteria();
    bool? isAscendingSort =
        await sortFilterService.getPreferenceIsAscendingSort();
    ExpenseFilters expenseFilters = await sortFilterService.getExpenseFilters();

    List<Map<String, dynamic>> expenseMapList =
        await _expenseHelper.getSortedAndFilteredExpenses(
            sortCriteria!, isAscendingSort!, expenseFilters);

    List<Expense> expenses = expenseMapList
        .map((expenseMap) => Expense.fromMap(expenseMap))
        .toList();
    // _expenses = await sortFilterService.sortAndFilter(updatedExpenses);
    return expenses;
  }

  Future<List<Map<String, dynamic>>> getExpenseMaps() async {
    try {
      return await _expenseHelper.getExpenses();
    } on Exception catch (e, stackTrace) {
      _logger.e("Error getting expenses: $e - \n$stackTrace");
      return [];
    }
  }

  Future<int> deleteAllExpenses() async {
    try {
      return _expenseHelper.deleteAllExpenses();
    } on Exception catch (e, stackTrace) {
      _logger.e("Error deleting expenses: $e - \n$stackTrace");
      return -1;
    }
  }

  Future<void> populateExpense({int count = 1}) async {
    try {
      List<Map<String, dynamic>> expenseMapList = [];
      for (int i = 0; i <= count - 1; i++) {
        var expense = generateRandomExpense();
        expenseMapList.add(expense);
      }
      await _expenseHelper.populateExpense(
        expenseMapList,
      );
    } on Exception catch (e, stackTrace) {
      _logger.e("Error populating expense: $e - \n$stackTrace");
    }
  }

  Map<String, dynamic> generateRandomExpense() {
    double amount = faker.randomGenerator.decimal() * (1000.0 - 1.0) + 1.0;
    var expense = {
      DBConstants.expense.title: faker.food.dish(),
      DBConstants.expense.currency: "INR",
      DBConstants.expense.amount: double.parse(amount.toStringAsFixed(2)),
      DBConstants.expense.transactionType:
          faker.randomGenerator.boolean() ? 'income' : 'expense',
      DBConstants.expense.date: faker.date.dateTime().toIso8601String(),
      DBConstants.expense.category:
          faker.randomGenerator.boolean() ? 'Food' : 'Shopping',
      DBConstants.expense.tags:
          faker.randomGenerator.boolean() ? 'home' : 'work',
      DBConstants.expense.note: faker.lorem.sentence(),
      DBConstants.expense.containsNestedExpenses:
          faker.randomGenerator.boolean() ? 1 : 0,
      DBConstants.expense.expenses: 'Nested expenses data',
      // Add appropriate nested expenses data
      DBConstants.expense.createdAt: faker.date.dateTime().toIso8601String(),
      DBConstants.expense.modifiedAt: faker.date.dateTime().toIso8601String(),
    };
    return expense;
  }

  Future<bool> importExpense(Map<String, dynamic> expense) async {
    try {
      if (await _expenseHelper.addExpense(expense) > 0) return true;
    } on Exception catch (e, stackTrace) {
      _logger.e(
          "Error importing expense (${expense[DBConstants.expense.title]}): $e - \n$stackTrace");
    }
    return false;
  }

  Future<bool> importExpenseV2(Map<String, dynamic> expense,
      {safeImport = true}) async {
    _logger.i(
        "importing expense ${expense[DBConstants.expense.id]} - ${expense[DBConstants.expense.title]}");
    try {
      Expense expenseI = Expense.fromMap(expense);
      if (await isDuplicateExpense(expenseI)) {
        _logger.i("found duplicate expense: ${expenseI.title}");
        if (safeImport) return false;
        _logger.i("safeImport: $safeImport - discarding existing expense");
        await _expenseHelper.deleteExpense(expenseI.id);
      }
      if (await _expenseHelper.addExpense(expense) > 0) {
        _logger.i("imported expense ${expenseI.title}");
        return true;
      }
    } on Exception catch (e, stackTrace) {
      _logger.e(
          "Error importing expense (${expense[DBConstants.expense.title]}): $e - \n$stackTrace");
    }
    return false;
  }

  Future<bool> isDuplicateExpense(Expense expense) async {
    Expense? existingExpense = await getExpense(expense.id);
    if (existingExpense == null) return false;
    if (existingExpense.title == expense.title &&
        existingExpense.amount == expense.amount) return true;
    return false;
  }
}
