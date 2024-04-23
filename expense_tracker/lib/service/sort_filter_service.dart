import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import '../data/constants/shared_preferences_constants.dart';
import '../models/enums/sort_criteria.dart';
import '../models/expense.dart';
import '../models/expense_filters.dart';
import 'shared_preferences_service.dart';

class SortFilterService extends SharedPreferencesService {
  static final Logger _logger =
      Logger(printer: SimplePrinter(), level: Level.info);

  SortFilterService._();

  static SortFilterService create() {
    return SortFilterService._();
  }

  //region Section 1: --------------------------------- sort preferences ---------------------------------
  setPreferenceIsAscendingSort(bool isAscendingSort) {
    SharedPreferencesService.setBoolPreference(
        SharedPreferencesConstants.sort.IS_ASCENDIND_KEY, isAscendingSort);
  }

  setPreferenceSortCriteria(SortCriteria sortCriteria) {
    SharedPreferencesService.setStringPreference(
        SharedPreferencesConstants.sort.CRITERIA_KEY, sortCriteria.name);
  }

  Future<SortCriteria?> getPreferenceSortCriteria() async {
    SortCriteria? sortCriteria;
    try {
      String? storedSortCriteria =
          await SharedPreferencesService.getStringPreference(
              SharedPreferencesConstants.sort.CRITERIA_KEY);
      sortCriteria =
          SortCriteriaHelper.getSortCriteriaByName(storedSortCriteria!);
    } catch (e, stackTrace) {
      _logger.e(
          "error retrieving sort criteria from shared preferences at getPreferenceSortCriteria(): $e - \n$stackTrace");
    }
    return sortCriteria;
  }

  Future<bool?> getPreferenceIsAscendingSort() async {
    bool? isAscendingSort;
    try {
      isAscendingSort = await SharedPreferencesService.getBoolPreference(
          SharedPreferencesConstants.sort.IS_ASCENDIND_KEY);
    } catch (e, stackTrace) {
      _logger.e(
          "error retrieving is ascending sort from shared preferences at getPreferenceIsAscendingSort(): $e - \n$stackTrace");
    }
    return isAscendingSort;
  }

  //endregion

  //region Section 1: --------------------------------- filter preferences ---------------------------------
  void setPreferenceIsFilterApplied(bool isFilterApplied) {
    SharedPreferencesService.setBoolPreference(
        SharedPreferencesConstants.filter.IS_APPLIED_KEY, isFilterApplied);
  }

  void setPreferenceIsFilterByYear(bool isFilterByYear) {
    SharedPreferencesService.setBoolPreference(
        SharedPreferencesConstants.filter.IS_BY_YEAR_KEY, isFilterByYear);
  }

  void setPreferenceIsFilterByMonth(bool isFilterByMonth) {
    SharedPreferencesService.setBoolPreference(
        SharedPreferencesConstants.filter.IS_BY_MONTH_KEY, isFilterByMonth);
  }

  void setPreferenceFilterYear(String filterYear) {
    SharedPreferencesService.setStringPreference(
        SharedPreferencesConstants.filter.YEAR_KEY, filterYear);
  }

  void setPreferenceFilterMonth(String filterMonth) {
    SharedPreferencesService.setStringPreference(
        SharedPreferencesConstants.filter.MONTH_KEY, filterMonth);
  }

  Future<bool?> getPreferenceIsFilterApplied() async {
    bool? isFilterApplied;
    try {
      isFilterApplied = await SharedPreferencesService.getBoolPreference(
          SharedPreferencesConstants.filter.IS_APPLIED_KEY);
    } catch (e, stackTrace) {
      _logger.e(
          "error retrieving is filter applied from shared preferences at getPreferenceIsFilterApplied(): $e - \n$stackTrace");
    }
    return isFilterApplied;
  }

  Future<bool?> getPreferenceIsFilterByYear() async {
    bool? isFilterByYear;
    try {
      isFilterByYear = await SharedPreferencesService.getBoolPreference(
          SharedPreferencesConstants.filter.IS_BY_YEAR_KEY);
    } catch (e, stackTrace) {
      _logger.e(
          "error retrieving is filter by year from shared preferences at getPreferenceIsFilterByYear(): $e - \n$stackTrace");
    }
    return isFilterByYear;
  }

