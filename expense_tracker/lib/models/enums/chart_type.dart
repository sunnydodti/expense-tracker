enum ChartType { bar, line, pie }

enum ChartRange {
  weekly,
  monthly,
  yearly,
  custom,
}

class ChartRangeHelper {
  static String getDateRangeText(ChartRange type) {
    switch (type) {
      case ChartRange.weekly:
        return 'Weekly';
      case ChartRange.monthly:
        return 'Monthly';
      case ChartRange.yearly:
        return 'Yearly';
      case ChartRange.custom:
        return 'Custom';
    }
  }

  static ChartRange getSortCriteriaByName(String name) {
    return ChartRange.values.byName(name);
  }
}

enum ExpenseBarChartType { total, split }
