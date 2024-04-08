import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/database/database_helper.dart';
import '../../data/database/expense_helper.dart';
import '../../models/enums/form_modes.dart';
import '../../models/expense.dart';
import '../../providers/expense_provider.dart';
import '../notifications/snackbar_service.dart';
import '../screens/expense_screen.dart';
import 'expense_tile_widgets.dart';


class ExpenseListDynamic extends StatelessWidget {
  const ExpenseListDynamic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseProvider>(
        builder: (context, expenseProvider, child) => Scaffold(
              body: RefreshIndicator(
                  onRefresh: () => expenseProvider.refreshExpenses(),
                  color: Colors.blue.shade500,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      getSummaryTile(expenseProvider),
                      Expanded(
                        child: ListView.builder(
                          itemCount: expenseProvider.expenses.isEmpty
                              ? 1
                              : expenseProvider.expenses.length,
                          itemBuilder: (context, index) {
                            return expenseProvider.expenses.isEmpty
                                ? getNoExpensesView()
                                : getDismissibleExpenseTile(
                                    context,
                                    index,
                                    expenseProvider.expenses[index],
                                    expenseProvider);
                          },
                        ),
                      )
                    ],
                  )),
            ));
  }

  Container getSummaryTile(ExpenseProvider expenseProvider) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
      ),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        children: [
          Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade700,
              ),
              margin: const EdgeInsets.only(
                  top: 10, bottom: 5, left: 10, right: 10),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              width: double.infinity,
              child: Column(
                children: [
                  getSummaryText("Total Balance"),
                  const SizedBox(height: 5),
                  getSummaryAmount(expenseProvider.getTotalBalance()),
                ],
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade700,
                    ),
                    margin: const EdgeInsets.only(
                        top: 5, bottom: 10, left: 10, right: 5),
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    child: Column(
                      children: [
                        getSummaryText("Total Income"),
                        const SizedBox(height: 5),
                        getSummaryAmount(expenseProvider.getTotalIncome()),
                      ],
                    )),
              ),
              Expanded(
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade700,
                    ),
                    margin: const EdgeInsets.only(
                        top: 5, bottom: 10, left: 5, right: 10),
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    child: Column(
                      children: [
                        getSummaryText("Total Expense"),
                        const SizedBox(height: 5),
                        getSummaryAmount(
                            expenseProvider.getTotalExpenses() * -1),
                      ],
                    )),
              ),
            ],
          )
        ],
      ),
    );
  }

  Text getSummaryAmount(double amount) {
    String sign = amount > 0 ? '+' : (amount < 0 ? '-' : '');
    return Text(
      '$sign ₹${amount.abs().round()}',
      textScaleFactor: 1.1,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        // fontSize: 12,
        color: amount > 0 ? Colors.green.shade400 : (amount < 0 ? Colors.red.shade400 : Colors.white70),
      ),
    );
  }

  Text getSummaryText(String summaryText) {
    return Text(
      summaryText,
      textAlign: TextAlign.center,
      textScaleFactor: 1.1,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        // fontSize: 12,
        color: Colors.white70,
      ),
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

  Dismissible getDismissibleExpenseTile(BuildContext context, int index,
      Expense expense, ExpenseProvider expenseProvider) {
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

  Container getExpenseListTile(
      BuildContext context, Expense expense, ExpenseProvider expenseProvider) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        // borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
      child: InkWell(
          onTap: () => _editExpense(context, expense, expenseProvider),
          child: ExpenseTileWidgets.expenseTile(expense)),
    );
  }

  void _deleteExpense(BuildContext context, int index, Expense expense,
      ExpenseProvider expenseProvider) async {
    int expenseLength = expenseProvider.expenses.length;
    debugPrint("$expenseLength");

    expenseProvider.deleteExpense(expense.id!);

    SnackBarService.showUndoSnackBarWithContextAndCallback(
      context,
      "Deleting - ${expense.title}",
          () => undoExpenseDeletion(
              index, expenseLength, expenseProvider, expense, context),
      onNotUndo: () => completeExpenseDeletion(
          expense, index, expenseLength, expenseProvider, context));
  }

  completeExpenseDeletion(Expense expense, int index, int expenseLength,
      ExpenseProvider expenseProvider, BuildContext context) async {
    debugPrint("Expense deleted");
    int id = await _deleteExpenseFromDatabase(expense);
    if (id == 0) {
      if (index + 1 == expenseLength) {
        debugPrint("adding at end $index");
        expenseProvider.addExpense(expense);
      } else {
        debugPrint("adding at $index");
        expenseProvider.insertExpense(index, expense);
      }
      SnackBarService.showErrorSnackBarWithContext(context, "Delete Failed");
    }
  }

  undoExpenseDeletion(int index, int expenseLength,
      ExpenseProvider expenseProvider, Expense expense, BuildContext context) {
    if (index + 1 == expenseLength) {
      debugPrint("adding at end $index");
      expenseProvider.addExpense(expense);
    } else {
      debugPrint("adding at $index");
      expenseProvider.insertExpense(index, expense);
    }
    SnackBarService.showSuccessSnackBarWithContext(
        context, "Restored - ${expense.title}");
  }


  void _editItem(BuildContext context, int index, Expense expense,
      ExpenseProvider expenseProvider) async {
    int expenseLength = expenseProvider.expenses.length;
    debugPrint("$expense");

    expenseProvider.deleteExpense(expense.id!);

    bool result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ExpensePage(formMode: FormMode.edit, expense: expense),
      ),
    );
    if (index + 1 == expenseLength) {
      debugPrint("adding at end $index");
      expenseProvider.addExpense(expense);
    } else {
      debugPrint("adding at $index");
      expenseProvider.insertExpense(index, expense);
    }
    if (result) expenseProvider.refreshExpenses();
  }

  void _editExpense(BuildContext context, Expense expense,
      ExpenseProvider expenseProvider) async {
    debugPrint("editing");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ExpensePage(formMode: FormMode.edit, expense: expense),
      ),
    ).then((result) => {
      if (result) _refreshExpenses(context)
    });
  }

  Future<int> _deleteExpenseFromDatabase(Expense expense) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    ExpenseHelper expenseHelper = await databaseHelper.expenseHelper;
    return await expenseHelper.deleteExpense(expense.id!);
  }

  _refreshExpenses(BuildContext context) {
    final expenseProvider =
        Provider.of<ExpenseProvider>(context, listen: false);
    expenseProvider.refreshExpenses();
  }
}
