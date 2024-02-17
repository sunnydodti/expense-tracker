import 'package:expense_tracker/data/database/database_helper.dart';
import 'package:expense_tracker/ui/pages/expense_page.dart';
import 'package:expense_tracker/ui/widgets/expense_tile_widgets.dart';
import 'package:flutter/material.dart';

class ExpenseListDynamic extends StatefulWidget {
  final List<Map<String, dynamic>> allExpenses;

  const ExpenseListDynamic({super.key, required this.allExpenses});

  @override
  State<ExpenseListDynamic> createState() => _ExpenseListDynamicState();
}

class _ExpenseListDynamicState extends State<ExpenseListDynamic> {

  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Map<String, dynamic>> allExpenses = <Map<String, dynamic>>[];

  @override
  void initState() {
    super.initState();
    initializeExpenses();
  }

  Future<void> initializeExpenses() async {
    await databaseHelper.initializeDatabase();
    final List<Map<String, dynamic>> expenseMapList = await databaseHelper.getExpenseMapList();
    setState(() {
      allExpenses = expenseMapList;
    });
  }

  @override
  Widget build(BuildContext context) {
    // return getExpenseListViewV3();
    return allExpenses == null
        ? const Center(child: CircularProgressIndicator())
        : getExpenseListViewV3();
  }

  getExpenseListViewV3() {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshExpensesList,
        color: Colors.blue.shade500,
        child: ListView.builder(
          itemCount: allExpenses.isEmpty ? 1 : allExpenses.length,
          itemBuilder: (context, index) {
            return allExpenses.isEmpty ? getNoExpensesView() : getDismissibleExpenseTile(index, allExpenses[index]);
          },
        ),
      ),
      floatingActionButton: AddExpenseButtom()
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

  Padding AddExpenseButtom() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: FloatingActionButton(
        backgroundColor: Colors.grey.shade500,
        tooltip: 'Add New Expense',
        onPressed: _addExpense,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _refreshExpensesList() async {
    final List<Map<String, dynamic>> expenseMapList = await databaseHelper.getExpenseMapList();
    setState(() {
      allExpenses = expenseMapList;
    });
  }

  Dismissible getDismissibleExpenseTile(int index, Map<String, dynamic> expenseMap) {
    return Dismissible(
        key: Key(expenseMap["id"].toString()),
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
            _deleteExpense(index, expenseMap);
          } else {
            // Swipe right to edit
            _editItem(index, expenseMap);
          }
        },
        child: getExpenseListTile(expenseMap));
  }

  Container getExpenseListTile(Map<String, dynamic> expenseMap) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        // borderRadius: BorderRadius.circular(5.0),
      ),
      margin: const EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
      child: InkWell(
        onTap: _editExpense,
        child: ExpenseTileWidgets.expenseTile(expenseMap)
      ),
    );
  }

  void _deleteExpense(index, Map<String, dynamic> expenseMap) {
    int expenseLength = allExpenses.length;
    debugPrint("$expenseLength");
    setState(() {
      // Create a copy of the list
      var newList = List<Map<String, dynamic>>.from(allExpenses);
      newList.removeAt(index);
      allExpenses = newList; // Update the state with the modified list
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Item deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              if (index+1 == expenseLength) {
                debugPrint("adding at end $index");
                allExpenses.add(expenseMap);
              } else {
                debugPrint("adding at $index");
                allExpenses.insert(index, expenseMap);
              }
            });
          },
        ),
      ),
    );
  }

  void _editItem(int index, Map<String, dynamic> expenseMap) async {
    int expenseLength = allExpenses.length;
    debugPrint("$expenseMap");
    setState(() {
      // Create a copy of the list
      var newList = List<Map<String, dynamic>>.from(allExpenses);
      newList.removeAt(index);
      allExpenses = newList; // Update the state with the modified list
    });

    bool result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ExpensePage(formMode: "Edit"),
      ),
    );
    setState(() {
      if (index+1 == expenseLength) {
        debugPrint("adding at end $index");
        allExpenses.add(expenseMap);
      } else {
        debugPrint("adding at $index");
        allExpenses.insert(index, expenseMap);
      }
    });
  }

  void _editExpense(){
    debugPrint("editing");
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
    _refreshExpensesList();
  }
}
