import 'package:flutter/material.dart';

import '../models/enums/sort_criteria.dart';

class SortFilterProvider extends ChangeNotifier {
  final SortCriteria _defaultSortCriteria = SortCriteria.modifiedDate;

  SortCriteria _sortCriteria = SortCriteria.modifiedDate;

  SortCriteria get sortCriteria => _sortCriteria;

  // Future<SortCriteria> getSortCriteria() async {
  //  return _defaultSortCriteria;
  // }

  setSortCriteria(SortCriteria sortCriteria) {
    _sortCriteria = sortCriteria;
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
    // SharedPreferencesHelper.setBool(
    //     SharedPreferencesConstants.sort.IS_ASCENDIND_SORT_KEY,
    //     _isAscendingSort);
  }
}
