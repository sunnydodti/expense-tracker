import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/expense_item.dart';
import '../../../../providers/expense_items_provider.dart';
import 'expense_item_tile.dart';

class ExpenseItemsList extends StatelessWidget {
  final String currency;
  const ExpenseItemsList({Key? key, required this.currency}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Consumer<ExpenseItemsProvider>(
        builder: (context, expenseItemsProvider, child) => GestureDetector(
          onLongPress: () => showExpandedExpenseItemList(expenseItemsProvider),
          child: ExpansionTile(
            initiallyExpanded: expenseItemsProvider.expenseItems.isNotEmpty,
            title: Text(
                "Expense Items (${expenseItemsProvider.expenseItems.length})"),
            children: [
              SizedBox(
                height: 120,
                child: ListView.builder(
                  itemCount: expenseItemsProvider.expenseItems.length,
                  itemBuilder: (context, index) {
                    return ExpenseItemTile(
                      expenseItem: expenseItemsProvider.expenseItems[index],
                      currency: currency,
                      onDelete: () => deleteExpenseItem(expenseItemsProvider,
                          expenseItemsProvider.expenseItems[index]),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void showExpandedExpenseItemList(ExpenseItemsProvider expenseItemsProvider) => print("longpress");

  deleteExpenseItem(ExpenseItemsProvider expenseItemsProvider,
      ExpenseItemFormModel expenseItem) {
    expenseItemsProvider.deleteExpenseItem(expenseItem.uuid);
  }
}
