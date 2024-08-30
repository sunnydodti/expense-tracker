import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../data/constants/chart_constants.dart';
import '../../../../models/chart_data.dart';
import '../../../../models/chart_record.dart';
import '../../../../providers/chart_data_provider.dart';
import '../../../../service/chart_service.dart';
import '../chart_options.dart';
import '../chart_widgets.dart';

class WeeklyExpenseBarChart extends StatefulWidget {
  const WeeklyExpenseBarChart({super.key});

  @override
  State<WeeklyExpenseBarChart> createState() => _WeeklyExpenseBarChartState();
}

class _WeeklyExpenseBarChartState extends State<WeeklyExpenseBarChart> {
  int touchedIndex = -1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: Consumer<ChartDataProvider>(
          builder: (context, provider, child) {
            return _buildWeeklyBarChart(provider);
          },
        )),
        const ChartOptions(),
      ],
    );
  }

  Container _buildWeeklyBarChart(ChartDataProvider provider) {
    Map<int, ChartRecord> dailySum = _getDailySumForWeek(provider);

    List<BarChartGroupData> barGroups = (provider.splitChart)
        ? _buildBarGroupsForSplit(dailySum, provider.chartData)
        : _buildBarGroupsForTotal(dailySum, provider.chartData);

    return Container(
      padding: const EdgeInsets.only(top: 20, bottom: 5, left: 10),
      child: BarChart(
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
                getTitlesWidget: (value, meta) =>
                    ChartWidgets.getDayTitles(context, value, meta),
                reservedSize: 35,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 35,
                getTitlesWidget: (value, meta) =>
                    ChartWidgets.leftTitleWidgets(value, meta),
              ),
            ),
          ),
          barTouchData: buildBarTouchData(provider),
        ),
        swapAnimationCurve: Curves.linear,
        swapAnimationDuration: const Duration(milliseconds: 250),
      ),
    );
  }

  BarTouchData buildBarTouchData(ChartDataProvider provider) {
    return BarTouchData(
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if ((!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null)) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
        },
        touchTooltipData: BarTouchTooltipData(
          fitInsideHorizontally: true,
          fitInsideVertically: true,
          tooltipHorizontalAlignment: touchedIndex < 3
              ? FLHorizontalAlignment.right
              : FLHorizontalAlignment.left,
          tooltipHorizontalOffset: touchedIndex < 3 ? 10 : -10,
          tooltipMargin: 50,
        getTooltipItem: (group, groupIndex, rod, rodIndex) {
          String text = "";
          if (provider.currency.isNotEmpty) text += '${provider.currency} ';
          text += provider.splitChart
              ? rod.toY.round().toString()
              : (rod.toY - provider.chartData.barHeightDay * .05)
                  .round()
                  .toString();

          return BarTooltipItem(
            '${ChartService.getWeekDay(group.x)}\n',
            const TextStyle(color: Colors.white),
            children: <TextSpan>[
              TextSpan(
                  text: text,
                  style:
                      provider.splitChart ? TextStyle(color: rod.color) : null),
            ],
          );
        },
      ),
    );
  }

  Map<int, ChartRecord> _getDailySumForWeek(ChartDataProvider provider) {
    return provider.chartData.calculateDailySumForWeek(provider.splitChart,
        week: provider.selectedWeek);
  }

  List<BarChartGroupData> _buildBarGroupsForTotal(
      Map<int, ChartRecord> dailySum, ChartData chartData) {
    List<BarChartGroupData> barGroups = [];

    dailySum.forEach((day, record) {
      double maxHeight = chartData.barHeightDay;
      bool isTouched = touchedIndex == day - 1;

      double total = record.totalAmount;
      double touchTotal =
          record.totalAmount.abs() + chartData.barHeightDay * .05;

      final Color color =
          total > 0 ? Colors.green.shade400 : Colors.red.shade400;
      final Color touchColor = Colors.blue.shade600;

      barGroups.add(
        BarChartGroupData(
          x: day,
          barRods: [
            BarChartRodData(
              toY: isTouched ? touchTotal.abs() : total.abs(),
              width: ChartConstants.bar.barWidth,
              color: isTouched ? touchColor : color,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(4)),
              backDrawRodData: BackgroundBarChartRodData(
                show: true,
                toY: maxHeight,
                color: isTouched
                    ? touchColor.withOpacity(.5)
                    : color.withOpacity(.1),
              ),
            ),
          ],
          // showingTooltipIndicators: [0],
        ),
      );
    });

    return barGroups;
  }

  List<BarChartGroupData> _buildBarGroupsForSplit(
      Map<int, ChartRecord> dailySum, ChartData chartData) {
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
              _buildSplitBarRod(
                record.incomeAmount,
                  ChartConstants.bar.colorIncome, chartData),
            if (isExpenseAmount)
              _buildSplitBarRod(
                record.expenseAmount,
                  ChartConstants.bar.colorExpense, chartData),
            if (isReimbursementAmount)
              _buildSplitBarRod(
                record.reimbursementAmount,
                  ChartConstants.bar.colorReimbursement, chartData),
          ],
        ),
      );
    });

    return barGroups;
  }

  BarChartRodData _buildSplitBarRod(double amount, Color color, chartData) {
    return BarChartRodData(
      toY: amount.abs(),
      width: ChartConstants.bar.barWidthSplit,
      color: color,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
      backDrawRodData: BackgroundBarChartRodData(
        show: true,
        toY: chartData.barHeightDay,
        color: color.withOpacity(.1),
      ),
    );
  }
}
