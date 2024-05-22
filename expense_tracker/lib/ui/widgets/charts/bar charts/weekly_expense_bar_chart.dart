import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../data/constants/chart_constants.dart';
import '../../../../models/chart_data.dart';
import '../../../../models/chart_record.dart';
import '../../../../models/enums/chart_type.dart';
import '../../../../service/chart_service.dart';

class WeeklyExpenseBarChart extends StatefulWidget {
  final ChartData chartData;
  final ChartRange chartRange;

  const WeeklyExpenseBarChart(
      {super.key,
      required this.chartData,
      this.chartRange = ChartRange.weekly});

  @override
  State<WeeklyExpenseBarChart> createState() => _WeeklyExpenseBarChartState();
}

class _WeeklyExpenseBarChartState extends State<WeeklyExpenseBarChart> {
  late int currentWeek;
  int selectedWeek = 0;

  late DateTime startDate;
  late DateTime endDate;

  bool splitBarChart = false;
  ExpenseBarChartType barChartType = ExpenseBarChartType.total;

  int touchedIndex = -1;

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
          child: _buildWeeklyBarChart(),
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
                  Checkbox(value: splitBarChart, onChanged: toggleBarChartType)
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void toggleBarChartType(value) {
    ExpenseBarChartType chartType = ExpenseBarChartType.total;
    if (value!) chartType = ExpenseBarChartType.split;
    setState(() {
      splitBarChart = value!;
      barChartType = chartType;
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

  Container _buildWeeklyBarChart() {
    Map<int, ChartRecord> dailySum = _getDailySumForWeek();
    List<BarChartGroupData> barGroups =
        (barChartType == ExpenseBarChartType.split)
            ? _buildBarGroupsForSplit(dailySum)
            : _buildBarGroupsForTotal(dailySum);
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
                getTitlesWidget: getTitles,
                reservedSize: 35,
              ),
            ),
          ),
          barTouchData: barChartType == ExpenseBarChartType.total
              ? buildBarTouchData()
              : null,
        ),
        swapAnimationCurve: Curves.linear,
        swapAnimationDuration: const Duration(milliseconds: 250),
      ),
    );
  }

  BarTouchData buildBarTouchData() {
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
            String weekDay = ChartService.getWeekDay(group.x);
            return BarTooltipItem(
              '$weekDay\n',
              const TextStyle(),
              children: <TextSpan>[
                TextSpan(
                  text: (rod.toY - widget.chartData.barHeight * .05)
                      .round()
                      .toString(),
                  style: const TextStyle(),
                ),
              ],
            );
          },
        ));
  }

  Map<int, ChartRecord> _getDailySumForWeek() {
    return widget.chartData
        .calculateDailySumForWeek(barChartType, week: selectedWeek);
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
      double maxHeight = widget.chartData.barHeight;
      bool isTouched = touchedIndex == day - 1;

      double total = record.totalAmount;
      double touchTotal =
          record.totalAmount.abs() + widget.chartData.barHeight * .05;

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
        color: color.withOpacity(.1),
      ),
    );
  }
}
