import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/enums/sort_criteria.dart';
import '../service/sort_filter_service.dart';

class SortFilterProvider extends ChangeNotifier {
  final SortFilterService _sortFilterService = SortFilterService.create();

  // region section 1: states

  SortCriteria _sortCriteria = SortCriteria.modifiedDate;
  bool _isAscendingSort = false;
  bool _isFilterApplied = true;
  bool _isFilterByYear = false;
  bool _isFilterByMonth = true;
  String _filterYear = DateFormat('yyyy').format(DateTime.now());
  String _filterMonth = DateFormat('MMMM').format(DateTime.now());

  //endregion

  // region section 2: sort

  SortCriteria get sortCriteria => _sortCriteria;

  setSortCriteria(SortCriteria sortCriteria) {
    _sortCriteria = sortCriteria;
    _sortFilterService.setPreferenceSortCriteria(sortCriteria);
    notifyListeners();
  }

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

  //endregion

  // region section 3: filter

  bool get isFilterApplied => _isFilterApplied;

  setIsFilterApplied(bool value) {
    _isFilterApplied = value;
    _sortFilterService.setPreferenceIsFilterApplied(isFilterApplied);
    notifyListeners();
  }

  bool get isFilterByYear => _isFilterByYear;

  setIsFilterByYear(bool value) {
    _isFilterByYear = value;
    _sortFilterService.setPreferenceIsFilterByYear(isFilterByYear);
    notifyListeners();
  }

  setFilterYear(String value) {
    _filterYear = value;
    _sortFilterService.setPreferenceFilterYear(value);
    notifyListeners();
  }

  bool get isFilterByMonth => _isFilterByMonth;

  setIsFilterByMonth(bool value) {
    _isFilterByMonth = value;
    _sortFilterService.setPreferenceIsFilterByMonth(isFilterByMonth);
    notifyListeners();
  }

  String get filterYear => _filterYear;

  setFilterMonth(String value) {
    _filterMonth = value;
    _sortFilterService.setPreferenceFilterMonth(filterMonth);
    notifyListeners();
  }

  String get filterMonth => _filterMonth;

  //endregion

  //region section 4: refresh

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

//endregion
}
