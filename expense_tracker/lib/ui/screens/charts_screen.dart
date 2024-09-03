import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/constants/form_constants.dart';
import '../../data/constants/shared_preferences_constants.dart';
import '../../data/helpers/color_helper.dart';
import '../../data/helpers/shared_preferences_helper.dart';
import '../../models/enums/chart_range.dart';
import '../../models/enums/chart_type.dart';
import '../../models/expense.dart';
import '../../providers/chart_data_provider.dart';
import '../../providers/expense_provider.dart';
import '../widgets/charts/bar charts/expense_bar_chart.dart';
import '../widgets/charts/line charts/expense_line_chart.dart';
import '../widgets/charts/pie charts/expense_pie_chart.dart';

class ChartsScreen extends StatefulWidget {
  final bool refreshData;

  const ChartsScreen({super.key, required this.refreshData});

  @override
  ChartsState createState() => ChartsState();
}

class ChartsState extends State<ChartsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  ExpenseProvider get expenseProvider =>
      Provider.of<ExpenseProvider>(context, listen: false);

  ChartDataProvider get chartDataProvider =>
      Provider.of<ChartDataProvider>(context, listen: false);

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

  FutureBuilder<bool> _buildChart(ChartDataProvider chartDataProvider) {
    return FutureBuilder<bool>(
        future: _prepareChartData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');

          Widget chart = _getChart(chartDataProvider);
          return SizedBox(
            height: MediaQuery.of(context).size.height * .4,
            child: Column(
              children: [
                Expanded(
                  flex: 9,
                  child: Stack(children: <Widget>[
                    (snapshot.connectionState == ConnectionState.waiting)
                        ? buildLoadingWidget()
                        : chart,
                    buildChartToggleIcon()
                  ]),
                ),
              ],
            ),
          );
        });
  }

  Widget _getChart(ChartDataProvider provider) {
    Widget chart;

    switch (chartDataProvider.chartType) {
      case ChartType.bar:
        chart = const ExpenseBarChart();
        break;
      case ChartType.pie:
        chart = const ExpensePieChart();
        break;
      case ChartType.line:
        chart = const ExpenseLineChart();
        break;
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height * .4,
      child: Column(
        children: [
          Expanded(
            flex: 9,
            child: chart,
          ),
        ],
      ),
    );
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

  Future<bool> _prepareChartData() async {
    await _getCurrency();
    await _getChartData();
    return true;
  }

  Future<bool> _getCurrency() async {
    String? currencyPreference = await SharedPreferencesHelper()
        .getString(SharedPreferencesConstants.settings.DEFAULT_CURRENCY);
    String currency = FormConstants.expense.currencies[currencyPreference!]!;
    chartDataProvider.currency = currency;
    return true;
  }

  Future<bool> _getChartData() async {
    if (widget.refreshData) {
      List<Expense> allExpenses =
          await expenseProvider.fetchAllExpensesForProfile();
      chartDataProvider.createChartData(allExpenses);
    }
    return true;
  }
}
