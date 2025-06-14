import 'package:faker/faker.dart';
import 'package:logger/logger.dart';

import '../data/constants/db_constants.dart';
import '../data/helpers/database/database_helper.dart';
import '../data/helpers/database/expense_helper.dart';
import '../models/enums/sort_criteria.dart';
import '../models/expense.dart';
import '../models/expense_filters.dart';
import '../models/expense_item.dart';
import '../models/profile.dart';
import '../models/user.dart';
import '../providers/expense_items_provider.dart';
import 'expense_item_service.dart';
import 'profile_service.dart';
import 'sort_filter_service.dart';
import 'user_service.dart';

class ExpenseService {
  late final ExpenseHelper _expenseHelper;
  late final Future<ExpenseItemService> _expenseItemService;
  late final Future<ProfileService> _profileService;
  late final Future<UserService> _userService;

  static final Logger _logger =
      Logger(printer: SimplePrinter(), level: Level.info);
  final SortFilterService sortFilterService = SortFilterService.create();

  ExpenseService._(this._expenseHelper) {
    _expenseItemService = ExpenseItemService.create();
    _profileService = ProfileService.create();
    _userService = UserService.create();
  }

  static Future<ExpenseService> create() async {
    final databaseHelper = DatabaseHelper();
    await databaseHelper.initializeDatabase();
    final expenseHelper = await databaseHelper.expenseHelper;
    return ExpenseService._(expenseHelper);
  }

  Future<bool> addExpense(ExpenseFormModel expense,
      ExpenseItemsProvider expenseItemProvider) async {
    try {
      int? userId = await getUserId();
      int? profileId = await getProfileId();
      expense.userId = userId;
      expense.profileId = profileId;
      int id = await _expenseHelper.addExpense(expense.toMap());
      if (expense.containsExpenseItems) {
        if (expenseItemProvider.expenseItems.isNotEmpty) {
          List<ExpenseItemFormModel> expenseItems =
              expenseItemProvider.expenseItems;
          for (var expenseItem in expenseItems) {
            expenseItem.expenseId = id;
          }
          ExpenseItemService expenseItemService = await _expenseItemService;
          expenseItemService.addExpenseItems(expenseItems);
        }
      }
      return id > 0 ? true : false;
    } catch (e, stackTrace) {
      _logger.e("Error adding expense (${expense.title}): $e - \n$stackTrace");
      return false;
    }
  }

  Future<int?> getProfileId() async {
    int? id;
    try {
      ProfileService profileService = await _profileService;
      Profile? profile = await profileService.getSelectedProfile();
      id = profile!.id;
    } catch (e, stackTrace) {
      _logger.e("Error getting profile: $e - \n$stackTrace");
      return 0;
    }
    return id;
  }

