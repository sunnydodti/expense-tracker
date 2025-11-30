import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../data/constants/ui_constants.dart';
import '../../../models/expense.dart';
import '../../../utils/expense_utils.dart';
import '../common/scaled_text.dart';

class ExpenseTileWidgets {
  Expanded getExpenseDate(Expense expense) {
    return Expanded(
      child: ScaledText(
        DateFormat('dd-MM-yy').format(expense.date),
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.end,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
    );
  }

  Expanded titleWidget(Expense expense) {
    return Expanded(
      child: ScaledText(
        expense.title,
        style: const TextStyle(fontWeight: FontWeight.w500),
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
              padding: const EdgeInsets.only(right: uiPadding),
              child: ScaledText(
                '${expense.category} ',
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w500),
                textAlign: TextAlign.end,
              ),
            ),
          ),
          const Icon(Icons.category_outlined, size: uiIconSize),
        ],
      ),
    );
  }

  Container tagsWidget(Expense expense) {
    String text = expense.tags ?? "";
    Text tags = Text(
      text,
      textScaler: const TextScaler.linear(uiTextScalerTags),
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
      textScaler: const TextScaler.linear(uiTextScalerNotes),
      style: TextStyle(color: color, fontWeight: FontWeight.w500),
    );
    return Expanded(flex: 2, child: note);
  }

  Padding amountWidget(Expense expense, BuildContext context) {
    return _getAmount(expense, context);
  }

  Padding _getAmount(Expense expense, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: uiPaddingX2),
      child: Text(
        getExpenseAmountText(expense),
        textScaler: const TextScaler.linear(uiTextScalerAmount),
        textAlign: TextAlign.end,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: getAmountColor(expense.transactionType, context),
        ),
      ),
    );
  }
}
