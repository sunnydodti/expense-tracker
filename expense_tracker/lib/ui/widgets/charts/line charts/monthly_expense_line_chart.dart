import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../data/constants/chart_constants.dart';
import '../../../../data/constants/ui_constants.dart';
import '../../../../models/chart_record.dart';
import '../../../../providers/chart_data_provider.dart';
import '../chart_options.dart';
import '../chart_widgets.dart';

class MonthlyExpenseLineChart extends StatelessWidget {
  const MonthlyExpenseLineChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: _buildMonthlyLineChart(),
        ),
        const ChartOptions(),
      ],
    );
  }

  Consumer<ChartDataProvider> _buildMonthlyLineChart() {
    return Consumer<ChartDataProvider>(
      builder: (context, provider, child) {
        Map<int, ChartRecord> weeklySum = _getWeeklySumForMonth(provider);
        List<LineChartBarData> lineBars = (provider.splitChart)
            ? _buildLineBarsForSplit(weeklySum)
            : _buildLineBarsForTotal(weeklySum);
        return Container(
          padding: const EdgeInsets.only(
            top: uiChartLinePaddingTop,
            bottom: uiChartLinePaddingBottom,
            left: uiChartLinePaddingLeft,
            right: uiChartLinePaddingRight,
          ),
          margin: const EdgeInsets.all(1),
          child: LineChart(
            LineChartData(
              lineBarsData: lineBars,
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                show: true,
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) =>
                        ChartWidgets.getWeekTitlesForMonth(
                      context,
                      value,
                      meta,
                    ),
                    reservedSize: uiChartLineReservedSizeBottom,
                    interval: 1,
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: uiChartLineReservedSizeLeft,
                    getTitlesWidget: (value, meta) =>
                        ChartWidgets.leftTitleWidgets(value, meta),
                  ),
                ),
              ),
              lineTouchData: buildLineTouchData(provider.currency),
            ),
            // swapAnimationCurve: Curves.linear,
            // swapAnimationDuration: const Duration(milliseconds: 250),
          ),
        );
      },
    );
  }

  LineTouchData buildLineTouchData(String currency) {
    return LineTouchData(
      touchTooltipData: LineTouchTooltipData(
        fitInsideHorizontally: true,
        fitInsideVertically: true,
        tooltipMargin: uiChartLineTooltipMargin,
        getTooltipItems: (List<LineBarSpot> touchedSpots) {
          return touchedSpots.map((spot) {
            double value = spot.y;
            String text = '';

            if (value < 0) text += '- ';
            if (currency.isNotEmpty) text += '$currency ';

            text += value.abs().round().toString();
            TextStyle textStyle = TextStyle(color: spot.bar.color);

            return LineTooltipItem(text, textStyle);
          }).toList();
        },
      ),
    );
  }

  Map<int, ChartRecord> _getWeeklySumForMonth(ChartDataProvider provider) {
    return provider.chartData.calculateWeeklySumForMonth(
      provider.splitChart,
      month: provider.selectedMonth,
    );
  }

  List<LineChartBarData> _buildLineBarsForTotal(
    Map<int, ChartRecord> weeklySum,
  ) {
    List<FlSpot> spots = [];

    weeklySum.forEach((week, record) {
      spots.add(FlSpot(week.toDouble(), record.totalAmount));
    });

    return [
      LineChartBarData(
        spots: spots,
        isCurved: true,
        preventCurveOverShooting: true,
        color: ChartConstants.line.color,
        barWidth: uiChartLineBarWidth,
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(
            colors: [
              ChartConstants.line.color.withValues(alpha: uiChartLineOpacity),
              ChartConstants.line.colorAccent.withValues(
                alpha: uiChartLineAccentOpacity,
              ),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
    ];
  }

  List<LineChartBarData> _buildLineBarsForSplit(
    Map<int, ChartRecord> weeklySum,
  ) {
    List<FlSpot> incomeSpots = [];
    List<FlSpot> expenseSpots = [];
    List<FlSpot> reimbursementSpots = [];

    weeklySum.forEach((week, record) {
      incomeSpots.add(FlSpot(week.toDouble(), record.incomeAmount));
      expenseSpots.add(FlSpot(week.toDouble(), record.expenseAmount));
      reimbursementSpots.add(
        FlSpot(week.toDouble(), record.reimbursementAmount),
      );
    });

    return [
      LineChartBarData(
        spots: incomeSpots,
        isCurved: true,
        preventCurveOverShooting: true,
        color: ChartConstants.line.colorIncome,
        barWidth: uiChartLineBarWidth,
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(
            colors: [
              ChartConstants.line.colorIncome.withValues(
                alpha: uiChartLineOpacity,
              ),
              ChartConstants.line.colorIncomeAccent.withValues(
                alpha: uiChartLineAccentOpacity,
              ),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
      LineChartBarData(
        spots: expenseSpots,
        isCurved: true,
        preventCurveOverShooting: true,
        color: ChartConstants.line.colorExpense,
        barWidth: uiChartLineBarWidth,
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(
            colors: [
              ChartConstants.line.colorExpense.withValues(
                alpha: uiChartLineOpacity,
              ),
              ChartConstants.line.colorExpenseAccent.withValues(
                alpha: uiChartLineAccentOpacity,
              ),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
      LineChartBarData(
        spots: reimbursementSpots,
        isCurved: true,
        preventCurveOverShooting: true,
        color: ChartConstants.line.colorReimbursement,
        barWidth: uiChartLineBarWidth,
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(
            colors: [
              ChartConstants.line.colorReimbursement.withValues(
                alpha: uiChartLineOpacity,
              ),
              ChartConstants.line.colorReimbursementAccent.withValues(
                alpha: uiChartLineAccentOpacity,
              ),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
    ];
  }
}
