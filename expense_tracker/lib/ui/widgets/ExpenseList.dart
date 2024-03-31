import 'package:expense_tracker/data/database/database_helper.dart';
import 'package:expense_tracker/ui/pages/expense_page.dart';
import 'package:expense_tracker/ui/widgets/expense_tile_widgets.dart';
import 'package:flutter/material.dart';

import '../../models/expense_new.dart';

class ExpenseList extends StatefulWidget {
  final int rebuildCount;
  const ExpenseList({super.key, required this.rebuildCount});

  @override
  State<ExpenseList> createState() => _ExpenseListState();
}

class _ExpenseListState extends State<ExpenseList> {

  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Expense> allExpenses = <Expense>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeExpenses();
  }

  Future<void> initializeExpenses() async {
    await databaseHelper.initializeDatabase();
    final List<Map<String, dynamic>> expenseMapList = await databaseHelper.getExpenseMapList();
    // await Future.delayed(const Duration(seconds: 2));
    setState(() {
      debugPrint("in init expenses ${expenseMapList.length} $expenseMapList");
      allExpenses = Expense.fromMapList(expenseMapList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return allExpenses == null
        ? const Center(child: CircularProgressIndicator())
        : allExpenses.isEmpty
        ? Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text(
                  'Click',
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(width: 8),  // Adjust the spacing between the icon and text
                Icon(
                  Icons.add,  // Replace with the desired icon
                  color: Colors.grey,  // Replace with the desired icon color
                ),
                SizedBox(width: 8),  // Adjust the spacing between the icon and text
                Text(
                  'icon to add an Expense',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          )
        : getExpenseListViewV2();
  }

   getExpenseListViewV2() {
    // return Placeholder();
    return Scaffold(
      body: RefreshIndicator(
          onRefresh: _refreshExpenses,
          color: Colors.grey.shade900,
          child: ListView.builder(
            itemCount: allExpenses.length,
            itemBuilder: (context, index) {
              // debugPrint("$index  ${allExpenses[index]}");
              return getExpenseListTile(index, allExpenses[index]);
            },
          )
      ),
          floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.grey.shade500,
          tooltip: 'Add New Expense',
          onPressed: _addExpense,
          child: const Icon(Icons.add),
          )
     );
  }

  Container getExpenseListTile(int index, Expense expense) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        // borderRadius: BorderRadius.circular(5.0),
      ),
      margin: const EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
      child: InkWell(
        onTap: editExpense,
        child: ExpenseTileWidgets.expenseTile(expense),
      ),
    );
  }

  void editExpense(){
    debugPrint("tapped");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ExpensePage(formMode: "Edit"),
      ),
    );
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
    _refreshExpenses();
  }

  Future<void> _refreshExpenses() async {
    // await Future.delayed(Duration(seconds: 2));
    final List<Map<String, dynamic>> expenseMapList = await databaseHelper.getExpenseMapList();
    setState(() {
      allExpenses = Expense.fromMapList(expenseMapList);
    });
  }
}