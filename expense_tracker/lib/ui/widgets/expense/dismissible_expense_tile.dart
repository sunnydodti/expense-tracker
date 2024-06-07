import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../../models/enums/form_modes.dart';
import '../../../models/expense.dart';
import '../../../providers/expense_provider.dart';
import '../../notifications/snackbar_service.dart';
import '../../screens/expense_screen.dart';
import 'expense_tile.dart';

class DismissibleExpenseTile extends StatelessWidget {
  final Expense expense;
  final ExpenseProvider expenseProvider;
  final int index;

  const DismissibleExpenseTile({
    Key? key,
    required this.expense,
    required this.expenseProvider,
    required this.index,
  }) : super(key: key);

  static final Logger _logger =
      Logger(printer: SimplePrinter(), level: Level.info);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(expense.id.toString()),
      background: Card(
        color: Colors.red.shade400,
        margin: const EdgeInsets.only(top: 0.0, bottom: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: Icon(Icons.delete, color: Colors.white),
            ),
          ],
        ),
      ),
      secondaryBackground: Card(
        color: Colors.blue.shade400,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: Icon(Icons.edit, color: Colors.white),
            ),
          ],
        ),
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          // Swipe left to delete
          _deleteExpenseFromList(context, index, expense, expenseProvider);
        } else {
          // Swipe right to edit
          _editItem(context, index, expense, expenseProvider);
        }
      },
      child: ExpenseTile(
        expense: expense,
        editCallBack: () => _editExpense(context, expense, expenseProvider),
        deleteCallBack: () =>
            _deleteExpenseFromDatabase(expense, expenseProvider, notify: true),
      ),
    );
  }

  void _deleteExpenseFromList(BuildContext context, int index, Expense expense,
      ExpenseProvider expenseProvider) async {
    int expenseLength = expenseProvider.expenses.length;

    expenseProvider.deleteExpense(expense.id);

    SnackBarService.showUndoSnackBarWithContextAndCallback(
        context,
        "Deleting - ${expense.title}",
        () => undoExpenseDeletion(
            index, expenseLength, expenseProvider, expense, context),
        onNotUndo: () => completeExpenseDeletion(
            expense, index, expenseLength, expenseProvider, context));
  }

  undoExpenseDeletion(int index, int expenseLength,
      ExpenseProvider expenseProvider, Expense expense, BuildContext context) {
    if (index + 1 == expenseLength) {
      _logger.i("adding at end $index");
      expenseProvider.addExpense(expense);
    } else {
      _logger.i("adding at $index");
      expenseProvider.insertExpense(index, expense);
    }
    SnackBarService.showSuccessSnackBarWithContext(
        context, "Restored - ${expense.title}");
  }

  completeExpenseDeletion(Expense expense, int index, int expenseLength,
      ExpenseProvider expenseProvider, BuildContext context) async {
    _logger.i("Expense deleted");
    _deleteExpenseFromDatabase(expense, expenseProvider).then((value) {
      if (value == 0) {
        if (index + 1 == expenseLength) {
          _logger.i("adding at end $index");
          expenseProvider.addExpense(expense);
        } else {
          _logger.i("adding at $index");
          expenseProvider.insertExpense(index, expense);
        }
        SnackBarService.showErrorSnackBarWithContext(context, "Delete Failed");
      }
    });
  }

  Future<int> _deleteExpenseFromDatabase(
      Expense expense, ExpenseProvider expenseProvider,
      {bool notify = false}) {
    return expenseProvider.deleteExpenseFromDatabase(expense.id,
        notify: notify);
  }

  void _editItem(BuildContext context, int index, Expense expense,
      ExpenseProvider expenseProvider) async {
    int expenseLength = expenseProvider.expenses.length;
    _logger.i("$expense");

    expenseProvider.deleteExpense(expense.id);

    bool result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ExpensePage(formMode: FormMode.edit, expense: expense),
      ),
    );
    if (index + 1 == expenseLength) {
      _logger.i("adding at end $index");
      expenseProvider.addExpense(expense);
    } else {
      _logger.i("adding at $index");
      expenseProvider.insertExpense(index, expense);
    }
    if (result) expenseProvider.refreshExpenses();
  }

  void _editExpense(BuildContext context, Expense expense,
      ExpenseProvider expenseProvider) async {
    _logger.i("editing");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ExpensePage(formMode: FormMode.edit, expense: expense),
      ),
    ).then((result) => {if (result) _refreshExpenses(context)});
  }

  _refreshExpenses(BuildContext context) {
    final expenseProvider =
        Provider.of<ExpenseProvider>(context, listen: false);
    expenseProvider.refreshExpenses();
  }
}
