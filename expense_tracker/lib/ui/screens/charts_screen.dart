import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/chart_data.dart';
import '../../models/enums/chart_type.dart';
import '../../models/expense.dart';
import '../../providers/expense_provider.dart';
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

  ExpenseProvider get expenseProvider =>
      Provider.of<ExpenseProvider>(context, listen: false);

  Future<List<Expense>> _getExpenses() async {
    await Future.delayed(const Duration(seconds: 1));
    return await expenseProvider.fetchAllExpenses();
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
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            Expanded(
                flex: 5,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: _buildWeeklyExpenseBarChart(),
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

  FutureBuilder<List<Expense>> _buildWeeklyExpenseBarChart() {
    return FutureBuilder(
        future: _getExpenses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return WeeklyExpenseBarChart(
                chartData: widget.chartData,
                barChartType: splitBarChart
                    ? ExpenseBarChartType.split
                    : ExpenseBarChartType.total);
          }
        });
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

  Column buildChartOptions() {
    return Column(
      children: const [
        Center(child: Text('1 Part')),
      ],
    );
  }
}
