import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../data/constants/chart_constants.dart';
import '../../../../data/constants/ui_constants.dart';
import '../../../../models/chart_data.dart';
import '../../../../models/chart_record.dart';
import '../../../../providers/chart_data_provider.dart';
import '../../../../service/chart_service.dart';
import '../chart_options.dart';
import '../chart_widgets.dart';

class YearlyExpenseBarChart extends StatefulWidget {
  const YearlyExpenseBarChart({super.key});

  @override
  State<YearlyExpenseBarChart> createState() => _YearlyExpenseBarChartState();
}

class _YearlyExpenseBarChartState extends State<YearlyExpenseBarChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: Consumer<ChartDataProvider>(
          builder: (context, provider, child) {
            return _buildYearlyBarChart(provider);
          },
        )),
        const ChartOptions(),
      ],
    );
  }

  Container _buildYearlyBarChart(ChartDataProvider provider) {
    Map<int, ChartRecord> monthlySum = _getMonthlySumForYear(provider);

    List<BarChartGroupData> barGroups = (provider.splitChart)
        ? _buildBarGroupsForSplit(monthlySum, provider.chartData)
        : _buildBarGroupsForTotal(monthlySum, provider.chartData);

    return Container(
      padding: const EdgeInsets.only(
          top: uiChartBarPaddingTop,
          bottom: uiChartBarPaddingBottom,
          left: uiChartBarPaddingLeft),
      child: BarChart(
        BarChartData(
          barGroups: barGroups,
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) =>
                    ChartWidgets.getMonthTitles(context, value, meta),
                reservedSize: uiChartBarReservedSize,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: uiChartBarReservedSize,
                getTitlesWidget: (value, meta) =>
                    ChartWidgets.leftTitleWidgets(value, meta),
              ),
            ),
          ),
          barTouchData: buildBarTouchData(provider),
        ),
        swapAnimationCurve: Curves.linear,
        swapAnimationDuration: uiChartSwapAnimationDuration,
      ),
    );
  }

  Map<int, ChartRecord> _getMonthlySumForYear(ChartDataProvider provider) {
    return provider.chartData.calculateMonthlySumForYear(
        iSplitChart: provider.splitChart, year: provider.selectedYear);
  }

  List<BarChartGroupData> _buildBarGroupsForTotal(
      Map<int, ChartRecord> monthlySum, ChartData chartData) {
    List<BarChartGroupData> barGroups = [];

    monthlySum.forEach((month, record) {
      double maxHeight = chartData.barHeightMonth;
      bool isTouched = touchedIndex == month - 1;

      double total = record.totalAmount;
      double touchTotal = record.totalAmount.abs() +
          chartData.barHeightMonth * uiChartBarTouchTotalHeightFactor;

      final Color color =
          total > 0 ? Colors.green.shade400 : Colors.red.shade400;
      final Color touchColor = Colors.blue.shade600;

      barGroups.add(
        BarChartGroupData(
          x: month,
          barRods: [
            BarChartRodData(
              toY: isTouched ? touchTotal.abs() : total.abs(),
              width: ChartConstants.bar.barWidthMonth,
              color: isTouched ? touchColor : color,
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(uiChartBarRadius)),
              backDrawRodData: BackgroundBarChartRodData(
                show: true,
                toY: maxHeight,
                color: isTouched
                    ? touchColor.withValues(alpha: uiChartBarTouchOpacity)
                    : color.withValues(alpha: uiChartBarOpacity),
              ),
            ),
          ],
        ),
      );
    });

    return barGroups;
  }

  List<BarChartGroupData> _buildBarGroupsForSplit(
      Map<int, ChartRecord> monthlySum, ChartData chartData) {
    List<BarChartGroupData> barGroups = [];

    monthlySum.forEach((month, record) {
      bool isExpenseAmount = record.expenseAmount != 0;
      bool isIncomeAmount = record.incomeAmount != 0;
      bool isReimbursementAmount = record.reimbursementAmount != 0;

      barGroups.add(
        BarChartGroupData(
          x: month,
          barRods: [
            if (isIncomeAmount)
              _buildSplitBarRod(
                record.incomeAmount,
                ChartConstants.bar.colorIncome,
                chartData,
              ),
            if (isExpenseAmount)
              _buildSplitBarRod(
                record.expenseAmount,
                ChartConstants.bar.colorExpense,
                chartData,
              ),
            if (isReimbursementAmount)
              _buildSplitBarRod(
                record.reimbursementAmount,
                ChartConstants.bar.colorReimbursement,
                chartData,
              ),
          ],
        ),
      );
    });

    return barGroups;
  }

  BarChartRodData _buildSplitBarRod(double amount, Color color, chartData) {
    return BarChartRodData(
      toY: amount.abs(),
      width: ChartConstants.bar.barWidthSplitMonth,
      color: color,
      borderRadius: const BorderRadius.vertical(
          top: Radius.circular(uiChartBarRadius)),
      backDrawRodData: BackgroundBarChartRodData(
        show: true,
        toY: chartData.barHeightMonth,
        color: color.withValues(alpha: uiChartBarOpacity),
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
        tooltipHorizontalAlignment: touchedIndex < 2
            ? FLHorizontalAlignment.right
            : FLHorizontalAlignment.left,
        tooltipHorizontalOffset: touchedIndex < 2
            ? uiChartBarTooltipOffset
            : -uiChartBarTooltipOffset,
        tooltipMargin: uiChartBarTooltipMargin,
        getTooltipItem: (group, groupIndex, rod, rodIndex) {
          String text = "";
          if (provider.currency.isNotEmpty) text += '${provider.currency} ';
          text += provider.splitChart
              ? rod.toY.round().toString()
              : (rod.toY -
                      provider.chartData.barHeightMonth *
                          uiChartBarTouchTotalHeightFactor)
                  .round()
                  .toString();

          return BarTooltipItem(
            '${ChartService.getMonthName(group.x)}\n',
            const TextStyle(color: Colors.white),
            children: <TextSpan>[
              TextSpan(
                text: text,
                style: provider.splitChart ? TextStyle(color: rod.color) : null,
              ),
            ],
          );
        },
      ),
    );
  }
}
