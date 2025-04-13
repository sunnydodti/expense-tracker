import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/helpers/color_helper.dart';
import '../../../data/helpers/navigation_helper.dart';
import '../../../models/enums/form_modes.dart';
import '../../../providers/expense_provider.dart';
import '../../screens/expense_screen.dart';

class AddExpenseFAB extends StatelessWidget {
  const AddExpenseFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      backgroundColor: ColorHelper.getIconColor(Theme.of(context)),
      tooltip: 'Add New Expense',
      onPressed: () => _addExpense(context),
      child: const Icon(Icons.add, size: 20),
    );
  }

  void _addExpense(BuildContext context) async {
    final bool? result =
        await NavigationHelper.navigateToScreenWithResult<bool>(
      context,
      const ExpensePage(formMode: FormMode.add),
    );

    if (result == true) _refreshExpensesHome(context);
  }

  Future<void> _refreshExpensesHome(BuildContext context) async {
    final expenseProvider =
        Provider.of<ExpenseProvider>(context, listen: false);
    expenseProvider.refreshExpenses();
  }
}
