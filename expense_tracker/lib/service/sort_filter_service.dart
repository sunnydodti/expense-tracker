import 'package:expense_tracker/models/enums/sort_criteria.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../data/constants/shared_preferences_constants.dart';
import '../data/helpers/shared_preferences_helper.dart';
import '../main.dart';
import '../models/expense.dart';
import '../providers/sort_filter_provider.dart';

class SortFilterService {
  SortFilterProvider sortFilterProvider =
      navigatorKey.currentContext!.read<SortFilterProvider>();

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
      _logger.e("error retrieving sort criteria from shared preferences");
    }
    return sortCriteria;
  }

  setSortCriteria(SortCriteria sortCriteria) async {
    SharedPreferencesHelper.setString(
        SharedPreferencesConstants.sort.SORT_CRITERIA_KEY, sortCriteria.name);
  }

  /// sort and filter expenses
  List<Expense> sortAndFilter<T>(List<Expense> expenses) {
    final sortedByDate = sortExpenses(expenses);
    return sortedByDate;
  }

  List<Expense> sortExpenses(List<Expense> expenses) {
    List<Expense> sortedExpenses = expenses;
    SortCriteria sortCriteria = sortFilterProvider.sortCriteria;
    switch (sortCriteria) {
      case SortCriteria.createdDate:
        sortedExpenses.sort((a, b) {
          final compareValue = a.createdAt.compareTo(b.createdAt);
          return compareValue * (sortFilterProvider.isAscendingSort ? 1 : -1);
        });
        break;
      case SortCriteria.modifiedDate:
        sortedExpenses.sort((a, b) {
          final compareValue = a.modifiedAt.compareTo(b.modifiedAt);
          return compareValue * (sortFilterProvider.isAscendingSort ? 1 : -1);
        });
        break;
      case SortCriteria.expenseDate:
        sortedExpenses.sort((a, b) {
          final compareValue = a.date.compareTo(b.date);
          return compareValue * (sortFilterProvider.isAscendingSort ? 1 : -1);
        });
        break;
    }
    return sortedExpenses;
  }
}
