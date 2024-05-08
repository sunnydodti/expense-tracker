import 'expense.dart';

class ChartData {
  final List<Expense> expenses;
  int? week;
  int? month;
  int? year;

  ChartData({
    required this.expenses,
    this.week,
    this.month,
    this.year,
  });

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
}
