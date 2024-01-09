// ignore_for_file: prefer_const_constructors

// import 'package:expense_tracker/data/database/database_helper.dart';
import 'package:expense_tracker/data/database/database_helper.dart';
import 'package:expense_tracker/data/samples/get_sample_data.dart';
import 'package:expense_tracker/ui/pages/expense_page.dart';
import 'package:expense_tracker/ui/widgets/ExpenseList.dart';
import 'package:expense_tracker/ui/widgets/ExpenseListDynamic.dart';
import 'package:expense_tracker/ui/widgets/dismiss_temp.dart';
import 'package:expense_tracker/ui/widgets/expense_list_item_v2.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';

import '../../models/expense_new.dart';
import '../widgets/expense_list_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  // DatabaseHelper databaseHelper = DatabaseHelper();
  // late List<Expense> expensesList;
  // int count = 0;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var expenseCount = 1;
  int rebuildCount = 0;

  DatabaseHelper databaseHelper = DatabaseHelper();
  late List<Expense> expensesList;
  int count = 0;

  List<Map<String, dynamic>> demoExpenses = <Map<String, dynamic>>[];

  @override
  void initState() {
    expensesList = <Expense>[];
    // setState(() {
    //   demoExpenses = GetSampleData.getDemoExpenses();
    //   // demoExpenses = <Map<String, dynamic>>[];
    // });
    // var expenses = ;
    initializeExpenses();
  }

  Future<void> initializeExpenses() async {
    await databaseHelper.initializeDatabase();
    final List<Map<String, dynamic>> expenseMapList = await databaseHelper.getExpenseMapList();

    setState(() {
      debugPrint("in init expenses ${expenseMapList.length} $expenseMapList");
      demoExpenses = expenseMapList;
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
                _refreshExpenses()
              },
            ),
          ],
        ),
        body: ExpenseList(rebuildCount: rebuildCount),
        // body: ExpenseListDynamic(),
        // demoExpenses == null
        //     ? Center(child: CircularProgressIndicator())
        //     : demoExpenses.isEmpty
        //     ? Center(
        //   child: Text('No expenses available.'),
        // )
        //     : getExpenseListViewV2(),
            // : getExpenseListViewV3(),
            // : TempDismiss(),
            // : Center(child: CircularProgressIndicator()),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.grey.shade500,
          tooltip: 'Add New Expense',
          onPressed: _addExpense,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }



  void _openEditingForm() {
    // Implement logic to open the editing form with expense data

    // final randomExpenseDataList = expenses.sublist(0, 10); // Get 10 random expense items
  }

  void _deleteExpense(BuildContext context, Expense expense) async {
    // int result = await databaseHelper.deleteExpense(expense.id);
  }

  void _showSnackbar(BuildContext context, String message) {
    final SnackBar snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  getExpenseListViewV2() {
    final expenseList = demoExpenses; // Get 10 random expense items
    // return Placeholder();
    return RefreshIndicator(
        onRefresh: _refreshExpenses,
        color: Colors.grey.shade900,
        child: ListView.builder(
        itemCount: expenseList.length,
        itemBuilder: (context, index) {
          // debugPrint("$index  ${expenseList[index]}");
          return ExpenseListItem.fromMap(expenseMap: expenseList[index]);
        },
      )
    );
  }
  getExpenseListViewV3() {
    final expenseList = demoExpenses; // Get 10 random expense items
    return RefreshIndicator(
        onRefresh: _refreshExpenses,
        color: Colors.grey.shade900,
        child: ExpenseListItemV2.fromMapList(expenseMapListOG: demoExpenses)
    );
      // ExpenseListItemV2.fromMapList(expenseMapList: demoExpenses);
  }

  Future<void> _refreshExpenses() async {
    // await Future.delayed(Duration(seconds: 2));
    final List<Map<String, dynamic>> expenseMapList = await databaseHelper.getExpenseMapList();
    setState(() {
      demoExpenses = expenseMapList;
      rebuildCount += 1;
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
    // debugPprint("after return $result");
    if (result != null && result is bool && result) _refreshExpenses();
  }
}
