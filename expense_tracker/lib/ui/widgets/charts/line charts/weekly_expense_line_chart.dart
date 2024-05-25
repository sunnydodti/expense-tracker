import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../data/constants/chart_constants.dart';
import '../../../../models/chart_data.dart';
import '../../../../models/chart_record.dart';
import '../../../../models/enums/chart_range.dart';
import '../../../../models/enums/line_chart_type.dart';
import '../../../../service/chart_service.dart';

class WeeklyExpenseLineChart extends StatefulWidget {
  final ChartData chartData;
  final ChartRange chartRange;

  const WeeklyExpenseLineChart(
      {super.key,
      required this.chartData,
      this.chartRange = ChartRange.weekly});

  @override
  State<WeeklyExpenseLineChart> createState() => _WeeklyExpenseLineChartState();
}

class _WeeklyExpenseLineChartState extends State<WeeklyExpenseLineChart> {
  late int currentWeek;
  int selectedWeek = 0;

  late DateTime startDate;
  late DateTime endDate;

  bool splitLineChart = false;
  LineChartType lineChartType = LineChartType.total;

  @override
  void initState() {
    super.initState();
    currentWeek = ChartService.currentWeek;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: _buildWeeklyLineChart(),
        ),
        buildChartOptions(),
      ],
    );
  }

  Container buildChartOptions() {
    Map<String, DateTime> dates = ChartService.getWeekStartAndEnd(
        selectedWeek == 0 ? currentWeek : selectedWeek);
    return Container(
      color: Colors.grey.shade800.withOpacity(.2),
      padding: const EdgeInsets.only(top: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                  textScaleFactor: .9,
                  DateFormat('d MMM y').format(dates["start"]!)),
              const Text(textScaleFactor: .9, "-"),
              Text(
                  textScaleFactor: .9,
                  DateFormat('d MMM y').format(dates["end"]!)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: decrementWeek,
                      icon: const Icon(Icons.chevron_left)),
                  Text(
                      textScaleFactor: .9,
                      "Week ${selectedWeek == 0 ? currentWeek : selectedWeek}"),
                  IconButton(
                      onPressed: incrementWeek,
                      icon: const Icon(Icons.chevron_right)),
                ],
              ),
              Row(
                children: [
                  const Text(textScaleFactor: .9, "Split"),
                  Checkbox(
                      value: splitLineChart, onChanged: toggleLineChartType)
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void toggleLineChartType(value) {
    LineChartType chartType = LineChartType.total;
    if (value!) chartType = LineChartType.split;
    setState(() {
      splitLineChart = value!;
      lineChartType = chartType;
    });
  }

  void decrementWeek() {
    int week = selectedWeek == 0 ? currentWeek - 1 : selectedWeek - 1;
    if (week < 1) week = 52;
    setState(() {
      selectedWeek = week;
    });
  }

  void incrementWeek() {
    int week = selectedWeek == 0 ? currentWeek + 1 : selectedWeek + 1;
    if (week > 52) week = 1;
    setState(() {
      selectedWeek = week;
    });
  }

  Container _buildWeeklyLineChart() {
    Map<int, ChartRecord> dailySum = _getDailySumForWeek();
    List<LineChartBarData> lineBars = (lineChartType == LineChartType.split)
        ? _buildLineBarsForSplit(dailySum)
        : _buildLineBarsForTotal(dailySum);

    return Container(
      padding: const EdgeInsets.only(top: 20, bottom: 5, left: 10, right: 10),
      margin: const EdgeInsets.all(1),
      child: LineChart(
        LineChartData(
          lineBarsData: lineBars,
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
                  reservedSize: 35,
                  interval: 1),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) => leftTitleWidgets(value, meta),
              ),
            ),
          ),
        ),
        swapAnimationCurve: Curves.linear,
        swapAnimationDuration: const Duration(milliseconds: 250),
      ),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    String text = meta.formattedValue;
    if (value % meta.appliedInterval != 0) text = "";
    return Text(text, textScaleFactor: .85, textAlign: TextAlign.center);
  }

  Map<int, ChartRecord> _getDailySumForWeek() {
    return widget.chartData
        .calculateDailySumForWeekLine(lineChartType, week: selectedWeek);
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
