import 'package:expense_tracker/forms/expense_form.dart';
import 'package:expense_tracker/forms/form_modes.dart';
import 'package:expense_tracker/ui/pages/expense_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/expense_provider.dart';

class ExpenseListItem extends StatefulWidget {
  // final Expense expense;
  final Map<String, dynamic> expenseMap;
  const ExpenseListItem.fromMap({Key? key, required this.expenseMap}) : super(key: key);
  @override
  State<ExpenseListItem> createState() => _ExpenseListItemState();
}

class _ExpenseListItemState extends State<ExpenseListItem> {
  @override
  Widget build(BuildContext context) {
    return getExpenseListTile();
  }
  Container getExpenseListTile() {
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
                  displayTitle(),
                  displayCategory(),
                ],
              ),
              const SizedBox(height: 5.0),
              Row(
                children: [
                  displayTags()
                ],
              ),
              const SizedBox(height: 5.0),
              Row(
                children: [
                  displayNote(),
                  displayAmount(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
  void editExpense() async {
    debugPrint("tapped");
    int result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ExpensePage(formMode: FormMode.edit),
      ),
    );
    if (result > 0){
      _refreshExpenses();
    }
  }

  _refreshExpenses() {
    final expenseProvider = Provider.of<ExpenseProvider>(context, listen: false);
    expenseProvider.refreshExpenses();
  }

  Expanded displayAmount() {
    return Expanded(
      flex: 1,
      child: Align(
        alignment: Alignment.topRight,
        child: Text(
          '+ ${widget.expenseMap["currency"]}${widget.expenseMap["amount"]}',
          style: const TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }

  Expanded displayNote() {
    Text note;
    widget.expenseMap['note'] == null
        ? note = const Text("")
        : note = Text(
            '${widget.expenseMap['note']}',
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

  Container displayTags() {
    Text tags;
    widget.expenseMap['note'] == null
        ? tags = const Text("")
        : tags = Text(
            widget.expenseMap['tags'],
            style: const TextStyle(fontSize: 10.0),
          );
    return Container(
      child: tags
    );
  }

  Expanded displayCategory() {
    return Expanded(
      child: Align(
        alignment: Alignment.topRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              '${widget.expenseMap['category']} ',
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

  Expanded displayTitle() {
    return Expanded(
      child: Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: EdgeInsets.zero,
          child: Text(
            widget.expenseMap['title'],
            style: const TextStyle(fontSize: 16.0),
          ),
        ),
      ),
    );
  }

  void _deleteItem(int index) {
    // setState(() {
    //   // items.removeAt(index);
    // });
    widget.expenseMap;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Item deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              // items.insert(index, 'Undone Item');
            });
          },
        ),
      ),
    );
  }

  void _editItem(int index) {
    // Implement editing logic here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Edit item'),

      ),
    );
  }
}
