import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../models/chart_data.dart';

class WeeklyExpenseChart extends StatefulWidget {
  final ChartData chartData;

  const WeeklyExpenseChart({super.key, required this.chartData});

  @override
  State<WeeklyExpenseChart> createState() => _WeeklyExpenseChartState();
}

class _WeeklyExpenseChartState extends State<WeeklyExpenseChart> {
  double barWidth = 15;

  @override
  Widget build(BuildContext context) {
    Map<int, double> dailySum = widget.chartData.calculateDailySumForWeek();

    // return _buildBarChart(dailySum);
    return BarChart(
      BarChartData(
        barGroups: _buildBarGroups(dailySum),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
      ),
      // swapAnimationCurve: Curves.linear,
      // swapAnimationDuration: const Duration(milliseconds: 500),
    );
  }

  BarChart _buildBarChart(Map<int, double> dailySum) {
    return BarChart(
      BarChartData(
        barGroups: _createBarGroups(dailySum),
        titlesData: _buildTitles(),
        // borderData: FlBorderData(show: false),
        // barTouchData: BarTouchData(enabled: false),
        gridData: FlGridData(
          // show: true,
          // horizontalInterval: 10.0,
          getDrawingHorizontalLine: (value) {
            return FlLine(color: Colors.grey[300]!, strokeWidth: 1);
          },
        ),
      ),
    );
  }

  List<BarChartGroupData> _createBarGroups(Map<int, double> dailySum) {
    List<BarChartGroupData> barGroups = [];

    dailySum.forEach((day, sum) {
      barGroups.add(
        BarChartGroupData(
          x: day,
          barRods: [
            BarChartRodData(
              toY: sum,
              color: Colors.blue,
              width: 16,
            ),
          ],
        ),
      );
    });

    return barGroups;
  }

  FlTitlesData _buildTitles() {
    return FlTitlesData(
      leftTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: true, reservedSize: 40),
      ),
      rightTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false, reservedSize: 40),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
        ),
      ),
      topTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: false,
        ),
      ),
    );
  }

  _buildBarGroups(Map<int, double> dailySum) {
    List<BarChartGroupData> barGroups = [];

    dailySum.forEach((day, sum) {
      barGroups.add(
        BarChartGroupData(
          x: day,
          barRods: [
            BarChartRodData(
              toY: sum,
              width: barWidth,
              color: Colors.blue.shade400,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(4)),
              backDrawRodData: BackgroundBarChartRodData(
                show: true,
                toY: widget.chartData.barHeight,
                color: Colors.blue.shade200.withOpacity(.15),
              ),
            ),
          ],
          // showingTooltipIndicators: [0],
        ),
      );
    });

    return barGroups;
  }
}
