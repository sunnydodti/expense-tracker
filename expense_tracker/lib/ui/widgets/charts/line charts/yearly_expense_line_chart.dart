import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../data/constants/chart_constants.dart';
import '../../../../models/chart_record.dart';
import '../../../../providers/chart_data_provider.dart';
import '../chart_options.dart';
import '../chart_widgets.dart';

class YearlyExpenseLineChart extends StatefulWidget {
  const YearlyExpenseLineChart({super.key});

  @override
  State<YearlyExpenseLineChart> createState() => _YearlyExpenseLineChartState();
}

class _YearlyExpenseLineChartState extends State<YearlyExpenseLineChart> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: _buildYearlyLineChart(),
        ),
        const ChartOptions()
      ],
    );
  }

  Consumer<ChartDataProvider> _buildYearlyLineChart() {
    return Consumer<ChartDataProvider>(
      builder: (context, provider, child) {
        Map<int, ChartRecord> monthlySum = _getMonthlySumForYear(provider);
        List<LineChartBarData> lineBars = (provider.splitChart)
            ? _buildLineBarsForSplit(monthlySum)
            : _buildLineBarsForTotal(monthlySum);

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
                          ChartWidgets.getMonthTitles(context, value, meta),
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
        tooltipMargin: 50,
        getTooltipItems: (List<LineBarSpot> touchedSpots) {
          return touchedSpots.map((spot) {
            double value = spot.y;
            String text = '';

            if (value < 0) text += '- ';
            if (currency.isNotEmpty) text += '$currency ';

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

  Map<int, ChartRecord> _getMonthlySumForYear(ChartDataProvider provider) {
    return provider.chartData.calculateMonthlySumForYear(
        iSplitChart: provider.splitChart, year: provider.selectedYear);
  }

  List<LineChartBarData> _buildLineBarsForTotal(
      Map<int, ChartRecord> monthlySum) {
    List<FlSpot> spots = [];

    monthlySum.forEach((month, record) {
      spots.add(FlSpot(month.toDouble(), record.totalAmount));
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
      Map<int, ChartRecord> monthlySum) {
    List<FlSpot> incomeSpots = [];
    List<FlSpot> expenseSpots = [];
    List<FlSpot> reimbursementSpots = [];

    monthlySum.forEach((month, record) {
      incomeSpots.add(FlSpot(month.toDouble(), record.incomeAmount));
      expenseSpots.add(FlSpot(month.toDouble(), record.expenseAmount));
      reimbursementSpots
          .add(FlSpot(month.toDouble(), record.reimbursementAmount));
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
