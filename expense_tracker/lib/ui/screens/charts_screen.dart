import 'package:expense_tracker/service/chart_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../models/enums/chart_type.dart';
import '../../models/expense.dart';

class ChartsScreen extends StatefulWidget {
  final List<Expense> expenses;

  const ChartsScreen(this.expenses, {super.key});

  @override
  ExpenseVisualizationScreenState createState() =>
      ExpenseVisualizationScreenState();
}

class ExpenseVisualizationScreenState extends State<ChartsScreen> {
  late ChartService _chartService;

  final ChartType _selectedChartType = ChartType.bar;
  @override
  void initState() {
    super.initState();
    _chartService = ChartService(widget.expenses);
  }

  // ... other methods for time range, category/tag selection (unchanged)

  Widget _buildChart(List<Expense> expenses) {
    switch (_selectedChartType) {
      case ChartType.bar:
        return _chartService.buildBarChart();
      case ChartType.line:
        return LineChart(LineChartData(lineBarsData: _getLineBars(expenses)));
      case ChartType.pie:
        return PieChart(PieChartData(sections: _getPieChartSections(expenses)));
    }
  }

  List<LineChartBarData> _getLineBars(List<Expense> expenses) {
    // Group expenses by date (daily)
    final Map<DateTime, double> totalByDate = {};
    for (var expense in expenses) {
      totalByDate[expense.date] ??= 0.0;
      totalByDate[expense.date] =
          (totalByDate[expense.date]! + expense.amount)!;
    }

    // Sort dates in ascending order
    final List<DateTime> sortedDates = totalByDate.keys.toList()..sort();

    // Create LineChartBarData objects
    List<LineChartBarData> lineBars = [
      LineChartBarData(
        spots: sortedDates
            .map(
                (date) => FlSpot(date.day.toDouble(), totalByDate[date] ?? 0.0))
            .toList(),
        isCurved: true,
        color: Colors.redAccent,
        // Customize color
        barWidth: 2,
        belowBarData: BarAreaData(show: false), // Remove area below line
      ),
    ];
    return lineBars;
  }

  List<PieChartSectionData> _getPieChartSections(List<Expense> expenses) {
    // Group expenses by category
    final Map<String, double> totalByCategory = {};
    for (var expense in expenses) {
      totalByCategory[expense.category] ??= 0.0;
      totalByCategory[expense.category] =
          (totalByCategory[expense.category]! + expense.amount)!;
    }

    // Calculate total expense
    double totalExpense =
        totalByCategory.values.fold(0.0, (sum, value) => sum + value);

    // Create PieChartSectionData objects
    List<PieChartSectionData> pieChartSections = [];
    totalByCategory.forEach((category, total) {
      final percentage = total / totalExpense;
      pieChartSections.add(
        PieChartSectionData(
          color: Colors.green, // Customize color
          value: percentage,
          title: category,

          radius: 50, // Set pie chart radius
        ),
      );
    });
    return pieChartSections;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Visualization'),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            Expanded(
                flex: 4,
                child: Container(
                  child: _buildChart(widget.expenses),
                )),
            Expanded(
                flex: 1, // 1 part out of 10
                child: Container(
                  color: Colors.red,
                  child: const Center(child: Text('1 Part')),
                )),
            Expanded(
                flex: 5,
                child: Container(
                  color: Colors.green,
                  child: const Center(child: Text('5 Parts')),
                ))
          ],
        ),
      ),
    );
  }
}
