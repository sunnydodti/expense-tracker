import 'package:expense_tracker/data/database/database_helper.dart';
import 'package:expense_tracker/ui/pages/expense_page.dart';
import 'package:flutter/material.dart';

class ExpenseList extends StatefulWidget {
  final int rebuildCount;
  const ExpenseList({super.key, required this.rebuildCount});

  @override
  State<ExpenseList> createState() => _ExpenseListState();
}

class _ExpenseListState extends State<ExpenseList> {

  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Map<String, dynamic>> allExpenses = <Map<String, dynamic>>[];

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
      allExpenses = expenseMapList;
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
              return getExpenseListTile(index);
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

  Future<void> _refreshExpenses() async {
    // await Future.delayed(Duration(seconds: 2));
    final List<Map<String, dynamic>> expenseMapList = await databaseHelper.getExpenseMapList();
    setState(() {
      allExpenses = expenseMapList;
    });
  }

  Container getExpenseListTile(int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        // borderRadius: BorderRadius.circular(5.0),
      ),
      margin: const EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
      child: InkWell(
        onTap: editExpense,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          // padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children:[
              Row(
                children: [
                  displayTitle(index),
                  displayCategory(index),
                ],
              ),
              const SizedBox(height: 5.0),
              Row(
                children: [
                  displayTags(index)
                ],
              ),
              const SizedBox(height: 5.0),
              Row(
                children: [
                  displayNote(index),
                  displayAmount(index),
                ],
              )
            ],
          ),
        ),
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
  Expanded displayAmount(int index) {
    return Expanded(
      flex: 1,
      child: Align(
        alignment: Alignment.topRight,
        child: Text(
          '+ ${allExpenses[index]["currency"]}${allExpenses[index]["amount"]}',
          style: const TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }

  Expanded displayNote(int index) {
    Text note;
    allExpenses[index]['note'] == null
        ? note = const Text("")
        : note = Text(
      '${allExpenses[index]['note']}',
      style: const TextStyle(fontSize: 13.5),
    );
    return Expanded(
      flex: 2,
      child: Align(
          alignment: Alignment.topLeft,
          child: FractionallySizedBox(
            widthFactor: 1,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1.0),
                borderRadius: BorderRadius.circular(5.0),
              ),
              padding: const EdgeInsets.all(5.0),
              child: Padding(
                padding: EdgeInsets.zero,
                child: note,
              ),
            ),
          )
      ),
    );
  }

  Container displayTags(int index) {
    Text tags;
    allExpenses[index]['note'] == null
        ? tags = const Text("")
        : tags = Text(
      allExpenses[index]['tags'],
      style: const TextStyle(fontSize: 10.0),
    );
    return Container(
        child: tags
    );
  }

  Expanded displayCategory(int index) {
    return Expanded(
      child: Align(
        alignment: Alignment.topRight,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '${allExpenses[index]['category']} ',
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
              const Icon(Icons.category_outlined,
                size: 20.0,)
            ]
        ),
      ),
    );
  }

  Expanded displayTitle(int index) {
    return Expanded(
      child: Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: EdgeInsets.zero,
          child: Text(
            allExpenses[index]['title'],
            style: const TextStyle(fontSize: 16.0),
          ),
        ),
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
}