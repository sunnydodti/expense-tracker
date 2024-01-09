// ignore_for_file: prefer_const_constructors

import 'package:expense_tracker/data/database/database_helper.dart';
import 'package:expense_tracker/ui/pages/expense_page.dart';
import 'package:expense_tracker/ui/widgets/ExpenseList.dart';
import 'package:expense_tracker/ui/widgets/ExpenseListDynamic.dart';
import 'package:expense_tracker/ui/widgets/expense_list_item_v2.dart';
import 'package:flutter/material.dart';

import '../../models/expense_new.dart';
import '../widgets/expense_list_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var expenseCount = 1;
  int rebuildCount = 0;

  DatabaseHelper databaseHelper = DatabaseHelper();
  int count = 0;

  List<Map<String, dynamic>> allExpenses = [];

  @override
  void initState() {
    super.initState();
    initializeExpenses();
  }

  Future<void> initializeExpenses() async {
    await databaseHelper.initializeDatabase();
    final List<Map<String, dynamic>> expenseMapList = await databaseHelper.getExpenseMapList();

    setState(() {
      debugPrint("in init expenses ${expenseMapList.length} $expenseMapList");
      allExpenses = expenseMapList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // primarySwatch: Colors.grey,
        colorScheme: ColorScheme.dark()
      ),
      home: Scaffold(
        drawer: SafeArea(child: Placeholder()),
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.title),
          backgroundColor: Colors.black,
          // foregroundColor: Colors.grey,
          actions: [
            IconButton(
              icon: Icon(Icons.person),
              tooltip: "Profile",
              onPressed: () async  => {
                debugPrint("clicked profile"),
                await databaseHelper.populateDatabase(await databaseHelper.getDatabase),
                // await databaseHelper.deleteAllExpenses(),
                _refreshExpensesHome()
              },
            ),
          ],
        ),
        body: ExpenseList(rebuildCount: rebuildCount),
        // body: ExpenseListDynamic(allExpenses: allExpenses, onRefresh: _refreshExpensesHome),
        // floatingActionButton: FloatingActionButton(
        //   backgroundColor: Colors.grey.shade500,
        //   tooltip: 'Add New Expense',
        //   onPressed: _addExpense,
        //   child: const Icon(Icons.add),
        // ),
      ),
    );
  }



  void _openEditingForm() {
  //  To be added
  }

  void _deleteExpense(BuildContext context, Expense expense) async {
    // int result = await databaseHelper.deleteExpense(expense.id);
  }

  void _showSnackbar(BuildContext context, String message) {
    final SnackBar snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _refreshExpensesHome() async {
    // await Future.delayed(Duration(seconds: 2));
    final List<Map<String, dynamic>> expenseMapList = await databaseHelper.getExpenseMapList();
    setState(() {
      allExpenses = expenseMapList;
      rebuildCount += 1;
      print("rebuildcount $rebuildCount");
    });
  }

  void _addExpense() async {
    // if (_formKey.currentState.validate()) {
    debugPrint("clicked");
    // Open the new form.
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExpensePage(formMode: "Add"),
      ),
    );
    debugPrint("after return $result");
    // if (result != null && result is bool && result) _refreshExpensesHome();
    _refreshExpensesHome();
  }
}
