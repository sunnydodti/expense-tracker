enum ChartType { bar, line, pie }

class ChartTypeHelper {
  static String getChartTypeText(ChartType type, {long = true}) {
    switch (type) {
      case ChartType.bar:
        return long ? 'Bar Chart' : 'Bar';
      case ChartType.line:
        return long ? 'line Chart' : 'line';
      case ChartType.pie:
        return long ? 'Pie Chart' : 'Pie';
    }
  }

  static ChartType getChartTypeByName(String name) {
    return ChartType.values.byName(name);
  }
}


enum ChartRange {
  weekly,
  monthly,
  yearly,
  custom,
}

class ChartRangeHelper {
  static String getChartRangeText(ChartRange type) {
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

  static ChartRange getChartRangeByName(String name) {
    return ChartRange.values.byName(name);
  }
}

enum ExpenseBarChartType { total, split }
