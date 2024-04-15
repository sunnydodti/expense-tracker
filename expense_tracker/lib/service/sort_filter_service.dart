import 'package:expense_tracker/models/enums/sort_criteria.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

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

  /// sorting and filtering
  List<Expense> sortAndFilter<T>(List<Expense> expenses) {
    // final filterFunction = (item) => item['price'] > 10; // Filter based on price

    // final filteredData = expenses.where((item) => filterFunction(item)).toList();

    final sortedByDate = sortExpenses(expenses);
    return sortedByDate;
  }

  List<Expense> sortExpenses(List<Expense> expenses) {
    List<Expense> sortedExpenses = expenses;

    switch (sortFilterProvider.sortCriteria) {
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
