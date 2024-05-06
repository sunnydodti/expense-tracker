import 'package:flutter/material.dart';

import '../data/constants/form_constants.dart';
import '../models/enums/transaction_type.dart';
import '../models/expense.dart';

String getAmountText(Expense expense) {
  String amountText = "${FormConstants.expense.currencies[expense.currency]} "
      "${expense.amount.round()}";
  amountText = (expense.transactionType == TransactionType.expense.name)
      ? "- $amountText"
      : "+ $amountText";
  return amountText;
}

Color getAmountColor(String transactionType) {
  if (transactionType == TransactionType.expense.name) {
    return Colors.red.shade300;
  }
  if (transactionType == TransactionType.income.name) {
    return Colors.green.shade300;
  }
  return Colors.white;
}
