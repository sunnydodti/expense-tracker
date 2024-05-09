import 'package:flutter/material.dart';

import '../../models/chart_data.dart';
import '../../models/enums/chart_type.dart';
import '../../models/expense.dart';
import '../../service/chart_service.dart';
import '../widgets/charts/weekly_expense_bar_chart.dart';

class ChartsScreen extends StatefulWidget {
  final List<Expense> expenses;
  late final ChartData chartData;

  ChartsScreen(this.expenses, {super.key}) {
    chartData = ChartData(expenses: expenses);
  }

  @override
  ExpenseVisualizationScreenState createState() =>
      ExpenseVisualizationScreenState();
}

class ExpenseVisualizationScreenState extends State<ChartsScreen> {
  late ChartService _chartService;
  late ChartType _chartType;

  bool splitBarChart = false;

  @override
  void initState() {
    super.initState();
    _chartService = ChartService(widget.expenses);
    _chartType = ChartType.bar;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Charts'),
        centerTitle: true,
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            Expanded(
                flex: 4,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: WeeklyExpenseBarChart(
                      chartData: widget.chartData,
                      barChartType: splitBarChart
                          ? ExpenseBarChartType.split
                          : ExpenseBarChartType.total),
                )),
            Expanded(
                flex: 1,
                child: Container(
                  color: Colors.grey.shade800.withOpacity(.3),
                  child: buildChartOptions(),
                )),
            Expanded(
                flex: 5,
                child: Container(
                  color: Colors.grey.shade800.withOpacity(.6),
                  child: buildChartFilters(),
                ))
          ],
        ),
      ),
    );
  }

  Widget buildChartFilters() {
    if (_chartType == ChartType.bar) {
      return ListView(
        children: [
          CheckboxListTile(
              dense: true,
              title: const Text("Split"),
              value: splitBarChart,
              onChanged: (value) => setState(() {
                    splitBarChart = value!;
                  })),
        ],
      );
    }
    return const Center(child: Text('5 Parts'));
  }

  Center buildChartOptions() {
    return const Center(child: Text('1 Part'));
  }
}
