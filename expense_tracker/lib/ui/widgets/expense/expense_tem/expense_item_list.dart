import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/expense_item.dart';
import '../../../../providers/expense_items_provider.dart';
import 'expense_item_tile.dart';

class ExpenseItemsList extends StatelessWidget {
  const ExpenseItemsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Consumer<ExpenseItemsProvider>(
        builder: (context, expenseItemsProvider, child) => ExpansionTile(
          initiallyExpanded: expenseItemsProvider.expenseItems.isNotEmpty,
          title: Text("Expense Items (${expenseItemsProvider.expenseItems.length})"),
          children: [
            SizedBox(
              height: 150,
              child: ListView.builder(
                itemCount: expenseItemsProvider.expenseItems.length,
                itemBuilder: (context, index) {
                  return ExpenseItemTile(
                    expenseItem: expenseItemsProvider.expenseItems[index],
                    onDelete: () => deleteExpenseItem(expenseItemsProvider, expenseItemsProvider.expenseItems[index]),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  deleteExpenseItem(ExpenseItemsProvider expenseItemsProvider, ExpenseItemFormModel expenseItem) {
    expenseItemsProvider.deleteExpenseItem(expenseItem.uuid);
  }
}
