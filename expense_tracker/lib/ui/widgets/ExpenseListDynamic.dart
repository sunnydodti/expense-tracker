import 'package:expense_tracker/data/database/database_helper.dart';
import 'package:expense_tracker/ui/pages/expense_page.dart';
import 'package:flutter/material.dart';

class ExpenseListDynamic extends StatefulWidget {
  final List<Map<String, dynamic>> allExpenses;
  final Function onRefresh;

  const ExpenseListDynamic({super.key, required this.allExpenses, required this.onRefresh});

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
        : getExpenseListViewV3();
  }

  getExpenseListViewV3() {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshExpensesList,
        color: Colors.grey.shade900,
        child: ListView.builder(
          itemCount: allExpenses.length,
          itemBuilder: (context, index) {
            // debugPrint("$index  ${expenseMapList[index]}");
            return getDismissibleExpenseTile(index, allExpenses[index]);
          },
        ),
      ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 35.0),
          child: FloatingActionButton(
            backgroundColor: Colors.grey.shade500,
            tooltip: 'Add New Expense',
            onPressed: _addExpense,
            child: const Icon(Icons.add),
          ),
        )
    );
    // ExpenseListItemV2.fromMapList(expenseMapList: allExpenses);
  }

  Future<void> _refreshExpensesList() async {
    final List<Map<String, dynamic>> expenseMapList = await databaseHelper.getExpenseMapList();
    setState(() {
      allExpenses = expenseMapList;
    });
    // onRefresh();
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
            _deleteItem(index, expenseMap);
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
        onTap: editExpense,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          // padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children:[
              Row(
                children: [
                  displayTitle(expenseMap),
                  displayCategory(expenseMap),
                ],
              ),
              const SizedBox(height: 5.0),
              Row(
                children: [
                  displayTags(expenseMap)
                ],
              ),
              const SizedBox(height: 5.0),
              Row(
                children: [
                  displayNote(expenseMap),
                  displayAmount(expenseMap),
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

  Expanded displayAmount(Map<String, dynamic> expenseMap) {
    return Expanded(
      flex: 1,
      child: Align(
        alignment: Alignment.topRight,
        child: Text(
          '+ ${expenseMap["currency"]}${expenseMap["amount"]}',
          style: const TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }

  Expanded displayNote(Map<String, dynamic> expenseMap) {
    Text note;
    expenseMap['note'] == null
        ? note = const Text("")
        : note = Text(
      '${expenseMap['note']}',
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

  Container displayTags(Map<String, dynamic> expenseMap) {
    Text tags;
    expenseMap['note'] == null
        ? tags = const Text("")
        : tags = Text(
      expenseMap['tags'],
      style: const TextStyle(fontSize: 10.0),
    );
    return Container(
        child: tags
    );
  }

  Expanded displayCategory(Map<String, dynamic> expenseMap) {
    return Expanded(
      child: Align(
        alignment: Alignment.topRight,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '${expenseMap['category']} ',
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

  Expanded displayTitle(Map<String, dynamic> expenseMap) {
    return Expanded(
      child: Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: EdgeInsets.zero,
          child: Text(
            expenseMap['title'],
            style: const TextStyle(fontSize: 16.0),
          ),
        ),
      ),
    );
  }

  void _deleteItem(index, Map<String, dynamic> expenseMap) {
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

  void _editItem(int index, Map<String, dynamic> expenseMap) {
    // Implement editing logic here
    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(
    //     content: Text('Edit item'),
    //   ),
    // );

    setState(() {
      // Create a copy of the list
      var newList = List<Map<String, dynamic>>.from(allExpenses);
      newList.removeAt(index);
      allExpenses = newList; // Update the state with the modified list
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('To be added, please undo'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              allExpenses.insert(index, expenseMap);
            });
          },
        ),
      ),
    );
    // setState(() {
    //   expenseMapList.insert(index, expenseMap);
    // });
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
