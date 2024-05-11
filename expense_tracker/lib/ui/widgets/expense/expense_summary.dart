import 'package:flutter/material.dart';

import '../../../data/helpers/navigation_helper.dart';
import '../../../providers/expense_provider.dart';
import '../../animations/blur_widget.dart';
import '../../screens/charts_screen.dart';

class ExpenseSummary extends StatefulWidget {
  final ExpenseProvider expenseProvider;

  const ExpenseSummary({
    Key? key,
    required this.expenseProvider,
  }) : super(key: key);

  @override
  State<ExpenseSummary> createState() => _ExpenseSummaryState();
}

class _ExpenseSummaryState extends State<ExpenseSummary> {
  // bool hideTotal = false;
  bool hideTotal = true;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => NavigationHelper.navigateToScreen(context, const ChartsScreen()),
      child: _buildSummary(),
    );
  }

  Container _buildSummary() {
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
                  "Total Balance", widget.expenseProvider.getTotalBalance(),
                  top: 10, bottom: 5, left: 10, right: 10),
              buildIHideIcon()
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _buildSummaryContainer(
                    "Total Income", widget.expenseProvider.getTotalIncome(),
                    top: 5, bottom: 10, left: 10, right: 5),
              ),
              Expanded(
                child: _buildSummaryContainer("Total Expense",
                    widget.expenseProvider.getTotalExpenses() * -1,
                    top: 5, bottom: 10, left: 5, right: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Align buildIHideIcon() {
    return Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.only(top: 2, right: 10),
          child: IconButton(
              onPressed: () => setState(() {
                    hideTotal = !hideTotal;
                  }),
              icon: hideTotal
                  ? const Icon(Icons.visibility_outlined)
                  : const Icon(Icons.visibility_off_outlined)),
        ));
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
}
