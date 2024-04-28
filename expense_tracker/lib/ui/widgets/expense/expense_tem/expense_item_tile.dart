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
      padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10),
      margin: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 5),
      child: ListTile(
        dense: true,
        title: Text(
          expenseItem.name,
          textScaleFactor: .9,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red.shade300),
                onPressed: onDelete,
              ),
          ],
        ),
      ),
    );
  }
}