  Future<int> getUserId() async {
    try {
      UserService userService = await _userService;
      User? user = await userService.getSelectedUser();
      return user!.id;
    } catch (e, stackTrace) {
      _logger.e("Error getting user: $e - \n$stackTrace");
      return 0;
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

  Future<bool> updateExpense(ExpenseFormModel expense,
      ExpenseItemsProvider expenseItemsProvider) async {
    try {
      int result = await _expenseHelper.updateExpense(expense);
      if (expense.containsExpenseItems) {
        if (expenseItemsProvider.expenseItems.isNotEmpty) {
          List<ExpenseItemFormModel> expenseItems =
              expenseItemsProvider.expenseItems;
          for (var expenseItem in expenseItems) {
            expenseItem.expenseId = expense.id;
          }
          ExpenseItemService expenseItemService = await _expenseItemService;
          expenseItemService.updateExpenseItems(expenseItems);
        }

        if (expenseItemsProvider.expenseItemsDeleted.isNotEmpty) {
          ExpenseItemService expenseItemService = await _expenseItemService;
          expenseItemService
              .deleteExpenseItems(expenseItemsProvider.expenseItemsDeletedIds);
        }
      }
      return result > 0 ? true : false;
    } catch (e, stackTrace) {
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

  Future<List<Expense>> getExpensesForProfile() async {
    ProfileService profileService = await _profileService;
    Profile? profile = await profileService.getSelectedProfile();

    List<Map<String, dynamic>> expenseMapList =
        await _expenseHelper.getExpensesForProfile(profile!.id);
    return expenseMapList
        .map((expenseMap) => Expense.fromMap(expenseMap))
        .toList();
  }

  Future<List<Expense>> getSortedAndFilteredExpenses(Profile? profile) async {
    SortCriteria? sortCriteria =
        await sortFilterService.getPreferenceSortCriteria();
    bool? isAscendingSort =
        await sortFilterService.getPreferenceIsAscendingSort();
    ExpenseFilters expenseFilters = await sortFilterService.getExpenseFilters();
    List<Map<String, dynamic>> expenseMapList =
        await _expenseHelper.getSortedAndFilteredExpenses(
            sortCriteria!, isAscendingSort!, expenseFilters, profile);

    List<Expense> expenses = expenseMapList
        .map((expenseMap) => Expense.fromMap(expenseMap))
        .toList();
    return expenses;
  }

  Future<List<Map<String, dynamic>>> getExpenseMaps() async {
    try {
      return await _expenseHelper.getExpenses();
    } catch (e, stackTrace) {
      _logger.e("Error getting expenses: $e - \n$stackTrace");
      return [];
    }
  }

  Future<int> deleteExpense(int id) async {
    try {
      return _expenseHelper.deleteExpense(id);
    } catch (e, stackTrace) {
      _logger.e("Error deleting expense($id): $e - \n$stackTrace");
      return -1;
    }
  }

  Future<int> deleteAllExpenses() async {
    try {
      return _expenseHelper.deleteAllExpenses();
    } catch (e, stackTrace) {
      _logger.e("Error deleting expenses: $e - \n$stackTrace");
      return -1;
    }
  }

  Future<void> populateExpense({int count = 1}) async {
    try {
      List<Map<String, dynamic>> expenseMapList = [];
      for (int i = 0; i <= count - 1; i++) {
        var expense = await generateRandomExpense();
        expenseMapList.add(expense);
      }
      await _expenseHelper.populateExpense(
        expenseMapList,
      );
    } catch (e, stackTrace) {
      _logger.e("Error populating expense: $e - \n$stackTrace");
    }
  }

  Future<Map<String, dynamic>> generateRandomExpense(
      {int defaultProfile = 2,
      String category = 'Debug',
      String tag = 'auto generated'}) async {
    double amount = faker.randomGenerator.decimal() * (1000.0 - 1.0) + 1.0;
    int? profile = await getProfileId();
    String date = getDateInCurrentMonthUpToToday().toIso8601String();
    var expense = {
      DBConstants.expense.title: faker.food.dish(),
      DBConstants.expense.currency: "INR",
      DBConstants.expense.profileId: profile ?? defaultProfile,
      DBConstants.expense.amount: double.parse(amount.toStringAsFixed(2)),
      DBConstants.expense.transactionType:
          faker.randomGenerator.boolean() ? 'income' : 'expense',
      DBConstants.expense.date: date,
      DBConstants.expense.category: category,
      DBConstants.expense.tags: tag,
      DBConstants.expense.note: faker.lorem.sentence(),
      DBConstants.expense.containsExpenseItems:
          faker.randomGenerator.boolean() ? 1 : 0,
    };
    return expense;
  }

  DateTime getDateInCurrentMonthUpToToday() {
    final now = DateTime.now();

    final firstDay = DateTime(now.year, now.month, 1);

    final randomDays =
        faker.randomGenerator.integer(now.day - firstDay.day + 1, min: 1);

    return firstDay.add(Duration(days: randomDays));
  }

  Future<bool> importExpense(Map<String, dynamic> expense) async {
    try {
      if (await _expenseHelper.addExpense(expense) > 0) return true;
    } catch (e, stackTrace) {
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
    } catch (e, stackTrace) {
      _logger.e(
          "Error importing expense (${expense[DBConstants.expense.title]}): $e - \n$stackTrace");
    }
    return false;
  }

  Future<bool> isDuplicateExpense(Expense expense) async {
    Expense? existingExpense = await getExpense(expense.id);
    if (existingExpense == null) return false;
    if (existingExpense.title == expense.title &&
        existingExpense.amount == expense.amount) {
      return true;
    }
    return false;
  }

  Future<List<Expense>> searchExpenses(
      String? searchKey, Profile? profile) async {
    List<Expense> expenses = [];
    if (searchKey != null) {
      try {
        // SortCriteria? sortCriteria =
        //     await sortFilterService.getPreferenceSortCriteria();
        // bool? isAscendingSort =
        //     await sortFilterService.getPreferenceIsAscendingSort();
        // ExpenseFilters expenseFilters = await sortFilterService.getExpenseFilters();
        List<Map<String, dynamic>> expenseMapList =
            await _expenseHelper.searchExpenses(searchKey, profile);

        expenses = expenseMapList
            .map((expenseMap) => Expense.fromMap(expenseMap))
            .toList();
      } catch (e, stackTrace) {
        _logger.e("Error searching expenses ($searchKey): $e - \n$stackTrace");
      }
    }
    return expenses;
  }
}
