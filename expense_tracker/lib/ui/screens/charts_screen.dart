import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/constants/form_constants.dart';
import '../../data/constants/shared_preferences_constants.dart';
import '../../data/helpers/color_helper.dart';
import '../../data/helpers/shared_preferences_helper.dart';
import '../../models/chart_data.dart';
import '../../models/enums/chart_range.dart';
import '../../models/enums/chart_type.dart';
import '../../models/expense.dart';
import '../../providers/ChartDataProvider.dart';
import '../../providers/expense_provider.dart';
import '../widgets/charts/bar charts/weekly_expense_bar_chart.dart';
import '../widgets/charts/line charts/weekly_expense_line_chart.dart';
import '../widgets/charts/pie charts/weekly_expense_pie_chart.dart';

class ChartsScreen extends StatefulWidget {
  const ChartsScreen({super.key});

  @override
  ChartsState createState() => ChartsState();
}

class ChartsState extends State<ChartsScreen> {
  late String currency;

  @override
  void initState() {
    super.initState();
    _getCurrency();
  }

  ExpenseProvider get expenseProvider =>
      Provider.of<ExpenseProvider>(context, listen: false);

  ChartDataProvider get chartDataProvider =>
      Provider.of<ChartDataProvider>(context, listen: false);

  Future<ChartData> _getChartData() async {
    if (chartDataProvider.expenses.isNotEmpty) {
      return chartDataProvider.chartData;
    }
    List<Expense> allExpenses = await expenseProvider.fetchAllExpenses();
    return chartDataProvider.createChartData(allExpenses);
  }

  @override
  Widget build(BuildContext context) {
    return _buildChartScreen(context);
  }

  Scaffold _buildChartScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorHelper.getBackgroundColor(Theme.of(context)),
      appBar: AppBar(
        title: const Text('Charts'),
        centerTitle: true,
        backgroundColor: ColorHelper.getAppBarColor(Theme.of(context)),
      ),
      body: Consumer<ChartDataProvider>(
        builder: (context, chartDataProvider, child) {
          return ListView(
            children: [
              _buildChart(chartDataProvider),
              _buildChartRangeDropdown(),
              _buildChartTypeDropdown(),
            ],
          );
        },
      ),
    );
  }

  FutureBuilder<ChartData> _buildChart(ChartDataProvider chartDataProvider) {
    switch (chartDataProvider.chartType) {
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
                        : WeeklyExpenseBarChart(
                            chartData: snapshot.data!,
                            currency: currency,
                          ),
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
                        : WeeklyExpenseLineChart(
                            chartData: snapshot.data!, currency: currency),
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

  Consumer<ChartDataProvider> buildChartToggleIcon() {
    return Consumer<ChartDataProvider>(
      builder: (context, chartDataProvider, child) => Container(
          padding: const EdgeInsets.only(bottom: 65),
          alignment: Alignment.bottomLeft,
          child: IconButton(
            onPressed: () {
              ChartType newType = ChartType.values[
                  (chartDataProvider.chartType.index + 1) %
                      ChartType.values.length];
              setState(() => chartDataProvider.chartType = newType);
            },
            icon: Icon(getChartIcon(chartDataProvider.chartType)),
            color: ColorHelper.getIconColor(
              Theme.of(context),
            ),
          )),
    );
  }

  IconData getChartIcon(ChartType chartType) {
    switch (chartType) {
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
          Consumer<ChartDataProvider>(
            builder: (context, chartDataProvider, child) {
              return DropdownButton<ChartRange>(
                value: chartDataProvider.chartRange,
                onChanged: (chartRange) {
                  chartDataProvider.chartRange = chartRange!;
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
              );
            },
          ),
        ],
      ),
    );
  }

  Container _buildChartTypeDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Chart Type",
            textScaleFactor: .9,
            overflow: TextOverflow.fade,
          ),
          Consumer<ChartDataProvider>(
            builder: (context, chartDataProvider, child) =>
                DropdownButton<ChartType>(
              value: chartDataProvider.chartType,
              onChanged: (chartType) {
                chartDataProvider.chartType = chartType!;
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
          ),
        ],
      ),
    );
  }

  void _getCurrency() async {
    String? currencyPreference = await SharedPreferencesHelper()
        .getString(SharedPreferencesConstants.settings.DEFAULT_CURRENCY);
    setState(() {
      currency = FormConstants.expense.currencies[currencyPreference!]!;
    });
  }
}
