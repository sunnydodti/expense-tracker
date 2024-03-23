// ignore_for_file: prefer_const_constructors

import 'package:expense_tracker/data/database/database_helper.dart';
import 'package:expense_tracker/ui/drawer/home_drawer.dart';
import 'package:expense_tracker/ui/widgets/ExpenseList.dart';
import 'package:expense_tracker/ui/widgets/ExpenseListDynamic.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int rebuildCount = 0;

  DatabaseHelper databaseHelper = DatabaseHelper();
  int count = 0;

  List<Map<String, dynamic>> allExpenses = [];

  @override
  void initState() {
    super.initState();
    initializeExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.dark()
      ),
      home: Scaffold(
        drawer: SafeArea(child: HomeDrawer()),
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.title),
          backgroundColor: Colors.black,
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
        // body: ExpenseList(rebuildCount: rebuildCount),
        // body: ExpenseListDynamic(allExpenses: allExpenses),
        body: ExpenseListDynamic(),
      ),
    );
  }

  Future<void> initializeExpenses() async {
    await databaseHelper.initializeDatabase();
    final List<Map<String, dynamic>> expenseMapList = await databaseHelper.getExpenseMapList();

    setState(() {
      debugPrint("in init expenses ${expenseMapList.length} $expenseMapList");
      allExpenses = expenseMapList;
    });
  }

  Future<void> _refreshExpensesHome() async {
    final List<Map<String, dynamic>> expenseMapList = await databaseHelper.getExpenseMapList();
    setState(() {
      allExpenses = expenseMapList;
      rebuildCount += 1;
      debugPrint("rebuildCount $rebuildCount");
    });
  }

  // void _addExpense() async {
  //   // if (_formKey.currentState.validate()) {
  //   debugPrint("clicked");
  //   // Open the new form.
  //   var result = await Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => ExpensePage(formMode: "Add"),
  //     ),
  //   );
  //   debugPrint("after return $result");
  //   // if (result != null && result is bool && result) _refreshExpensesHome();
  //   _refreshExpensesHome();
  // }
}
