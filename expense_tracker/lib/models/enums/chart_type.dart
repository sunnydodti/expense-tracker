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