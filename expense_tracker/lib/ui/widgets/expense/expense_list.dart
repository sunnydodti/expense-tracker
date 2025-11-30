import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/constants/ui_constants.dart';
import '../../../providers/expense_provider.dart';
import '../../screens/widget_constants.dart';
import '../empty_list_widget.dart';
import '../expense_swipe_info_widget.dart';
import 'dismissible_expense_tile.dart';

class ExpenseList extends StatefulWidget {
  const ExpenseList({super.key});

  @override
  State<ExpenseList> createState() => _ExpenseListState();
}

class _ExpenseListState extends State<ExpenseList> {
  late Future<void> _expensesFuture;

  @override
  void initState() {
    super.initState();
    _expensesFuture =
        Provider.of<ExpenseProvider>(context, listen: false).refreshExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _expensesFuture,
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
              if (expenseCount < 4 && expenseCount > 0) _expenseSwipeInfoWidget,
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
          itemCount: expenseCount,
          itemBuilder: (context, index) {
            return DismissibleExpenseTile(
              expense: expenseProvider.expenses[index],
              expenseProvider: expenseProvider,
              index: index,
            );
          },
        ),
      ),
    );
  }

  static const _expenseSwipeInfoWidget = Positioned(
    bottom: 0,
    left: 0,
    right: 0,
    child: ExpenseSwipeInfoWidget(),
  );
}
