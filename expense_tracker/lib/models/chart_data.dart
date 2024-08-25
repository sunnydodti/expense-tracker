import 'dart:math';

import '../service/chart_service.dart';
import 'chart_record.dart';
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
  double get barHeight => _maxDailyAmount + _maxDailyAmount * 0.30;

  List<Expense> filterExpenses() {
    return expenses.where((expense) {
      if (week != null && ChartService.currentWeek != week) {
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

  List<Expense> getExpensesBetween(DateTime startDate, DateTime endDate) {
    return expenses.where((expense) {
      final expenseDate = expense.date;
      return expenseDate.isAfter(startDate.subtract(const Duration(days: 1))) &&
          expenseDate.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();
  }

  List<Expense> getExpensesForCurrentWeek() {
    final now = DateTime.now();
    final DateTime weekStart =
        now.subtract(Duration(days: now.weekday - DateTime.monday));
    final DateTime weekEnd =
        weekStart.add(const Duration(days: DateTime.sunday - DateTime.monday));
    return getExpensesBetween(weekStart, weekEnd);
  }

  List<Expense> getExpensesForCurrentMonth() {
    final now = DateTime.now();
    final DateTime monthStart = DateTime(now.year, now.month, 1);
    final DateTime monthEnd = DateTime(now.year, now.month + 1, 0);
    return getExpensesBetween(monthStart, monthEnd);
  }

  List<Expense> getExpensesForCurrentYear() {
    final now = DateTime.now();
    final DateTime yearStart = DateTime(now.year, 1, 1);
    final DateTime yearEnd = DateTime(now.year, 12, 31);
    return getExpensesBetween(yearStart, yearEnd);
  }

  List<Expense> getExpensesForWeek(int week) {
    final now = DateTime.now();
    final currentYear = now.year;

    DateTime weekStart = DateTime(currentYear);
    weekStart = weekStart.subtract(
      const Duration(days: DateTime.monday - 1),
    );
    weekStart = weekStart.add(
      Duration(days: (week - 1) * 7),
    );

    final DateTime weekEnd = weekStart.add(const Duration(days: 6));

    return getExpensesBetween(weekStart, weekEnd);
  }

  List<Expense> getExpensesForSelectedWeek() {
    if (week != null) {
      return expenses
          .where((expense) => ChartService.currentWeek == week)
          .toList();
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
    final currentWeek = ChartService.currentWeek;
    week = currentWeek + 1;
  }

  void goToPreviousWeek() {
    final currentWeek = ChartService.currentWeek;
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
      double totalAmount = record.totalAmount.abs();
      maxTotalAmount = max(maxTotalAmount, totalAmount);
      minTotalAmount = min(minTotalAmount, totalAmount);
    });

    _maxDailyAmount = maxTotalAmount;
    _minDailyAmount = minTotalAmount;
  }

  Map<int, ChartRecord> calculateDailySumForWeek(bool iSplitChart,
      {int week = 0}) {
    List<Expense> expenses = getExpensesForCurrentWeek();
    if (week > 0 && week < 52) {
      expenses = getExpensesForWeek(week);
    }
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

    if (iSplitChart) {
      calculateDaysWithHighestAndLowestAmountsForSplit(dailySum);
    } else {
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
      maxExpenseAmount = max(record.expenseAmount.abs(), maxExpenseAmount);
      minExpenseAmount = max(record.expenseAmount.abs(), minExpenseAmount);

      maxIncomeAmount = max(record.incomeAmount.abs(), maxIncomeAmount);
      minIncomeAmount = min(record.incomeAmount.abs(), minIncomeAmount);

      maxReimbursementAmount =
          max(record.reimbursementAmount.abs(), maxReimbursementAmount);
      minReimbursementAmount =
          min(record.reimbursementAmount.abs(), minReimbursementAmount);
    }
    _maxDailyAmount =
        max(maxExpenseAmount, max(maxIncomeAmount, maxReimbursementAmount));
    _minDailyAmount =
        min(minExpenseAmount, min(minIncomeAmount, minReimbursementAmount));
  }
}
