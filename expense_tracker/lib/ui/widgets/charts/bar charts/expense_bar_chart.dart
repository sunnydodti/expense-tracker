import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/enums/chart_range.dart';
import '../../../../providers/ChartDataProvider.dart';
import 'monthly_expense_bar_chart.dart';
import 'weekly_expense_bar_chart.dart';

class ExpenseBarChart extends StatefulWidget {
  const ExpenseBarChart({super.key});

  @override
  State<ExpenseBarChart> createState() => _ExpenseBarChartState();
}

class _ExpenseBarChartState extends State<ExpenseBarChart> {
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
        return const WeeklyExpenseBarChart();
      case ChartRange.monthly:
        return const MonthlyExpenseBarChart();
      case ChartRange.yearly:
        return _buildYearlyBarChart(provider);
      case ChartRange.custom:
        return _buildCustomBarChart(provider);
      default:
        return const WeeklyExpenseBarChart();
    }
  }

  Widget _buildMonthlyBarChart(ChartDataProvider provider) {
    return const Text("Monthly");
  }

  Widget _buildYearlyBarChart(ChartDataProvider provider) {
    return const Text("Yearly");
  }

  Widget _buildCustomBarChart(ChartDataProvider provider) {
    return const Text("Custom");
  }
}
