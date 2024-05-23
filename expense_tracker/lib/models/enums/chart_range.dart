enum ChartRange {
  weekly,
  monthly,
  yearly,
  custom,
}

String getChartRangeText(ChartRange type) {
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

ChartRange getChartRangeByName(String name) {
  return ChartRange.values.byName(name);
}
