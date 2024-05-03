import 'package:flutter/material.dart';

import '../../../../models/expense_item.dart';

class ExpenseItemTile extends StatelessWidget {
  final ExpenseItemFormModel expenseItem;
  final String currency;
  final VoidCallback onDelete;

  const ExpenseItemTile({
    Key? key,
    required this.expenseItem,
    required this.onDelete,
    required this.currency,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.green.shade300,
      padding: const EdgeInsets.only(bottom: 5),
      child: ListTile(
        visualDensity: const VisualDensity(vertical: -4),
        dense: true,
        title: Text(
          expenseItem.name,
          textScaleFactor: .9,
        ),
        subtitle: _buildExpenseItemDetails(),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red.shade300),
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
