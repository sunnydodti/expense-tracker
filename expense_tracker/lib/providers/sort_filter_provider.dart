import 'package:flutter/material.dart';

import '../models/enums/sort_criteria.dart';
import '../service/sort_filter_service.dart';

class SortFilterProvider extends ChangeNotifier {
  final SortFilterService _sortFilterService = SortFilterService.create();

  final SortCriteria _defaultSortCriteria = SortCriteria.modifiedDate;

  SortCriteria _sortCriteria = SortCriteria.modifiedDate;

  SortCriteria get sortCriteria => _sortCriteria;

  setSortCriteria(SortCriteria sortCriteria) {
    _sortCriteria = sortCriteria;
    _sortFilterService.setPreferenceSortCriteria(sortCriteria);
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
    _sortFilterService.setPreferenceIsAscendingSort(isAscendingSort);
    notifyListeners();
  }

  refreshPreferences() async {
    SortCriteria? sortCriteria =
        await _sortFilterService.getPreferenceSortCriteria();
    bool? isAscendingSort =
        await _sortFilterService.getIsPreferenceIsAscendingSort();
    _sortCriteria = sortCriteria ?? _sortCriteria;
    _isAscendingSort = isAscendingSort ?? _isAscendingSort;
    // notifyListeners();
  }
}
