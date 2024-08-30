import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../data/constants/chart_constants.dart';
import '../../../../models/chart_record.dart';
import '../../../../providers/chart_data_provider.dart';
import '../chart_options.dart';

class WeeklyExpensePieChart extends StatefulWidget {
  const WeeklyExpensePieChart({super.key});

  @override
  State<WeeklyExpensePieChart> createState() => _WeeklyExpensePieChartState();
}

class _WeeklyExpensePieChartState extends State<WeeklyExpensePieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: Consumer<ChartDataProvider>(
          builder: (context, provider, child) {
            return _buildWeeklyPieChart(provider);
          },
        )),
        const ChartOptions(),
      ],
    );
  }

  Widget _buildWeeklyPieChart(ChartDataProvider provider) {
    Map<int, ChartRecord> dailySum = _getDailySumForWeek(provider);

    List<PieChartSectionData> pieSections = provider.splitChart
        ? _buildPieSectionsForSplit(dailySum)
        : _buildPieSectionsForTotal(dailySum);

    return Container(
      padding: const EdgeInsets.all(20),
      child: PieChart(
        PieChartData(
          sections: pieSections,
          borderData: FlBorderData(show: false),
          sectionsSpace: 4,
          centerSpaceRadius: 40,
          pieTouchData: PieTouchData(
            touchCallback: (FlTouchEvent event, pieTouchResponse) {
              setState(() {
                if (!event.isInterestedForInteractions ||
                    pieTouchResponse == null ||
                    pieTouchResponse.touchedSection == null) {
                  touchedIndex = -1;
                  return;
                }
                touchedIndex =
                    pieTouchResponse.touchedSection!.touchedSectionIndex;
              });
            },
          ),
        ),
        swapAnimationDuration: const Duration(milliseconds: 250),
        swapAnimationCurve: Curves.linear,
      ),
    );
  }

  Map<int, ChartRecord> _getDailySumForWeek(ChartDataProvider provider) {
    Map<int, ChartRecord> dailySum = provider.chartData
        .calculateDailySumForWeek(provider.splitChart,
            week: provider.selectedWeek);
    dailySum.removeWhere((key, record) => record.totalAmount == 0);
    Map<int, ChartRecord> updatedDailySum = {};
    int newIndex = 0;

    dailySum.forEach((key, record) {
      updatedDailySum[newIndex] = record;
      newIndex++;
    });
    return updatedDailySum;
  }

  List<PieChartSectionData> _buildPieSectionsForTotal(
      Map<int, ChartRecord> dailySum) {
    double totalSum = dailySum.values.fold(
        0, (previousValue, record) => previousValue + record.totalAmount.abs());
    return dailySum.entries.map((entry) {
      final isTouched = touchedIndex == entry.key;
      final double fontSize = isTouched ? 18.0 : 12.0;
      final double radius = isTouched ? 60.0 : 50.0;
      double percent = (entry.value.totalAmount.abs() / totalSum) * 100;
      String title = percent > 3 ? "${percent.toStringAsFixed(1)}%" : "";
      Color color = entry.value.totalAmount > 0
          ? ChartConstants.pie.colorIncome
          : ChartConstants.pie.colorExpense;

      return PieChartSectionData(
        color: color,
        value: (entry.value.totalAmount.abs() / totalSum) * 100,
        title: title,
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade900,
        ),
      );
    }).toList();
  }

  List<PieChartSectionData> _buildPieSectionsForSplit(
      Map<int, ChartRecord> dailySum) {
    double incomeSum = dailySum.values.fold(0,
        (previousValue, record) => previousValue + record.incomeAmount.abs());
    double expenseSum = dailySum.values.fold(0,
        (previousValue, record) => previousValue + record.expenseAmount.abs());
    double reimbursementSum = dailySum.values.fold(
        0,
        (previousValue, record) =>
            previousValue + record.reimbursementAmount.abs());
    int index = -999;
    List<PieChartSectionData> list = [];
    if (incomeSum > 0) {
      if (index == -999) index = -1;
      index++;
      list.add(_buildSplitPieSection(
          incomeSum,
          incomeSum + expenseSum + reimbursementSum,
          ChartConstants.pie.colorIncome,
          index));
    }
    if (expenseSum > 0) {
      if (index == -999) index = -1;
      index++;
      list.add(_buildSplitPieSection(
          expenseSum,
          incomeSum + expenseSum + reimbursementSum,
          ChartConstants.pie.colorExpense,
          index));
    }
    if (reimbursementSum > 0) {
      if (index == -999) index = -1;
      index++;
      list.add(_buildSplitPieSection(
          reimbursementSum,
          incomeSum + expenseSum + reimbursementSum,
          ChartConstants.pie.colorReimbursement,
          index));
    }
    return list;
  }

  PieChartSectionData _buildSplitPieSection(
      double amount, double total, Color color, int index) {
    final isTouched = touchedIndex == index;
    final double fontSize = isTouched ? 18.0 : 12.0;
    final double radius = isTouched ? 60.0 : 50.0;

    double percent = (amount / total) * 100;

    String title = percent > 3 ? "${percent.toStringAsFixed(1)}%" : "";
    return PieChartSectionData(
      color: color,
      value: (amount / total) * 100,
      title: title,
      radius: radius,
      titleStyle: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: Colors.grey.shade900,
      ),
    );
  }
}
