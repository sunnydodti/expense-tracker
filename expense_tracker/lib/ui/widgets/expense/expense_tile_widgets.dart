import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../data/constants/form_constants.dart';
import '../../../models/enums/transaction_type.dart';
import '../../../models/expense.dart';

class ExpenseTileWidgets {
  double getTextScaleFactor() => .9;

  Expanded getExpenseDate(Expense expense) {
    return Expanded(
      child: Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: EdgeInsets.zero,
          child: Text(
            DateFormat('dd-MM-yy').format(expense.date),
            textScaleFactor: getTextScaleFactor(),
            // style: const TextStyle(fontSize: 16.0),
          ),
        ),
      ),
    );
  }

  Expanded titleWidget(Expense expense) {
    return Expanded(
      child: Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: EdgeInsets.zero,
          child: Text(
            expense.title,
            textScaleFactor: getTextScaleFactor(),
            // style: const TextStyle(fontSize: 16.0),
          ),
        ),
      ),
    );
  }

  Expanded categoryWidget(Expense expense) {
    return Expanded(
      child: Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(right: 0.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Text(
                '${expense.category} ',
                textScaleFactor: getTextScaleFactor(),
              ),
              const Icon(
                Icons.category_outlined,
                size: 16.0,
              )
            ]),
          )),
    );
  }

  Container tagsWidget(Expense expense) {
    Text tags;
    expense.note == null
        ? tags = const Text("")
        : tags = Text(
            expense.tags!,
            style: const TextStyle(fontSize: 10.0),
          );
    return Container(child: tags);
  }

  Expanded noteWidget(Expense expense) {
    Text note;
    (expense.note == null || expense.note == "")
        ? note = const Text(
            "Add Notes",
            style: TextStyle(
                // fontSize: 13.5,
                color: Colors.grey),
          )
        : note = Text(
            '${expense.note}',
            textScaleFactor: 0.9,
            // style: const TextStyle(fontSize: 13.5),
          );
    return Expanded(
      flex: 2,
      child: Align(
          alignment: Alignment.topLeft,
          child: FractionallySizedBox(
            widthFactor: 1,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1.0),
                borderRadius: BorderRadius.circular(5.0),
              ),
              padding: const EdgeInsets.all(5.0),
              child: Padding(
                padding: EdgeInsets.zero,
                child: note,
              ),
            ),
          )),
    );
  }

  Expanded amountWidget(Expense expense) {
    return Expanded(
      flex: 1,
      child: Align(
        alignment: Alignment.centerLeft,
        child: _getAmount(expense),
      ),
    );
  }

  Padding _getAmount(Expense expense) {
    String transactionType = expense.transactionType;
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Text(
        _getAmountText(expense),
        textScaleFactor: 1.1,
        style: TextStyle(
          // fontSize: 16.0,
          color: _getAmountColor(transactionType),
        ),
      ),
    );
  }

  String _getAmountText(Expense expense) {
    String amountText = "${FormConstants.expense.currencies[expense.currency]} "
        "${expense.amount.round()}";
    amountText = (expense.transactionType == TransactionType.expense.name)
        ? "- $amountText"
        : "+ $amountText";
    return amountText;
  }

  Color _getAmountColor(String transactionType) {
    if (transactionType == TransactionType.expense.name) {
      return Colors.red.shade300;
    }
    if (transactionType == TransactionType.income.name) {
      return Colors.green.shade300;
    }
    return Colors.white;
  }
}
