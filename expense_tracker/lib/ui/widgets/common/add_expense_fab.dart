import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/enums/form_modes.dart';
import '../../../providers/expense_provider.dart';
import '../../screens/expense_screen.dart';

class AddExpenseFAB extends StatelessWidget {
  const AddExpenseFAB({super.key});

  @override
  Widget build(BuildContext context) {
    double lerpT =
        Theme.of(context).colorScheme.brightness == Brightness.light ? .3 : 1;

    Color? color =
        Color.lerp(Theme.of(context).colorScheme.primary, Colors.white, lerpT);
    return FloatingActionButton.small(
      backgroundColor: color,
      tooltip: 'Add New Expense',
      onPressed: () => _addExpense(context),
      child: const Icon(Icons.add, size: 20),
    );
  }

  void _addExpense(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ExpensePage(formMode: FormMode.add),
      ),
    ).then((result) {
      if (result) _refreshExpensesHome(context);
    });
  }

  Future<void> _refreshExpensesHome(BuildContext context) async {
    final expenseProvider =
        Provider.of<ExpenseProvider>(context, listen: false);
    expenseProvider.refreshExpenses();
  }
}
