import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/enums/chart_range.dart';
import '../../../../providers/chart_data_provider.dart';
import 'monthly_expense_pie_chart.dart';
import 'weekly_expense_pie_chart.dart';
import 'yearly_expense_pie_chart.dart';

class ExpensePieChart extends StatelessWidget {
  const ExpensePieChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChartDataProvider>(
      builder: (context, provider, child) {
        return _buildBarChartForRange(provider);
      },
    );
  }

  Widget _buildBarChartForRange(ChartDataProvider provider) {
    switch (provider.chartRange) {
      case ChartRange.weekly:
        return const WeeklyExpensePieChart();
      case ChartRange.monthly:
        return const MonthlyExpensePieChart();
      case ChartRange.yearly:
        return const YearlyExpensePieChart();
      case ChartRange.custom:
        return _buildCustomBarChart(provider);
    }
  }

  Widget _buildCustomBarChart(ChartDataProvider provider) {
    return const Text("Custom");
  }
}
