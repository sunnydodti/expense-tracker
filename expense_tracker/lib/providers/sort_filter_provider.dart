import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/enums/sort_criteria.dart';
import '../service/sort_filter_service.dart';

class SortFilterProvider extends ChangeNotifier {
  final SortFilterService _sortFilterService = SortFilterService.create();

  // sort
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

  // filter
  bool _isFilterApplied = true;

  bool get isFilterApplied => _isFilterApplied;

  setIsFilterApplied(bool value) {
    _isFilterApplied = value;
    _sortFilterService.setPreferenceIsFilterApplied(isFilterApplied);
    notifyListeners();
  }

  bool _isFilterByYear = false;

  bool get isFilterByYear => _isFilterByYear;

  setIsFilterByYear(bool value) {
    _isFilterByYear = value;
    _sortFilterService.setPreferenceIsFilterByYear(isFilterByYear);
    notifyListeners();
  }

  bool _isFilterByMonth = true;

  bool get isFilterByMonth => _isFilterByMonth;

  setIsFilterByMonth(bool value) {
    _isFilterByMonth = value;
    _sortFilterService.setPreferenceIsFilterByMonth(isFilterByMonth);
    notifyListeners();
  }

  String _filterYear = DateFormat('yyyy').format(DateTime.now());

  String get filterYear => _filterYear;

  setFilterYear(String value) {
    _filterYear = value;
    _sortFilterService.setPreferenceFilterYear(value);
    notifyListeners();
  }

  String _filterMonth = DateFormat('MMMM').format(DateTime.now());

  String get filterMonth => _filterMonth;

  setFilterMonth(String value) {
    _filterMonth = value;
    _sortFilterService.setPreferenceFilterMonth(filterMonth);
    notifyListeners();
  }

  refreshPreferences({bool notify = false}) async {
    // get sort preferences
    SortCriteria? sortCriteria =
        await _sortFilterService.getPreferenceSortCriteria();
    bool? isAscendingSort =
        await _sortFilterService.getPreferenceIsAscendingSort();

    // get filter preferences
    bool? isFilterApplied =
        await _sortFilterService.getPreferenceIsFilterApplied();
    bool? isFilterByYear =
        await _sortFilterService.getPreferenceIsFilterByYear();
    bool? isFilterByMonth =
        await _sortFilterService.getPreferenceIsFilterByMonth();
    String? filterYear = await _sortFilterService.getPreferenceFilterYear();
    String? filterMonth = await _sortFilterService.getPreferenceFilterMonth();

    // set
    _sortCriteria = sortCriteria ?? _sortCriteria;
    _isAscendingSort = isAscendingSort ?? _isAscendingSort;

    _isFilterApplied = isFilterApplied ?? _isFilterApplied;
    _isFilterByYear = isFilterByYear ?? _isFilterByYear;
    _isFilterByMonth = isFilterByMonth ?? _isFilterByMonth;
    _filterYear = filterYear ?? _filterYear;
    _filterMonth = filterMonth ?? _filterMonth;
    if (notify) notifyListeners();
  }
}
