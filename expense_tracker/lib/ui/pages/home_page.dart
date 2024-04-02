import 'package:expense_tracker/data/database/database_helper.dart';
import 'package:expense_tracker/forms/form_modes.dart';
import 'package:expense_tracker/ui/drawer/home_drawer.dart';
import 'package:expense_tracker/ui/widgets/ExpenseListDynamic.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/expense_provider.dart';
import 'expense_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  final String title = "Expense Tracker";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseHelper databaseHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseProvider>(
        builder: (context, expenseProvider, child) => MaterialApp(
      theme: ThemeData(
        colorScheme: const ColorScheme.dark()
      ),
      home: Scaffold(
        drawer: SafeArea(child: HomeDrawer()),
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.title),
          backgroundColor: Colors.black,
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: "add random expense",
              onPressed: () async  => {
                await databaseHelper.populateDatabase(),
                _refreshExpensesHome(expenseProvider)
              },
            ),
            IconButton(
              icon: const Icon(Icons.person),
              tooltip: "Profile",
              onPressed: () async  => {},
            ),
          ],
        ),
        body: Column(
          children: const [
            Expanded(child: ExpenseListDynamic())
          ],
        ),
        floatingActionButton: addExpenseButton(context, expenseProvider)
      ),
    ));
  }

  Padding addExpenseButton(BuildContext context, ExpenseProvider expenseProvider) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: FloatingActionButton(
        backgroundColor: Colors.grey.shade500,
        tooltip: 'Add New Expense',
        onPressed: () => _addExpense(context, expenseProvider),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addExpense(BuildContext context, ExpenseProvider expenseProvider) async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ExpensePage(formMode: FormMode.add),
      ),
    );
    if (result) expenseProvider.refreshExpenses();

  }
  Future<void> _refreshExpensesHome(ExpenseProvider expenseProvider) =>
      expenseProvider.refreshExpenses();
}
