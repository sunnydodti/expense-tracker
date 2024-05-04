import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/expense.dart';
import '../../../providers/expense_provider.dart';
import 'expense_widgets.dart';

class ExpenseTile extends StatefulWidget {
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
  State<ExpenseTile> createState() => _ExpenseTileState();
}

class _ExpenseTileState extends State<ExpenseTile> {
  bool showPopup = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (details) =>
          expenseProvider.showExpensePopup(widget.expense),
      onLongPressEnd: (details) => expenseProvider.hideExpensePopup(),
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
        ),
        margin: const EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
        child: _buildExpenseTile(),
      ),
    );
  }

  Padding _buildExpenseTile() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Column(
        children: [
          Row(
            children: [
              ExpenseWidgets.tile.titleWidget(widget.expense),
              ExpenseWidgets.tile.categoryWidget(widget.expense),
              ExpenseWidgets.tile.getExpenseDate(widget.expense),
            ],
          ),
          const SizedBox(height: 5.0),
          Row(
            children: [
              ExpenseWidgets.tile.tagsWidget(widget.expense),
            ],
          ),
          const SizedBox(height: 5.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ExpenseWidgets.tile.noteWidget(widget.expense),
              ExpenseWidgets.tile.amountWidget(widget.expense),
            ],
          ),
        ],
      ),
    );
  }

  ExpenseProvider get expenseProvider =>
      Provider.of<ExpenseProvider>(context, listen: false);
}
