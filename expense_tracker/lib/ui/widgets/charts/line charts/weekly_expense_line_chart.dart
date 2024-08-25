import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../data/constants/chart_constants.dart';
import '../../../../models/chart_data.dart';
import '../../../../models/chart_record.dart';
import '../../../../models/enums/chart_range.dart';
import '../../../../providers/ChartDataProvider.dart';
import '../chart_options.dart';
import '../chart_widgets.dart';

class WeeklyExpenseLineChart extends StatefulWidget {
  final ChartData chartData;
  final ChartRange chartRange;
  final String currency;

  const WeeklyExpenseLineChart(
      {super.key,
      required this.chartData,
      this.currency = "",
      this.chartRange = ChartRange.weekly});

  @override
  State<WeeklyExpenseLineChart> createState() => _WeeklyExpenseLineChartState();
}

class _WeeklyExpenseLineChartState extends State<WeeklyExpenseLineChart> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: _buildWeeklyLineChart(),
        ),
        const ChartOptions()
      ],
    );
  }

  Consumer<ChartDataProvider> _buildWeeklyLineChart() {
    return Consumer<ChartDataProvider>(
      builder: (context, provider, child) {
        Map<int, ChartRecord> dailySum = _getDailySumForWeek(provider);
        List<LineChartBarData> lineBars = (provider.splitChart)
            ? _buildLineBarsForSplit(dailySum)
            : _buildLineBarsForTotal(dailySum);
        return Container(
          padding:
              const EdgeInsets.only(top: 20, bottom: 5, left: 10, right: 10),
          margin: const EdgeInsets.all(1),
          child: LineChart(
            LineChartData(
              lineBarsData: lineBars,
              gridData: FlGridData(show: false),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                show: true,
                rightTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) =>
                          ChartWidgets.getTitles(context, value, meta),
                      reservedSize: 35,
                      interval: 1),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) =>
                          ChartWidgets.leftTitleWidgets(value, meta)),
                ),
              ),
              lineTouchData: buildLineTouchData(),
            ),
            swapAnimationCurve: Curves.linear,
            swapAnimationDuration: const Duration(milliseconds: 250),
          ),
        );
      },
    );
  }

  LineTouchData buildLineTouchData() {
    return LineTouchData(
      touchTooltipData: LineTouchTooltipData(
        fitInsideHorizontally: true,
        fitInsideVertically: true,
        tooltipMargin: 50,
        getTooltipItems: (List<LineBarSpot> touchedSpots) {
          return touchedSpots.map((spot) {
            double value = spot.y;
            String text = '';

            if (value < 0) text += '- ';
            if (widget.currency.isNotEmpty) text += '${widget.currency} ';

            text += value.abs().round().toString();
            TextStyle textStyle = TextStyle(
              color: spot.bar.color,
            );

            return LineTooltipItem(
              text,
              textStyle,
            );
          }).toList();
        },
      ),
    );
  }

  Map<int, ChartRecord> _getDailySumForWeek(ChartDataProvider provider) {
    return widget.chartData.calculateDailySumForWeek(provider.splitChart,
        week: provider.selectedWeek);
  }

  List<LineChartBarData> _buildLineBarsForTotal(
      Map<int, ChartRecord> dailySum) {
    List<FlSpot> spots = [];

    dailySum.forEach((day, record) {
      spots.add(FlSpot(day.toDouble(), record.totalAmount));
    });

    return [
      LineChartBarData(
        spots: spots,
        isCurved: true,
        preventCurveOverShooting: true,
        color: ChartConstants.line.color,
        barWidth: 3,
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(
            colors: [
              ChartConstants.line.color.withOpacity(0.3),
              ChartConstants.line.colorAccent.withOpacity(0.05),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
    ];
  }

  List<LineChartBarData> _buildLineBarsForSplit(
      Map<int, ChartRecord> dailySum) {
    List<FlSpot> incomeSpots = [];
    List<FlSpot> expenseSpots = [];
    List<FlSpot> reimbursementSpots = [];

    dailySum.forEach((day, record) {
      incomeSpots.add(FlSpot(day.toDouble(), record.incomeAmount));
      expenseSpots.add(FlSpot(day.toDouble(), record.expenseAmount));
      reimbursementSpots
          .add(FlSpot(day.toDouble(), record.reimbursementAmount));
    });

    return [
      LineChartBarData(
        spots: incomeSpots,
        isCurved: true,
        preventCurveOverShooting: true,
        color: ChartConstants.line.colorIncome,
        barWidth: 3,
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(
            colors: [
              ChartConstants.line.colorIncome.withOpacity(0.3),
              ChartConstants.line.colorIncomeAccent.withOpacity(0.05),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          color: ChartConstants.line.colorIncome.withOpacity(0.3),
        ),
      ),
      LineChartBarData(
        spots: expenseSpots,
        isCurved: true,
        preventCurveOverShooting: true,
        color: ChartConstants.line.colorExpense,
        barWidth: 3,
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(
            colors: [
              ChartConstants.line.colorExpense.withOpacity(0.3),
              ChartConstants.line.colorExpenseAccent.withOpacity(0.05),
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
        barWidth: 3,
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(
            colors: [
              ChartConstants.line.colorReimbursement.withOpacity(0.3),
              ChartConstants.line.colorReimbursementAccent.withOpacity(0.05),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
    ];
  }
}
