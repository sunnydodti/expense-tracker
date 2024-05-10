import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../data/constants/chart_constants.dart';
import '../../../models/chart_data.dart';
import '../../../models/chart_record.dart';
import '../../../models/enums/chart_type.dart';

class WeeklyExpenseBarChart extends StatefulWidget {
  final ChartData chartData;
  final ExpenseBarChartType barChartType;

  const WeeklyExpenseBarChart(
      {super.key,
      required this.chartData,
      this.barChartType = ExpenseBarChartType.split});

  @override
  State<WeeklyExpenseBarChart> createState() => _WeeklyExpenseBarChartState();
}

class _WeeklyExpenseBarChartState extends State<WeeklyExpenseBarChart> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildWeeklyBarChart();
  }

  BarChart _buildWeeklyBarChart() {
    Map<int, ChartRecord> dailySum =
        widget.chartData.calculateDailySumForWeek(widget.barChartType);
    List<BarChartGroupData> barGroups =
        (widget.barChartType == ExpenseBarChartType.split)
            ? _buildBarGroupsForSplit(dailySum)
            : _buildBarGroupsForTotal(dailySum);
    return BarChart(
      BarChartData(
        barGroups: barGroups,
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
            show: true,
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: getTitles,
                    reservedSize: 35))),
      ),
      // swapAnimationCurve: Curves.linear,
      // swapAnimationDuration: const Duration(milliseconds: 500),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = const Text('M', style: style);
        break;
      case 2:
        text = const Text('T', style: style);
        break;
      case 3:
        text = const Text('W', style: style);
        break;
      case 4:
        text = const Text('T', style: style);
        break;
      case 5:
        text = const Text('F', style: style);
        break;
      case 6:
        text = const Text('S', style: style);
        break;
      case 7:
        text = const Text('S', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: text,
    );
  }

  _buildBarGroupsForTotal(Map<int, ChartRecord> dailySum) {
    List<BarChartGroupData> barGroups = [];

    dailySum.forEach((day, record) {
      double total = record.totalAmount;
      Color color = total > 0 ? Colors.green.shade400 : Colors.red.shade400;
      barGroups.add(
        BarChartGroupData(
          x: day,
          barRods: [
            BarChartRodData(
              toY: total.abs(),
              width: ChartConstants.bar.barWidth,
              color: color,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(4)),
              backDrawRodData: BackgroundBarChartRodData(
                show: true,
                toY: widget.chartData.barHeight,
                color: Colors.green.withOpacity(.15),
              ),
            ),
          ],
          // showingTooltipIndicators: [0],
        ),
      );
    });

    return barGroups;
  }

  _buildBarGroupsForSplit(Map<int, ChartRecord> dailySum) {
    List<BarChartGroupData> barGroups = [];

    dailySum.forEach((day, record) {
      bool isExpenseAmount = record.expenseAmount != 0;
      bool isIncomeAmount = record.incomeAmount != 0;
      bool isReimbursementAmount = record.reimbursementAmount != 0;

      barGroups.add(
        BarChartGroupData(
          x: day,
          barRods: [
            if (isIncomeAmount)
              buildSplitBarRod(
                record.incomeAmount,
                ChartConstants.bar.colorIncome,
              ),
            if (isExpenseAmount)
              buildSplitBarRod(
                record.expenseAmount,
                ChartConstants.bar.colorExpense,
              ),
            if (isReimbursementAmount)
              buildSplitBarRod(
                record.reimbursementAmount,
                ChartConstants.bar.colorReimbursement,
              ),
          ],
          // showingTooltipIndicators: [0],
        ),
      );
    });

    return barGroups;
  }

  BarChartRodData buildSplitBarRod(double amount, Color color) {
    return BarChartRodData(
      toY: amount.abs(),
      width: ChartConstants.bar.barWidthSplit,
      color: color,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
      backDrawRodData: BackgroundBarChartRodData(
        show: true,
        toY: widget.chartData.barHeight,
        color: color.withOpacity(.02),
      ),
    );
  }
}
