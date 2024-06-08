import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/expense.dart';
import '../../../utils/expense_utils.dart';

class ExpenseTileWidgets {
  double getTextScaleFactor() => .9;

  Expanded getExpenseDate(Expense expense) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.zero,
        child: Text(
          DateFormat('dd-MM-yy').format(expense.date),
          textScaleFactor: getTextScaleFactor(),
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.end,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Expanded titleWidget(Expense expense) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.zero,
        child: Text(
          expense.title,
          textScaleFactor: getTextScaleFactor(),
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Expanded categoryWidget(Expense expense) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Text(
                '${expense.category} ',
                textScaleFactor: getTextScaleFactor(),
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w500),
                textAlign: TextAlign.end,
              ),
            ),
          ),
          const Icon(
            Icons.category_outlined,
            size: 16.0,
          ),
        ],
      ),
    );
  }

  Container tagsWidget(Expense expense) {
    String text = expense.tags ?? "";
    Text tags = Text(
      text,
      textScaleFactor: .7,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(fontWeight: FontWeight.w500),
    );
    return Container(child: tags);
  }

  Expanded noteWidget(Expense expense) {
    bool isNote = !(expense.note == null || expense.note == "");
    String text = isNote ? expense.note! : "Add Notes";
    Color? color = isNote ? null : Colors.grey;
    Text note = Text(
      text,
      textScaleFactor: 0.8,
      // overflow: TextOverflow.ellipsis,
      style: TextStyle(color: color, fontWeight: FontWeight.w500),
    );
    return Expanded(
      flex: 2,
      child: note,
    );
  }

  Padding amountWidget(Expense expense) {
    return _getAmount(expense);
  }

  Padding _getAmount(Expense expense) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Text(
        getExpenseAmountText(expense),
        textScaleFactor: 1.1,
        textAlign: TextAlign.end,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: getAmountColor(expense.transactionType),
        ),
      ),
    );
  }
}
