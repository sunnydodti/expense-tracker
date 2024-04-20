import 'package:flutter/material.dart';

import '../../../models/expense.dart';
import '../../../providers/expense_provider.dart';
import 'expense_tile_widgets.dart';

class ExpenseTile extends StatelessWidget {
  final Expense expense;
  final ExpenseProvider expenseProvider;
  final VoidCallback onTap;

  const ExpenseTile({
    Key? key,
    required this.expense,
    required this.expenseProvider,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
      ),
      margin: const EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Column(
            children: [
              Row(
                children: [
                  ExpenseTileWidgets.titleWidget(expense),
                  ExpenseTileWidgets.categoryWidget(expense),
                  ExpenseTileWidgets.getExpenseDate(expense),
                ],
              ),
              const SizedBox(height: 5.0),
              Row(
                children: [
                  ExpenseTileWidgets.tagsWidget(expense),
                ],
              ),
              const SizedBox(height: 5.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ExpenseTileWidgets.noteWidget(expense),
                  ExpenseTileWidgets.amountWidget(expense),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
