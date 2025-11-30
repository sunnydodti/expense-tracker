import 'package:flutter/material.dart';

import '../../../../data/constants/ui_constants.dart';
import '../../../../models/expense_item.dart';

class ExpenseItemTile extends StatelessWidget {
  final ExpenseItemFormModel expenseItem;
  final String currency;
  final VoidCallback onDelete;

  const ExpenseItemTile({
    super.key,
    required this.expenseItem,
    required this.onDelete,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.green.shade300,
      padding: const EdgeInsets.only(bottom: uiPaddingHalf),
      child: ListTile(
        visualDensity: const VisualDensity(vertical: -4),
        dense: true,
        title: Text(
          expenseItem.name,
          textScaler: const TextScaler.linear(uiTextScaler),
        ),
        subtitle: _buildExpenseItemDetails(),
        trailing: IconButton(
          icon: Icon(
            Icons.delete,
            color: Colors.red.shade300,
            size: uiIconSize,
          ),
          onPressed: onDelete,
        ),
      ),
    );
  }

  Padding _buildExpenseItemDetails() {
    double total = expenseItem.amount * expenseItem.quantity;
    return Padding(
      padding: const EdgeInsets.only(left: 100),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("${expenseItem.amount.round()}"),
          const Text("x"),
          Text("${expenseItem.quantity}"),
          const Text("="),
          Text("$currency ${total.round()}"),
        ],
      ),
    );
  }
}
