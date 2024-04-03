import 'package:expense_tracker/ui/pages/expense_page.dart';
import 'package:flutter/material.dart';

import '../../models/enums/form_modes.dart';

class ExpenseListItemV2 extends StatefulWidget {
  // final Expense expense;
  final List<Map<String, dynamic>> expenseMapListOG;
  const ExpenseListItemV2.fromMapList({Key? key, required this.expenseMapListOG}) : super(key: key);
  @override
  State<ExpenseListItemV2> createState() => _ExpenseListItemV2State();
}

class _ExpenseListItemV2State extends State<ExpenseListItemV2> {
  late List<Map<String, dynamic>> expenseMapList;

  @override
  void initState() {
    super.initState();
    expenseMapList = widget.expenseMapListOG;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenseMapList.length,
      itemBuilder: (context, index) {
        // debugPrint("$index  ${expenseMapList[index]}");
        return getDismissibleExpenseTile(index, expenseMapList[index]);
      },
    );
      // getDismissibleExpenseTile();
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
        builder: (context) => const ExpensePage(formMode: FormMode.edit),
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
    setState(() {
      // Create a copy of the list
      var newList = List<Map<String, dynamic>>.from(expenseMapList);
      newList.removeAt(index);
      expenseMapList = newList; // Update the state with the modified list
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Item deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              expenseMapList.insert(index, expenseMap);
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
      var newList = List<Map<String, dynamic>>.from(expenseMapList);
      newList.removeAt(index);
      expenseMapList = newList; // Update the state with the modified list
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('To be added, please undo'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              expenseMapList.insert(index, expenseMap);
            });
          },
        ),
      ),
    );
    // setState(() {
    //   expenseMapList.insert(index, expenseMap);
    // });
  }
}
