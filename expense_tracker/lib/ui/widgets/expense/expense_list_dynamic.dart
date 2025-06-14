import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/expense_provider.dart';
import '../empty_list_widget.dart';
import '../expense_swipe_info_widget.dart';
import '../sort_n_filter/sort_filter_tile.dart';
import 'dismissible_expense_tile.dart';
import 'expense_popup.dart';
import 'expense_summary.dart';

class ExpenseListDynamic extends StatelessWidget {
  const ExpenseListDynamic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseProvider>(
      builder: (context, expenseProvider, child) {
        final expenseCount = expenseProvider.expenses.length;
        return RefreshIndicator(
          onRefresh: () => expenseProvider.refreshExpenses(),
          color: Colors.blue.shade500,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const ExpenseSummary(),
                  const SortFilterTile(),
                  expenseProvider.expenses.isEmpty
                      ? const EmptyListWidget(listName: 'Expense')
                      : Expanded(
                          child: Scrollbar(
                            interactive: true,
                            thickness: 8,
                            radius: const Radius.circular(5),
                            child: ListView.builder(
                              itemCount: expenseCount,
                              itemBuilder: (context, index) {
                                return DismissibleExpenseTile(
                                    expense: expenseProvider.expenses[index],
                                    expenseProvider: expenseProvider,
                                    index: index);
                              },
                            ),
                          ),
                        ),
                  if (expenseCount < 4 && expenseCount > 0)
                    const ExpenseSwipeInfoWidget(),
                ],
              ),
              if (expenseProvider.showPopup)
                ExpensePopup(expense: expenseProvider.popUpExpense!),
            ],
          ),
        );
      },
    );
  }
}
