import 'dart:math';

import 'chart_record.dart';
import 'enums/chart_type.dart';
import 'expense.dart';

class ChartData {
  final List<Expense> expenses;
  int? week;
  int? month;
  int? year;
  bool splitSum = false;

  ChartData({
    required this.expenses,
    this.week,
    this.month,
    this.year,
  });

  double _maxDailyAmount = 0;
  double _minDailyAmount = 0;

  List<int> _daysWithMaxAmount = [];
  List<int> _daysWithMinAmount = [];

  double get maxDailyAmount => _maxDailyAmount;

  double get minDailyAmount => _minDailyAmount;

  List<int> get daysWithMaxAmount => _daysWithMaxAmount;

  List<int> get daysWithMinAmount => _daysWithMinAmount;

  // chart ui data
  double get barHeight => _maxDailyAmount + _maxDailyAmount * 0.25;

  List<Expense> filterExpenses() {
    return expenses.where((expense) {
      if (week != null && _getWeekOfYear(expense.date) != week) {
        return false;
      }
      if (month != null && expense.date.month != month) {
        return false;
      }
      if (year != null && expense.date.year != year) {
        return false;
      }
      return true;
    }).toList();
  }

  List<Expense> getExpensesForCurrentWeek() {
    final now = DateTime.now();
    final currentWeek = _getWeekOfYear(now);
    return expenses
        .where((expense) => _getWeekOfYear(expense.date) == currentWeek)
        .toList();
  }

  List<Expense> getExpensesForCurrentMonth() {
    final now = DateTime.now();
    final currentMonth = now.month;
    return expenses
        .where((expense) => expense.date.month == currentMonth)
        .toList();
  }

  List<Expense> getExpensesForCurrentYear() {
    final now = DateTime.now();
    final currentYear = now.year;
    return expenses
        .where((expense) => expense.date.year == currentYear)
        .toList();
  }

  List<Expense> getExpensesForSelectedWeek() {
    if (week != null) {
      return expenses.where((expense) => _getWeekOfYear(expense.date) == week).toList();
    } else {
      throw Exception('Week is not specified.');
    }
  }

  List<Expense> getExpensesForSelectedMonth() {
    if (month != null) {
      return expenses.where((expense) => expense.date.month == month).toList();
    } else {
      throw Exception('Month is not specified.');
    }
  }

  List<Expense> getExpensesForSelectedYear() {
    if (year != null) {
      return expenses.where((expense) => expense.date.year == year).toList();
    } else {
      throw Exception('Year is not specified.');
    }
  }

  void goToNextWeek() {
    final now = DateTime.now();
    final currentWeek = _getWeekOfYear(now);
    week = currentWeek + 1;
  }

  void goToPreviousWeek() {
    final now = DateTime.now();
    final currentWeek = _getWeekOfYear(now);
    week = currentWeek - 1;
  }

  void goToNextMonth() {
    final now = DateTime.now();
    month = now.month + 1;
  }

  void goToPreviousMonth() {
    final now = DateTime.now();
    month = now.month - 1;
  }

  void goToNextYear() {
    final now = DateTime.now();
    year = now.year + 1;
  }

  void goToPreviousYear() {
    final now = DateTime.now();
    year = now.year - 1;
  }


  int _getWeekOfYear(DateTime date) {
    final DateTime startOfYear = DateTime(date.year, 1, 1);
    final DateTime firstMonday = startOfYear.weekday == 1
        ? startOfYear
        : startOfYear.add(Duration(days: 8 - startOfYear.weekday));
    final Duration difference = date.difference(firstMonday);
    final int weekNumber = (difference.inDays / 7).ceil();
    return weekNumber;
  }

