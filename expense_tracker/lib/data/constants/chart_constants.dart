import 'package:flutter/material.dart';

class ChartConstants {
  static BarChartConstants bar = BarChartConstants();
  static LineChartConstants line = LineChartConstants();
}

class BarChartConstants {
  final double barWidth = 15;
  final double barWidthMonth = 13;
  final double barWidthSplit = 8;
  final double barWidthSplitMonth = 5;

  final Color color = Colors.blue.shade400;
  final Color colorExpense = Colors.red.shade400;
  final Color colorIncome = Colors.green.shade400;
  final Color colorReimbursement = Colors.white;
}

class LineChartConstants {
  final double barWidth = 15;
  final double barWidthSplit = 8;

  final Color color = Colors.blue.shade400;
  final Color colorExpense = Colors.red.shade400;
  final Color colorIncome = Colors.green.shade400;
  final Color colorReimbursement = Colors.white;

  final Color colorAccent = Colors.indigoAccent;
  final Color colorExpenseAccent = Colors.redAccent;
  final Color colorIncomeAccent = Colors.greenAccent;
  final Color colorReimbursementAccent = Colors.indigoAccent;

}