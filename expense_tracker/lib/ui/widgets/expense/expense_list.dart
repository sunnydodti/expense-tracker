import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/constants/ui_constants.dart';
import '../../../providers/expense_provider.dart';
import '../../screens/widget_constants.dart';
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
          return wcSpinnerDefault;
        }
        if (snapshot.hasError) {
          return wcSnapshotErrorText(snapshot.error);
        }
        return _buildExpenseListConsumer();
      },
    );
  }

  Consumer<ExpenseProvider> _buildExpenseListConsumer() {
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
                      : _buildExpenesList(expenseCount, expenseProvider),
                ],
              ),
              if (expenseCount < 4 && expenseCount > 0)
                _buildExpenseSwipeInfoWidget(),
            ],
          ),
        );
      },
    );
  }

  Expanded _buildExpenesList(
      int expenseCount, ExpenseProvider expenseProvider) {
    return Expanded(
      child: Scrollbar(
        interactive: true,
        thickness: uiScrollbarThickness,
        radius: const Radius.circular(uiScrollbarRadius),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: expenseCount,
          itemBuilder: (context, index) {
            return DismissibleExpenseTile(
                expense: expenseProvider.expenses[index],
                expenseProvider: expenseProvider,
                index: index);
          },
        ),
      ),
    );
  }

  Positioned _buildExpenseSwipeInfoWidget() {
    return const Positioned(
        bottom: 0, left: 0, right: 0, child: ExpenseSwipeInfoWidget());
  }
}
