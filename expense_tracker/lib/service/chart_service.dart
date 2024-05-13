import '../models/expense.dart';

class ChartService {
  final List<Expense> expenses;

  ChartService(this.expenses);

  DateTime _startDate = DateTime.now().subtract(const Duration(days: 7));
  DateTime _endDate = DateTime.now();
  List<String> _selectedCategories = [];
  List<String> _selectedTags = [];

  static const double barsSpacing = 10.0;
  static const double spacing = 5.0;
  static const double radius = 50.0;
  static const double barWidth = 10.0;

  static int getCurrentWeek() {
    final DateTime date = DateTime.now();
    final DateTime startOfYear = DateTime(date.year, 1, 1);
    final DateTime firstMonday = startOfYear.weekday == DateTime.monday
        ? startOfYear
        : startOfYear
            .add(Duration(days: DateTime.monday - startOfYear.weekday));
    final Duration difference = date.difference(firstMonday);
    int weekNumber = (difference.inDays / 7).ceil();
    if (date.weekday == DateTime.monday) weekNumber += 1;
    return weekNumber;
  }
}
