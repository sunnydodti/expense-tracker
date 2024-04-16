import 'package:expense_tracker/models/enums/sort_criteria.dart';
import 'package:logger/logger.dart';

import '../data/constants/shared_preferences_constants.dart';
import '../data/helpers/shared_preferences_helper.dart';
import '../models/expense.dart';

class SortFilterService {
  static final Logger _logger =
      Logger(printer: SimplePrinter(), level: Level.info);

  SortFilterService._();

  static SortFilterService create() {
    return SortFilterService._();
  }

  Future<SortCriteria?> getSortCriteria() async {
    SortCriteria? sortCriteria;
    try {
      String? storedSortCriteria = await SharedPreferencesHelper.getString(
          SharedPreferencesConstants.sort.SORT_CRITERIA_KEY);
      sortCriteria =
          SortCriteriaHelper.getSortCriteriaByName(storedSortCriteria!);
    } catch (e, stackTrace) {
      _logger.e("error retrieving sort criteria from shared preferences at getSortCriteria(): $e - $stackTrace");
    }
    return sortCriteria;
  }

  setSortCriteria(SortCriteria sortCriteria) {
    SharedPreferencesHelper.setString(
        SharedPreferencesConstants.sort.SORT_CRITERIA_KEY, sortCriteria.name);
  }

  /// sort and filter expenses
  Future<List<Expense>> sortAndFilter<T>(List<Expense> expenses) {
    final sortedByDate = sortExpenses(expenses);
    return sortedByDate;
  }

  Future<List<Expense>> sortExpenses(List<Expense> expenses) async {
    String? criteria = await SharedPreferencesHelper.getString(SharedPreferencesConstants.sort.SORT_CRITERIA_KEY);
    if (criteria == null) {
      return expenses;
    }
    SortCriteria sortCriteria = SortCriteriaHelper.getSortCriteriaByName(criteria);
    bool isAscending = await SharedPreferencesHelper.getBool(SharedPreferencesConstants.sort.IS_ASCENDIND_SORT_KEY) ?? false;
    switch (sortCriteria) {
      case SortCriteria.createdDate:
        expenses.sort((a, b) {
          final compareValue = a.createdAt.compareTo(b.createdAt);
          return compareValue * (isAscending ? 1 : -1);
        });
        break;
      case SortCriteria.modifiedDate:
        expenses.sort((a, b) {
          final compareValue = a.modifiedAt.compareTo(b.modifiedAt);
          return compareValue * (isAscending ? 1 : -1);
        });
        break;
      case SortCriteria.expenseDate:
        expenses.sort((a, b) {
          final compareValue = a.date.compareTo(b.date);
          return compareValue * (isAscending ? 1 : -1);
        });
        break;
    }
    return expenses;
  }
}