  Future<bool?> getPreferenceIsFilterByMonth() async {
    bool? isFilterByMonth;
    try {
      isFilterByMonth = await SharedPreferencesService.getBoolPreference(
          SharedPreferencesConstants.filter.IS_BY_MONTH_KEY);
    } catch (e, stackTrace) {
      _logger.e(
          "error retrieving is filter by month from shared preferences at getPreferenceIsFilterByMonth(): $e - \n$stackTrace");
    }
    return isFilterByMonth;
  }

  Future<String?> getPreferenceFilterYear() async {
    String? filterYear;
    try {
      filterYear = await SharedPreferencesService.getStringPreference(
          SharedPreferencesConstants.filter.YEAR_KEY);
    } catch (e, stackTrace) {
      _logger.e(
          "error retrieving filter year from shared preferences at getPreferenceFilterYear(): $e - \n$stackTrace");
    }
    return filterYear;
  }

  Future<String?> getPreferenceFilterMonth() async {
    String? filterMonth;
    try {
      filterMonth = await SharedPreferencesService.getStringPreference(
          SharedPreferencesConstants.filter.MONTH_KEY);
    } catch (e, stackTrace) {
      _logger.e(
          "error retrieving filter month from shared preferences at getPreferenceFilterMonth(): $e - \n$stackTrace");
    }
    return filterMonth;
  }

  //endregion

  /// sort and filter expenses
  Future<List<Expense>> sortAndFilter<T>(List<Expense> expenses) async {
    final filteredExpenses = await filterExpenses(expenses);
    final sortedExpenses = await sortExpenses(filteredExpenses);
    return sortedExpenses;
  }

  Future<List<Expense>> sortExpenses(List<Expense> expenses) async {
    String? criteria = await SharedPreferencesService.getStringPreference(
        SharedPreferencesConstants.sort.CRITERIA_KEY);
    if (criteria == null) {
      return expenses;
    }
    SortCriteria sortCriteria =
        SortCriteriaHelper.getSortCriteriaByName(criteria);
    bool isAscending = await SharedPreferencesService.getBoolPreference(
            SharedPreferencesConstants.sort.IS_ASCENDIND_KEY) ??
        false;
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

  Future<List<Expense>> filterExpenses(List<Expense> expenses) async {
    ExpenseFilters filters = await getExpenseFilters();
    if (!filters.isApplied) {
      return expenses;
    }

    List<Expense> filteredExpenses = List.from(expenses);

    // Filter by year
    if (filters.filterByYear) {
      final filterYear = filters.selectedYear;
      filteredExpenses = filteredExpenses.where((expense) {
        return DateFormat('yyyy').format(expense.date) == filterYear;
      }).toList();
    }

    // Filter by month
    if (filters.filterByMonth) {
      final filterMonth = filters.selectedMonth;
      filteredExpenses = filteredExpenses.where((expense) {
        return DateFormat('MMMM').format(expense.date) == filterMonth;
      }).toList();
    }

    return filteredExpenses;
  }

  Future<ExpenseFilters> getExpenseFilters() async {
    ExpenseFilters expenseFilters = ExpenseFilters();

    bool? isFilterApplied = await getPreferenceIsFilterApplied();
    bool? isFilterByYear = await getPreferenceIsFilterByYear();
    bool? isFilterByMonth = await getPreferenceIsFilterByMonth();
    String? filterYear = await getPreferenceFilterYear();
    String? filterMonth = await getPreferenceFilterMonth();

    expenseFilters.isApplied = isFilterApplied ?? expenseFilters.isApplied;
    expenseFilters.filterByYear = isFilterByYear ?? expenseFilters.filterByYear;
    expenseFilters.filterByMonth =
        isFilterByMonth ?? expenseFilters.filterByMonth;
    expenseFilters.selectedYear = filterYear ?? expenseFilters.selectedYear;
    expenseFilters.selectedMonth = filterMonth ?? expenseFilters.selectedMonth;

    return expenseFilters;
  }
}
