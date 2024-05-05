import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../data/helpers/navigation_helper.dart';
import '../../../../models/expense_item.dart';
import '../../../../providers/expense_items_provider.dart';
import '../../../screens/expense_items_screen.dart';
import 'expense_item_tile.dart';

class ExpenseItemsList extends StatelessWidget {
  final String currency;
  final String expenseTitle;

  const ExpenseItemsList(
      {Key? key, required this.currency, this.expenseTitle = ""})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Consumer<ExpenseItemsProvider>(
        builder: (context, expenseItemsProvider, child) => GestureDetector(
          onLongPress: () =>
              showExpandedExpenseItemList(context, expenseItemsProvider),
          child: ExpansionTile(
            leading: expenseItemsProvider.expenseItems.isEmpty
                ? null
                : IconButton(
                    onPressed: () => showExpandedExpenseItemList(
                        context, expenseItemsProvider),
                    icon: const Icon(Icons.fullscreen_outlined),
                  ),
            initiallyExpanded: expenseItemsProvider.expenseItems.isNotEmpty,
            title: Text(
                "Expense Items (${expenseItemsProvider.expenseItems.length})"),
            children: [
              SizedBox(
                height: getExpenseItemsListHeight(expenseItemsProvider),
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

  double getExpenseItemsListHeight(ExpenseItemsProvider expenseItemsProvider) {
    if (expenseItemsProvider.expenseItems.length > 2) return 120;
    return expenseItemsProvider.expenseItems.length * 50;
  }

  void showExpandedExpenseItemList(
      BuildContext context, ExpenseItemsProvider expenseItemsProvider) {
    NavigationHelper.navigateToRoute(context,
        ExpenseItemsScreen(currency: currency, expenseTitle: expenseTitle));
  }

  deleteExpenseItem(ExpenseItemsProvider expenseItemsProvider,
      ExpenseItemFormModel expenseItem) {
    expenseItemsProvider.deleteExpenseItem(expenseItem.uuid);
  }
}
