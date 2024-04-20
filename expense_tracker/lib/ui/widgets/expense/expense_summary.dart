import 'package:flutter/material.dart';

import '../../../providers/expense_provider.dart';

class ExpenseSummary extends StatelessWidget {
  final ExpenseProvider expenseProvider;

  const ExpenseSummary({
    Key? key,
    required this.expenseProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
      ),
      margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
      child: Column(
        children: [
          _buildSummaryContainer(
              "Total Balance", expenseProvider.getTotalBalance(),
              top: 10, bottom: 5, left: 10, right: 10),
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
          _getSummaryAmount(amount),
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
