import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/chart_data.dart';
import '../../models/enums/chart_type.dart';
import '../../models/expense.dart';
import '../../providers/expense_provider.dart';
import '../widgets/charts/weekly_expense_bar_chart.dart';

class ChartsScreen extends StatefulWidget {
  const ChartsScreen({super.key});

  @override
  ExpenseVisualizationScreenState createState() =>
      ExpenseVisualizationScreenState();
}

class ExpenseVisualizationScreenState extends State<ChartsScreen> {
  late ChartType _chartType;
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
                  // child: const Placeholder(),
                ))
          ],
        ),
      ),
    );
  }

  FutureBuilder<ChartData> _buildWeeklyExpenseBarChart() {
    return FutureBuilder<ChartData>(
        future: _getChartData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text("Loading ..."));
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return WeeklyExpenseBarChart(chartData: snapshot.data!);
          }
        });
  }

  Column buildChartOptions() {
    return Column(
      children: const [
        Center(child: Text('1 Part')),
      ],
    );
  }
}
