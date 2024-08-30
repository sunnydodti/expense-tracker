import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../data/constants/chart_constants.dart';
import '../../../../models/chart_record.dart';
import '../../../../providers/chart_data_provider.dart';
import '../chart_options.dart';

class YearlyExpensePieChart extends StatefulWidget {
  const YearlyExpensePieChart({super.key});

  @override
  State<YearlyExpensePieChart> createState() => _YearlyExpensePieChartState();
}

class _YearlyExpensePieChartState extends State<YearlyExpensePieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: Consumer<ChartDataProvider>(
          builder: (context, provider, child) {
            return _buildYearlyPieChart(provider);
          },
        )),
        const ChartOptions(),
      ],
    );
  }

  Widget _buildYearlyPieChart(ChartDataProvider provider) {
    Map<int, ChartRecord> yearlySum = _getYearlySum(provider);

    List<PieChartSectionData> pieSections = provider.splitChart
        ? _buildPieSectionsForSplit(yearlySum)
        : _buildPieSectionsForTotal(yearlySum);

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

  Map<int, ChartRecord> _getYearlySum(ChartDataProvider provider) {
    Map<int, ChartRecord> yearlySum = provider.chartData
        .calculateMonthlySumForYear(
            iSplitChart: provider.splitChart, year: provider.selectedYear);
    yearlySum.removeWhere((key, record) => record.totalAmount == 0);

    Map<int, ChartRecord> updatedYearlySum = {};
    int newIndex = 0;

    yearlySum.forEach((key, record) {
      updatedYearlySum[newIndex] = record;
      newIndex++;
    });
    return updatedYearlySum;
  }

  List<PieChartSectionData> _buildPieSectionsForTotal(
      Map<int, ChartRecord> yearlySum) {
    double totalSum = yearlySum.values.fold(
        0, (previousValue, record) => previousValue + record.totalAmount.abs());
    return yearlySum.entries.map((entry) {
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
      Map<int, ChartRecord> yearlySum) {
    double incomeSum = yearlySum.values.fold(0,
        (previousValue, record) => previousValue + record.incomeAmount.abs());
    double expenseSum = yearlySum.values.fold(0,
        (previousValue, record) => previousValue + record.expenseAmount.abs());
    double reimbursementSum = yearlySum.values.fold(
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
