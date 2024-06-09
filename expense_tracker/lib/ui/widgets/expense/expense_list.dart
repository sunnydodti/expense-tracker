import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/expense_provider.dart';
import '../empty_list_widget.dart';
import '../expense_swipe_info_widget.dart';
import 'dismissible_expense_tile.dart';

class ExpenseList extends StatelessWidget {
  const ExpenseList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<void> refreshExpensesHome() async {
      Provider.of<ExpenseProvider>(context, listen: false).refreshExpenses();
    }

    return FutureBuilder<void>(
      future: refreshExpensesHome(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Consumer<ExpenseProvider>(
            builder: (context, expenseProvider, child) {
              final expenseCount = expenseProvider.expenses.length;
              return RefreshIndicator(
                onRefresh: () => expenseProvider.refreshExpenses(),
                color: Colors.blue.shade500,
                child: Stack(
                  children: [
                    Column(
                      children: [
                        expenseProvider.expenses.isEmpty
                            ? const EmptyListWidget(listName: 'Expense')
                            : Expanded(
                                child: Scrollbar(
                                  interactive: true,
                                  thickness: 8,
                                  radius: const Radius.circular(5),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: expenseCount,
                                    itemBuilder: (context, index) {
                                      return DismissibleExpenseTile(
                                          expense:
                                              expenseProvider.expenses[index],
                                          expenseProvider: expenseProvider,
                                          index: index);
                                    },
                                  ),
                                ),
                              ),
                      ],
                    ),
                    if (expenseCount < 4 && expenseCount > 0)
                      const Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: ExpenseSwipeInfoWidget()),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }
}
