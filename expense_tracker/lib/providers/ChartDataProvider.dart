import 'package:flutter/material.dart';

import '../data/constants/form_constants.dart';
import '../data/constants/shared_preferences_constants.dart';
import '../data/constants/theme_constants.dart';
import '../data/helpers/color_helper.dart';
import '../models/chart_data.dart';
import '../models/enums/app_theme.dart';
import '../models/enums/chart_range.dart';
import '../models/enums/chart_type.dart';
import '../models/expense.dart';
import '../service/chart_service.dart';
import '../service/shared_preferences_service.dart';

class ChartDataProvider with ChangeNotifier {
  late ChartType _chartType;
  late ChartRange _chartRange;

  List<Expense> _expenses = [];
  late ChartData _chartData;

  late String _currency;

  bool splitChart = false;

  int _selectedWeek = 0;
  int _currentWeek = ChartService.currentWeek;

  ChartDataProvider() {
    _chartData = ChartData(expenses: _expenses);
    // _currentWeek = ChartService.currentWeek;
    _chartType = ChartType.bar;
    _chartRange = ChartRange.weekly;
    _currency = FormConstants.expense.currencies.values.first;
  }

  ChartType get chartType => _chartType;

  set chartType(ChartType chartType) {
    _chartType = chartType;
    notifyListeners();
  }

  void toggleChartType(bool? value) {
    splitChart = value ?? false;
    notifyListeners();
  }

  ChartRange get chartRange => _chartRange;

  set chartRange(ChartRange chartRange) {
    _chartRange = chartRange;
    notifyListeners();
  }

  List<Expense> get expenses => _expenses;

  ChartData get chartData => _chartData;

  ChartData createChartData(List<Expense> expenses) {
    _expenses = expenses;
    _chartData = ChartData(expenses: expenses);
    notifyListeners();
    return _chartData;
  }

  int get currentWeek => _currentWeek;
  int get selectedWeek => _selectedWeek;

  set selectedWeek(int selectedWeek){
    _selectedWeek = selectedWeek;
    notifyListeners();
  }

  void decrementWeek() {
    int week = selectedWeek == 0 ? currentWeek - 1 : selectedWeek - 1;
    if (week < 1) week = 52;
    selectedWeek = week;
  }

  void incrementWeek() {
    int week = selectedWeek == 0 ? currentWeek + 1 : selectedWeek + 1;
    if (week > 52) week = 1;
    selectedWeek = week;
  }
}
