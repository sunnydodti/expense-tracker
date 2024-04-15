import 'package:flutter/material.dart';

import '../models/enums/sort_criteria.dart';

class SortFilterProvider extends ChangeNotifier {
  // ExpenseProvider expenseProvider =
  //     navigatorKey.currentContext!.read<ExpenseProvider>();

  SortCriteria _sortCriteria = SortCriteria.modifiedDate;

  SortCriteria get sortCriteria => _sortCriteria;

  setSortCriteria(SortCriteria value) {
    _sortCriteria = value;
    notifyListeners();
  }

  bool _isAscendingSort = false;

  bool get isAscendingSort => _isAscendingSort;

  setIsAscendingSort(bool value) {
    _isAscendingSort = value;
    notifyListeners();
  }

  toggleSort() {
    _isAscendingSort = !_isAscendingSort;
    notifyListeners();
  }
}
