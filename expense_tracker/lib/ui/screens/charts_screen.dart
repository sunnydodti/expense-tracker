import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/chart_data.dart';
import '../../models/enums/chart_range.dart';
import '../../models/enums/chart_type.dart';
import '../../models/expense.dart';
import '../../providers/expense_provider.dart';
import '../widgets/charts/bar charts/weekly_expense_bar_chart.dart';
import '../widgets/charts/line charts/weekly_expense_line_chart.dart';
import '../widgets/charts/pie charts/weekly_expense_pie_chart.dart';

class ChartsScreen extends StatefulWidget {
  const ChartsScreen({super.key});

  @override
  ExpenseVisualizationScreenState createState() =>
      ExpenseVisualizationScreenState();
}

class ExpenseVisualizationScreenState extends State<ChartsScreen> {
  late ChartType _chartType;
  late ChartRange _chartRange;
  late List<Expense> _expenses;
  late ChartData _chartData;

  bool splitBarChart = false;

  @override
  void initState() {
    super.initState();
    _expenses = [];
    _chartData = ChartData(expenses: _expenses);
    // _chartService = ChartService(widget.expenses);
    _chartType = ChartType.bar;
    _chartRange = ChartRange.weekly;
  }

  ExpenseProvider get expenseProvider =>
      Provider.of<ExpenseProvider>(context, listen: false);

  Future<ChartData> _getChartData() async {
    // await Future.delayed(const Duration(milliseconds: 200));
    if (_expenses.isNotEmpty) return _chartData;
    // await Future.delayed(const Duration(milliseconds: 300));
    List<Expense> allExpenses = await expenseProvider.fetchAllExpenses();
    ChartData expenseChartData = ChartData(expenses: allExpenses);
    _expenses = allExpenses;
    _chartData = expenseChartData;
    return expenseChartData;
  }

  @override
  Widget build(BuildContext context) {
    return _buildChartScreen(context);
  }

  Scaffold _buildChartScreen(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Charts'),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.grey.shade900.withBlue(40),
        child: ListView(
          children: [
            _buildChart(),
            _buildChartRangeDropdown(),
            _buildChartTypeDropdown(),
          ],
        ),
      ),
    );
  }

  FutureBuilder<ChartData> _buildChart() {
    switch (_chartType) {
      case ChartType.bar:
        return _buildBarChart();
      case ChartType.pie:
        return _buildPieChart();
      case ChartType.line:
        return _buildLineChart();
    }
  }

  FutureBuilder<ChartData> _buildBarChart() {
    return _buildWeeklyExpenseBarChart();
  }

  FutureBuilder<ChartData> _buildPieChart() {
    return _buildWeeklyExpensePieChart();
  }

  FutureBuilder<ChartData> _buildLineChart() {
    return _buildWeeklyExpenseLineChart();
  }

  FutureBuilder<ChartData> _buildWeeklyExpenseBarChart() {
    return FutureBuilder<ChartData>(
        future: _getChartData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');

          Widget widget = SizedBox(
            height: MediaQuery.of(context).size.height * .4,
            child: Column(
              children: [
                Expanded(
                  flex: 9,
                  child: Stack(children: <Widget>[
                    (snapshot.connectionState == ConnectionState.waiting)
                        ? buildLoadingWidget()
                        : WeeklyExpenseBarChart(chartData: snapshot.data!),
                    buildChartToggleIcon()
                  ]),
                ),
              ],
            ),
          );
          return widget;
        });
  }

  FutureBuilder<ChartData> _buildWeeklyExpensePieChart() {
    return FutureBuilder<ChartData>(
        future: _getChartData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');

          Widget widget = SizedBox(
            height: MediaQuery.of(context).size.height * .4,
            child: Column(
              children: [
                Expanded(
                  flex: 9,
                  child: Stack(children: <Widget>[
                    (snapshot.connectionState == ConnectionState.waiting)
                        ? buildLoadingWidget()
                        : const WeeklyExpensePieChart(),
                    buildChartToggleIcon()
                  ]),
                ),
              ],
            ),
          );
          return widget;
        });
  }

  FutureBuilder<ChartData> _buildWeeklyExpenseLineChart() {
    return FutureBuilder<ChartData>(
        future: _getChartData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');

          Widget widget = SizedBox(
            height: MediaQuery.of(context).size.height * .4,
            child: Column(
              children: [
                Expanded(
                  flex: 9,
                  child: Stack(children: <Widget>[
                    (snapshot.connectionState == ConnectionState.waiting)
                        ? buildLoadingWidget()
                        : WeeklyExpenseLineChart(chartData: snapshot.data!),
                    buildChartToggleIcon()
                  ]),
                ),
              ],
            ),
          );
          return widget;
        });
  }

  Center buildLoadingWidget() => const Center(child: Text("Loading ..."));

  Container buildChartToggleIcon() {
    return Container(
        padding: const EdgeInsets.only(bottom: 65),
        alignment: Alignment.bottomLeft,
        child: IconButton(
            onPressed: () {
              ChartType newType = ChartType
                  .values[(_chartType.index + 1) % ChartType.values.length];
              setState(() => _chartType = newType);
            },
            icon: Icon(getChartIcon())));
  }

  IconData getChartIcon() {
    switch (_chartType) {
      case ChartType.bar:
        return Icons.bar_chart_outlined;
      case ChartType.pie:
        return Icons.pie_chart_outline;
      case ChartType.line:
        return Icons.line_axis_outlined;
    }
  }

  Container _buildChartRangeDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Chart Range",
            textScaleFactor: .9,
          ),
          DropdownButton<ChartRange>(
            value: _chartRange,
            onChanged: (chartRange) {
              //updateChartRange(chartRange);
            },
            items: ChartRange.values
                .map<DropdownMenuItem<ChartRange>>(
                  (chartRange) => DropdownMenuItem<ChartRange>(
                    value: chartRange,
                    child: Text(
                        textScaleFactor: .8, getChartRangeText(chartRange)),
                  ),
                )
                .toList(),
            underline: Container(),
          ),
        ],
      ),
    );
  }

  Container _buildChartTypeDropdown() {
    return Container(
      // color: Colors.grey.withOpacity(.2),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Chart Type",
            textScaleFactor: .9,
            overflow: TextOverflow.fade,
          ),
          DropdownButton<ChartType>(
            value: _chartType,
            onChanged: (chartType) {
              setState(() {
                _chartType = chartType!;
              });
            },
            items: ChartType.values
                .map<DropdownMenuItem<ChartType>>(
                  (chartType) => DropdownMenuItem<ChartType>(
                    value: chartType,
                    child: Text(
                        textScaleFactor: .8,
                        ChartTypeHelper.getChartTypeText(chartType)),
                  ),
                )
                .toList(),
            underline: Container(),
          ),
        ],
      ),
    );
  }
}
