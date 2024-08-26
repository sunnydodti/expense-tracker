import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/enums/chart_range.dart';
import '../../../../providers/ChartDataProvider.dart';
import 'monthly_expense_line_chart.dart';
import 'weekly_expense_line_chart.dart';
import 'yearly_expense_line_chart.dart';

class ExpenseLineChart extends StatefulWidget {
  const ExpenseLineChart({super.key});

  @override
  State<ExpenseLineChart> createState() => _ExpenseLineChartState();
}

class _ExpenseLineChartState extends State<ExpenseLineChart> {
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
        return const WeeklyExpenseLineChart();
      case ChartRange.monthly:
        return const MonthlyExpenseLineChart();
      case ChartRange.yearly:
        return const YearlyExpenseLineChart();
      case ChartRange.custom:
        return _buildCustomBarChart(provider);
      default:
        return const WeeklyExpenseLineChart();
    }
  }

  Widget _buildCustomBarChart(ChartDataProvider provider) {
    return const Text("Custom");
  }
}
