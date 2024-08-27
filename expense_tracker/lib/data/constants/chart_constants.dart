import 'package:flutter/material.dart';

class ChartConstants {
  static BarChartConstants bar = BarChartConstants();
  static LineChartConstants line = LineChartConstants();
  static PieChartConstants pie = PieChartConstants();
  static CommonChartConstants common = CommonChartConstants();
}

class BarChartConstants {
  final double barWidth = 15;
  final double barWidthMonth = 13;
  final double barWidthSplit = 8;
  final double barWidthSplitMonth = 5;

  final Color color = CommonChartConstants.color;
  final Color colorExpense = CommonChartConstants.colorExpense;
  final Color colorIncome = CommonChartConstants.colorIncome;
  final Color colorReimbursement = CommonChartConstants.colorReimbursement;
}

class LineChartConstants {
  final double barWidth = 15;
  final double barWidthSplit = 8;

  final Color color = Colors.blue.shade400;
  final Color colorExpense = Colors.red.shade400;
  final Color colorIncome = Colors.green.shade400;
  final Color colorReimbursement = Colors.white;

  final Color colorAccent = CommonChartConstants.colorAccent;
  final Color colorExpenseAccent = CommonChartConstants.colorExpenseAccent;
  final Color colorIncomeAccent = CommonChartConstants.colorIncomeAccent;
  final Color colorReimbursementAccent =
      CommonChartConstants.colorReimbursementAccent;
}

class PieChartConstants {
  final Color color = CommonChartConstants.color;
  final Color colorExpense = CommonChartConstants.colorExpense;
  final Color colorIncome = CommonChartConstants.colorIncome;
  final Color colorReimbursement = CommonChartConstants.colorReimbursement;
}

class CommonChartConstants {
  static Color color = Colors.blue.shade400;
  static Color colorExpense = Colors.red.shade400;
  static Color colorIncome = Colors.green.shade400;
  static Color colorReimbursement = Colors.white;

  static Color colorAccent = Colors.indigoAccent;
  static Color colorExpenseAccent = Colors.redAccent;
  static Color colorIncomeAccent = Colors.greenAccent;
  static Color colorReimbursementAccent = Colors.indigoAccent;
}
