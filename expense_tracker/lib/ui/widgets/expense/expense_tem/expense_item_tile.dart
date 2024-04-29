import 'package:flutter/material.dart';

import '../../../../models/expense_item.dart';

class ExpenseItemTile extends StatelessWidget {
  final ExpenseItemFormModel expenseItem;
  final VoidCallback onDelete;

  const ExpenseItemTile({
    Key? key,
    required this.expenseItem,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.green.shade300,
      padding: const EdgeInsets.only(bottom: 5),
      child: ListTile(
        visualDensity: VisualDensity(vertical: -4),
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

  Row _buildExpenseItemDetails() {
    double total = expenseItem.amount * expenseItem.quantity;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("${expenseItem.amount.round()}"),
        const Text("x"),
        Text("${expenseItem.quantity}"),
        const Text("="),
        Text("${total.round()}"),
      ],
    );
  }
}
