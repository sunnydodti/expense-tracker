import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

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

  BarChart buildBarChart() {
    return BarChart(BarChartData(barGroups: _getBarGroups(expenses)));
  }

  List<BarChartGroupData> _getBarGroups(List<Expense> expenses) {
    final Map<String, double> totalByCategory = {};
    for (var expense in expenses) {
      totalByCategory[expense.category] ??= 0.0;
      totalByCategory[expense.category] =
      (totalByCategory[expense.category]! + expense.amount)!;
    }

    List<BarChartGroupData> barGroups = [];
    totalByCategory.forEach((category, total) {
      barGroups.add(
        BarChartGroupData(
          x: (barsSpacing + category.length * (barWidth + spacing)).round(),
          barRods: [
            BarChartRodData(
              borderRadius: BorderRadius.zero,
              color: Colors.lightBlueAccent,
              width: barWidth,
              toY: total,
            ),
          ],
        ),
      );
    });
    return barGroups;
  }

}
