import 'package:flutter/material.dart';

import '../data/constants/form_constants.dart';
import '../models/chart_data.dart';
import '../models/enums/chart_range.dart';
import '../models/enums/chart_type.dart';
import '../models/expense.dart';
import '../service/chart_service.dart';

class ChartDataProvider with ChangeNotifier {
  late ChartType _chartType;
  late ChartRange _chartRange;

  List<Expense> _expenses = [];
  late ChartData _chartData;

  String _currency = "";

  bool splitChart = false;

  int _selectedWeek = 0;
  final int _currentWeek = ChartService.currentWeek;
  int _selectedMonth = 0;
  final int _currentMonth = ChartService.currentMonth;
  int _selectedYear = 0;
  final int _currentYear = ChartService.currentYear;

  ChartDataProvider() {
    _chartData = ChartData(expenses: _expenses);
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

  String get currency => _currency;

  set currency(String currency) {
    _currency = currency;
  }

  List<Expense> get expenses => _expenses;

  ChartData get chartData => _chartData;

  createChartData(List<Expense> expenses) {
    _expenses = expenses;
    _chartData = ChartData(expenses: expenses);
  }

  int get currentWeek => _currentWeek;

  int get selectedWeek {
    if (_selectedWeek != 0) return _selectedWeek;
    return _currentWeek;
  }

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

  int get currentMonth => _currentMonth;

  int get selectedMonth {
    if (_selectedMonth != 0) return _selectedMonth;
    return _currentMonth;
  }

  set selectedMonth(int selectedMonth) {
    _selectedMonth = selectedMonth;
    notifyListeners();
  }

  void decrementMonth() {
    int month = selectedMonth == 0 ? currentMonth - 1 : selectedMonth - 1;
    if (month < 1) month = 12;
    selectedMonth = month;
  }

  void incrementMonth() {
    int month = selectedMonth == 0 ? currentMonth + 1 : selectedMonth + 1;
    if (month > 12) month = 1;
    selectedMonth = month;
  }

  int get currentYear => _currentYear;

  int get selectedYear {
    if (_selectedYear != 0) return _selectedYear;
    return _currentYear;
  }

  set selectedYear(int selectedYear) {
    _selectedYear = selectedYear;
    notifyListeners();
  }

  void decrementYear() {
    int year = selectedYear == 0 ? currentYear - 1 : selectedYear - 1;
    selectedYear = year;
  }

  void incrementYear() {
    int year = selectedYear == 0 ? currentYear + 1 : selectedYear + 1;
    selectedYear = year;
  }
}
