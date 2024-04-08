import 'package:expense_tracker/models/enums/form_modes.dart';
import 'package:expense_tracker/ui/drawer/home_drawer.dart';
import 'package:expense_tracker/ui/widgets/expense_list_dynamic.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/expense_provider.dart';
import '../../service/expense_service.dart';
import 'expense_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final String title = "Expense Tracker";
  static final Future<ExpenseService> _expenseService = ExpenseService.create();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _refreshExpensesHome(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Or any loading indicator
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          // Once the future is completed, build the UI
          return MaterialApp(
            theme: ThemeData(colorScheme: const ColorScheme.dark()),
            home: Scaffold(
              drawer: const SafeArea(child: HomeDrawer()),
              appBar: AppBar(
                centerTitle: true,
                title: Text(title, textScaleFactor: 0.9),
                backgroundColor: Colors.black,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.add, size: 20),
                    tooltip: "add random expense",
                    onPressed: () => populateExpense(context),
                  ),
                  IconButton(
                    icon: const Icon(Icons.person, size: 20),
                    tooltip: "Profile",
                    onPressed: _handelProfile,
                  ),
                ],
              ),
              body: Column(
                children: const [Expanded(child: ExpenseListDynamic())],
              ),
              floatingActionButton: addExpenseButton(context),
            ),
          );
        }
      },
    );
  }

  void _handelProfile() => {};

  void populateExpense(BuildContext context) async {
    ExpenseService service = await _expenseService;
    service
        .populateExpense(count: 1)
        .then((value) => _refreshExpensesHome(context));
  }

  Padding addExpenseButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: FloatingActionButton.small(
        backgroundColor: Colors.grey.shade500,
        tooltip: 'Add New Expense',
        onPressed: () => _addExpense(context),
        child: const Icon(Icons.add, size: 20),
      ),
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
