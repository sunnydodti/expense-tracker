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

  static int _currentWeek = 0;
  static int _currentMonth = 0;
  static int _currentYear = 0;

  static int get currentWeek {
    if (_currentWeek != 0) return _currentWeek;

    final DateTime date = DateTime.now();

    final DateTime startOfYear = DateTime(date.year, 1, 1);
    final DateTime firstMonday = startOfYear.weekday == DateTime.monday
        ? startOfYear
        : startOfYear
            .add(Duration(days: DateTime.monday - startOfYear.weekday));

    final Duration difference = date.difference(firstMonday);
    int weekNumber = (difference.inDays / 7).ceil();
    if (date.weekday == DateTime.monday) weekNumber += 1;

    _currentWeek = weekNumber;
    return _currentWeek;
  }

  static int get currentMonth {
    if (_currentMonth == 0) {
      _currentMonth = DateTime.now().month;
    }
    return _currentMonth;
  }

  static int get currentYear {
    if (_currentYear == 0) {
      _currentYear = DateTime.now().year;
    }
    return _currentYear;
  }

  static String getWeekDay(int weekDayNumber) {
    String weekDay;

    switch (weekDayNumber) {
      case 1:
        weekDay = 'Monday';
        break;
      case 2:
        weekDay = 'Tuesday';
        break;
      case 3:
        weekDay = 'Wednesday';
        break;
      case 4:
        weekDay = 'Thursday';
        break;
      case 5:
        weekDay = 'Friday';
        break;
      case 6:
        weekDay = 'Saturday';
        break;
      case 7:
        weekDay = 'Sunday';
        break;
      default:
        throw Error();
    }
    return weekDay;
  }

  static String getWeekRange(int weekIndex, int year, int month) {
    DateTime firstDayOfMonth = DateTime(year, month, 1);

    DateTime weekStart =
        firstDayOfMonth.add(Duration(days: (weekIndex - 1) * 7));
    DateTime weekEnd = weekStart.add(const Duration(days: 6));

    DateTime lastDayOfMonth = DateTime(year, month + 1, 0);
    if (weekEnd.isAfter(lastDayOfMonth)) {
      weekEnd = lastDayOfMonth;
    }

    String weekStartFormatted = "${weekStart.day}";
    String weekEndFormatted = "${weekEnd.day}";

    return "Week $weekIndex ($weekStartFormatted - $weekEndFormatted)";
  }

  static String _getMonthName(int month) {
    const List<String> monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return monthNames[month - 1];
  }

  static Map<String, DateTime> getWeekStartAndEnd(int week, {int year = 0}) {
    if (year == 0) year = DateTime.now().year;

    DateTime weekStart = DateTime(year);
    weekStart = weekStart.subtract(
      const Duration(days: DateTime.monday - 1),
    );
    weekStart = weekStart.add(
      Duration(days: (week - 1) * 7),
    );
    final DateTime weekEnd = weekStart.add(const Duration(days: 6));

    return {
      "start": weekStart,
      "end": weekEnd,
    };
  }

  static Map<String, DateTime> getMonthStartAndEnd(int month, {int year = 0}) {
    if (year == 0) year = DateTime.now().year;

    DateTime monthStart = DateTime(year, month, 1);
    DateTime monthEnd =
        DateTime(year, month + 1, 1).subtract(const Duration(days: 1));

    return {
      "start": monthStart,
      "end": monthEnd,
    };
  }

  static Map<String, DateTime> getYearStartAndEnd(int year) {
    DateTime yearStart = DateTime(year, 1, 1);
    DateTime yearEnd =
        DateTime(year + 1, 1, 1).subtract(const Duration(days: 1));

    return {
      "start": yearStart,
      "end": yearEnd,
    };
  }
}