  Map<int, double> calculateDailySumForWeek() {
    List<Expense> expenses = getExpensesForCurrentWeek();

    Map<int, double> dailySum = {
      DateTime.monday: 0,
      DateTime.tuesday: 0,
      DateTime.wednesday: 0,
      DateTime.thursday: 0,
      DateTime.friday: 0,
      DateTime.saturday: 0,
      DateTime.sunday: 0,
    };

    for (Expense expense in expenses) {
      dailySum[expense.date.weekday] =
          dailySum[expense.date.weekday]! + expense.amount;
    }
    calculateDaysWithHighestAndLowestAmounts(dailySum);
    return dailySum;
  }

  void calculateDaysWithHighestAndLowestAmounts(Map<int, double> dailySums) {
    _maxDailyAmount = dailySums.values.reduce((a, b) => a > b ? a : b);
    _minDailyAmount = dailySums.values.reduce((a, b) => a < b ? a : b);

    dailySums.forEach((day, amount) {
      if (amount == _maxDailyAmount) _daysWithMaxAmount.add(day);
      if (amount == _minDailyAmount) _daysWithMinAmount.add(day);
    });
  }

  void calculateDaysWithHighestAndLowestAmountsForTotal(
      Map<int, ChartRecord> dailySums) {
    double maxTotalAmount = 0.0;
    double minTotalAmount = 0.0;

    dailySums.forEach((day, record) {
      double totalAmount = record.totalAmount;
      maxTotalAmount = max(maxTotalAmount, totalAmount);
      minTotalAmount = min(minTotalAmount, totalAmount);
    });

    _maxDailyAmount = maxTotalAmount;
    _minDailyAmount = minTotalAmount;
  }

  Map<int, ChartRecord> calculateDailySumForWeekV2(
      ExpenseBarChartType chartType) {
    List<Expense> expenses = getExpensesForCurrentWeek();

    Map<int, ChartRecord> dailySum = {
      DateTime.monday: ChartRecord(),
      DateTime.tuesday: ChartRecord(),
      DateTime.wednesday: ChartRecord(),
      DateTime.thursday: ChartRecord(),
      DateTime.friday: ChartRecord(),
      DateTime.saturday: ChartRecord(),
      DateTime.sunday: ChartRecord(),
    };

    for (var expense in expenses) {
      dailySum[expense.date.weekday]!.add(expense);
    }

    dailySum.forEach((key, value) {
      print(value.expenses.length);
      print(value.expenseAmount);
      print(value.incomeAmount);
      print(value.reimbursementAmount);
      print(value.totalAmount);
    });
    if (chartType == ExpenseBarChartType.split) {
      calculateDaysWithHighestAndLowestAmountsForSplit(dailySum);
    }
    if (chartType == ExpenseBarChartType.total) {
      calculateDaysWithHighestAndLowestAmountsForTotal(dailySum);
    }
    return dailySum;
  }

  void calculateDaysWithHighestAndLowestAmountsForSplit(
      Map<int, ChartRecord> dailySums) {
    double maxExpenseAmount = 0.0;
    double minExpenseAmount = 0.0;

    double maxIncomeAmount = 0.0;
    double minIncomeAmount = 0.0;

    double maxReimbursementAmount = 0.0;
    double minReimbursementAmount = 0.0;

    for (var record in dailySums.values) {
      maxExpenseAmount = max(record.expenseAmount, maxExpenseAmount);
      minExpenseAmount = max(record.expenseAmount, minExpenseAmount);

      maxIncomeAmount = max(record.incomeAmount, maxIncomeAmount);
      minIncomeAmount = min(record.incomeAmount, minIncomeAmount);

      maxReimbursementAmount =
          max(record.reimbursementAmount, maxReimbursementAmount);
      minReimbursementAmount =
          min(record.reimbursementAmount, minReimbursementAmount);

      _maxDailyAmount =
          max(maxExpenseAmount, max(maxIncomeAmount, maxReimbursementAmount));
      _minDailyAmount =
          min(minExpenseAmount, min(minIncomeAmount, minReimbursementAmount));
    }
  }
}
