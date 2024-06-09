import 'package:flutter/material.dart';

import '../data/constants/form_constants.dart';
import '../models/enums/transaction_type.dart';
import '../models/expense.dart';

String getExpenseAmountText(Expense expense) {
  String amountText = "${FormConstants.expense.currencies[expense.currency]} "
      "${expense.amount.round()}";
  amountText = (expense.transactionType == TransactionType.expense.name)
      ? "- $amountText"
      : "+ $amountText";
  return amountText;
}

String getAmountText(double amount, String transactionType, String currency,
    {bool includeAmount = true}) {
  String amountText = "${FormConstants.expense.currencies[currency]}";
  if (includeAmount) amountText += " ${amount.round()}";
  amountText = (transactionType == TransactionType.expense.name)
      ? "- $amountText"
      : "+ $amountText";
  return amountText;
}

String getExpenseAmountWithSign(Expense expense) {
  String amountText = ""
      "${expense.amount.round()}";
  amountText = (expense.transactionType == TransactionType.expense.name)
      ? "- $amountText"
      : "+ $amountText";
  return amountText;
}

Color getAmountColor(String transactionType, context) {
  bool isBrightnessDark = Theme.of(context).brightness == Brightness.dark;
  int shade = isBrightnessDark ? 300 : 800;
  if (transactionType == TransactionType.expense.name) {
    return Colors.red[shade]!;
  }
  if (transactionType == TransactionType.income.name) {
    return Colors.green[shade]!;
  }
  return isBrightnessDark ? Colors.white : Colors.black;
}
