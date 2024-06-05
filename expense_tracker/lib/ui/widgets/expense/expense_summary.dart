import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/constants/shared_preferences_constants.dart';
import '../../../data/helpers/navigation_helper.dart';
import '../../../providers/expense_provider.dart';
import '../../../service/shared_preferences_service.dart';
import '../../animations/blur_widget.dart';
import '../../screens/charts_screen.dart';

class ExpenseSummary extends StatefulWidget {
  const ExpenseSummary({Key? key}) : super(key: key);

  @override
  State<ExpenseSummary> createState() => _ExpenseSummaryState();
}

class _ExpenseSummaryState extends State<ExpenseSummary> {
  late bool hideTotal = false;
  SharedPreferencesService sharedPreferencesService =
      SharedPreferencesService();

  void getHideTotalPreference() async {
    bool? isTotalHidden = await sharedPreferencesService
        .getBoolPreference(SharedPreferencesConstants.summary.HIDE_TOTAL_KEY);

    setState(() {
      hideTotal = isTotalHidden ?? false;
    });
  }

  @override
  void initState() {
    getHideTotalPreference();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => navigateToChartsScreen(context),
      child: _buildSummary(),
    );
  }

  void navigateToChartsScreen(BuildContext context) =>
      NavigationHelper.navigateToScreen(context, const ChartsScreen());

  Consumer<ExpenseProvider> _buildSummary() {
    return Consumer<ExpenseProvider>(
        builder: (context, expenseProvider, child) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
        ),
      margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
      child: Column(
        children: [
          Stack(
            children: [
              _buildSummaryContainer(
                    "Total Balance", expenseProvider.getTotalBalance(),
                    top: 10, bottom: 5, left: 10, right: 10),
                buildIcons()
              ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _buildSummaryContainer(
                      "Total Income", expenseProvider.getTotalIncome(),
                      top: 5, bottom: 10, left: 10, right: 5),
                ),
                Expanded(
                  child: _buildSummaryContainer(
                      "Total Expense", expenseProvider.getTotalExpenses() * -1,
                      top: 5, bottom: 10, left: 5, right: 10),
                ),
              ],
          ),
        ],
      ),
    );
    });
  }

  Container _buildSummaryContainer(
    String summaryText,
    double amount, {
    double top = 10,
    double bottom = 10,
    double left = 10,
    double right = 10,
    double padding = 5,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
      ),
      margin:
          EdgeInsets.only(top: top, bottom: bottom, left: left, right: right),
      padding: EdgeInsets.symmetric(vertical: padding, horizontal: padding),
      child: Column(
        children: [
          _getSummaryText(summaryText),
          const SizedBox(height: 5),
          hideTotal
              ? BlurWidget(widget: _getSummaryAmount(amount))
              : _getSummaryAmount(amount),
        ],
      ),
    );
  }

  Text _getSummaryAmount(double amount) {
    String sign = amount > 0 ? '+' : (amount < 0 ? '-' : '');
    return Text(
      '$sign ₹ ${amount.abs().round()}',
      textScaleFactor: 1.1,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: amount > 0
            ? Colors.green.shade400
            : (amount < 0 ? Colors.red.shade400 : Colors.white70),
      ),
    );
  }

  Text _getSummaryText(String summaryText) {
    return Text(
      summaryText,
      textAlign: TextAlign.center,
      textScaleFactor: 1.1,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white70,
      ),
    );
  }

  buildIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildChartIcon(),
        buildIHideIcon(),
      ],
    );
  }

  Padding buildChartIcon() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: IconButton(
          onPressed: () => navigateToChartsScreen(context),
          icon: Icon(Icons.bar_chart_outlined, color: Colors.grey.shade400)),
    );
  }

  Padding buildIHideIcon() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: IconButton(
        onPressed: () {
          setState(() {
            hideTotal = !hideTotal;
          });
          setHideTotalPreference();
        },
        icon: hideTotal
            ? Icon(Icons.visibility_outlined, color: Colors.grey.shade400)
            : Icon(Icons.visibility_off_outlined, color: Colors.grey.shade400),
      ),
    );
  }

  void setHideTotalPreference() async {
    sharedPreferencesService.setBoolPreference(
        SharedPreferencesConstants.summary.HIDE_TOTAL_KEY, hideTotal);
    bool? hide = await sharedPreferencesService
        .getBoolPreference(SharedPreferencesConstants.summary.HIDE_TOTAL_KEY);
    int a = 0;
  }
}
