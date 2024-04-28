import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/helpers/debug_helper.dart';
import '../../data/helpers/navigation_helper.dart';
import '../../models/enums/form_modes.dart';
import '../../providers/expense_provider.dart';
import '../../service/expense_service.dart';
import '../dialogs/message_dialog.dart';
import '../drawer/home_drawer.dart';
import '../widgets/expense/expense_list_dynamic.dart';
import 'expense_screen.dart';
import 'settings/preferences_settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final String title = "Expense Tracker";
  static final Future<ExpenseService> _expenseService = ExpenseService.create();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _refreshExpensesHome(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return MaterialApp(
            theme: ThemeData(colorScheme: const ColorScheme.dark()),
            home: Scaffold(
              drawer: const SafeArea(child: HomeDrawer()),
              appBar: AppBar(
                centerTitle: true,
                title: Text(title, textScaleFactor: 0.9),
                backgroundColor: Colors.black,
                actions: [
                  if (DebugHelper.isDebugMode)
                    IconButton(
                      icon: const Icon(Icons.add, size: 20),
                      tooltip: "add random expense",
                      onPressed: () => populateExpense(context),
                    ),
                  if (DebugHelper.isDebugMode)
                    IconButton(
                      icon: const Icon(Icons.add_to_home_screen_outlined,
                          size: 20),
                      tooltip: "navigate to screen",
                      onPressed: () => navigateToScreen(context),
                    ),
                  IconButton(
                    icon: const Icon(Icons.person, size: 20),
                    tooltip: "Profile",
                    onPressed: () => _handelProfile(context),
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

  void _handelProfile(BuildContext context) => {
    showDialog(
      context: context,
      builder: (context) => const SimpleDialogWidget(
        title: 'To be added',
        message: 'Profile will be added soon',
      ),
    ),
  };

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

  navigateToScreen(BuildContext context) {
    NavigationHelper.navigateToScreen(
        context, const PreferencesSettingsScreen());
  }
}
