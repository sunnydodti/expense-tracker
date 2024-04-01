import 'package:expense_tracker/data/database/database_helper.dart';
import 'package:expense_tracker/models/expense_new.dart';
import 'package:expense_tracker/ui/notifications/snackbar_service.dart';
import 'package:expense_tracker/ui/pages/expense_page.dart';
import 'package:expense_tracker/ui/widgets/expense_tile_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../forms/form_modes.dart';
import '../../providers/expense_provider.dart';

class ExpenseListDynamic extends StatelessWidget {
  const ExpenseListDynamic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseProvider>(
        builder: (context, expenseProvider, child) => Scaffold(
            body: RefreshIndicator(
              onRefresh: () => expenseProvider.refreshExpenses(), // to be moved to provider
              color: Colors.blue.shade500,
              child: ListView.builder(
                itemCount: expenseProvider.expenses.isEmpty
                    ? 1
                    : expenseProvider.expenses.length,
                itemBuilder: (context, index) {
                  return expenseProvider.expenses.isEmpty
                      ? getNoExpensesView()
                      : getDismissibleExpenseTile(context, index, expenseProvider.expenses[index], expenseProvider);
                },
              ),
            ),
        )
    );
  }

  Padding getNoExpensesView() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 100),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Text(
              'Click',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(width: 8),
            Icon(
              Icons.add,
              color: Colors.grey,
            ),
            SizedBox(width: 8),
            Text(
              'icon to add an Expense',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Dismissible getDismissibleExpenseTile(BuildContext context, int index, Expense expense, ExpenseProvider expenseProvider) {
    return Dismissible(
    key: Key(expense.id.toString()),
      background: Container(
        color: Colors.red.shade400,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20.0),
        margin: const EdgeInsets.only(top: 0.0, bottom: 10.0),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      secondaryBackground: Container(
        color: Colors.blue.shade400,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        margin: const EdgeInsets.only(top: 0.0, bottom: 10.0),
        child: const Icon(Icons.edit, color: Colors.white),
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
        // Swipe left to delete
        _deleteExpense(context, index, expense, expenseProvider);
        } else {
          // Swipe right to edit
          _editItem(context, index, expense, expenseProvider);
        }
      },
      child: getExpenseListTile(context, expense, expenseProvider));
  }

  Container getExpenseListTile(BuildContext context, Expense expense, ExpenseProvider expenseProvider) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
      ),
      margin: const EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
      child: InkWell(
          onTap: () => _editExpense(context, expense, expenseProvider),
          child: ExpenseTileWidgets.expenseTile(expense)
      ),
    );
  }

  void _deleteExpense(BuildContext context, int index, Expense expense, ExpenseProvider expenseProvider) async {
    int expenseLength = expenseProvider.expenses.length;
    debugPrint("$expenseLength");

    expenseProvider.deleteExpense(expense.id!);

    bool undoDelete = await SnackBarService.showUndoSnackBarWithContext(context, "Deleting - ${expense.title}");
    debugPrint("undoDelete $undoDelete");

    if (undoDelete){
      if (index+1 == expenseLength) {
          debugPrint("adding at end $index");
          expenseProvider.addExpense(expense);
        } else {
          debugPrint("adding at $index");
          expenseProvider.insertExpense(index, expense);
        }
      SnackBarService.showSuccessSnackBarWithContext(context, "Restored - ${expense.title}");
    } else {
      int id = await _deleteExpenseFromDatabase(expense);
      if (id == 0) {
        if (index+1 == expenseLength) {
          debugPrint("adding at end $index");
          expenseProvider.addExpense(expense);
        } else {
          debugPrint("adding at $index");
          expenseProvider.insertExpense(index, expense);
        }
        SnackBarService.showErrorSnackBarWithContext(context, "Delete Failed");
      }
    }
  }

  void _editItem(BuildContext context, int index, Expense expense, ExpenseProvider expenseProvider) async {
    int expenseLength = expenseProvider.expenses.length;
    debugPrint("$expense");

    expenseProvider.deleteExpense(expense.id!);

    bool result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExpensePage(formMode: FormMode.edit, expense: expense),
      ),
    );
    if (index+1 == expenseLength) {
      debugPrint("adding at end $index");
      expenseProvider.addExpense(expense);
    } else {
      debugPrint("adding at $index");
      expenseProvider.insertExpense(index, expense);
    }
    if (result) expenseProvider.refreshExpenses();
  }

  void _editExpense(BuildContext context, Expense expense, ExpenseProvider expenseProvider) async {
    debugPrint("editing");
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExpensePage(formMode: FormMode.edit, expense: expense),
      ),
    );
    if (result) expenseProvider.refreshExpenses();
  }

  Future<int> _deleteExpenseFromDatabase(Expense expense) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    return await databaseHelper.deleteExpense(expense.id!);
  }


}