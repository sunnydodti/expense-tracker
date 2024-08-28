import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/enums/chart_range.dart';
import '../../../../providers/ChartDataProvider.dart';
import 'monthly_expense_pie_chart.dart';
import 'weekly_expense_pie_chart.dart';
import 'yearly_expense_pie_chart.dart';

class ExpensePieChart extends StatefulWidget {
  const ExpensePieChart({super.key});

  @override
  State<ExpensePieChart> createState() => _ExpensePieChartState();
}

class _ExpensePieChartState extends State<ExpensePieChart> {
  int touchedIndex = -1;

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
      default:
        return const WeeklyExpensePieChart();
    }
  }

  Widget _buildCustomBarChart(ChartDataProvider provider) {
    return const Text("Custom");
  }
}
