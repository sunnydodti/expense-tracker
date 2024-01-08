import 'package:expense_tracker/models/expense_new.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  Expenses({Key? key}) : super(key: key);
  List<Expense> expenses = new List.empty(growable: true);
  int expenseCount = 0;

  @override
  _ExpensesState createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  @override
  Widget build(BuildContext context) {
    List<Widget> expenseList = new List.empty(growable: true);
    for (Expense expense in widget.expenses) {
      Container(
        child: Column(
          children: [
            Row(children: [
              Text("")
            ]),
            Row(),
            Row(),
          ], 
          ),
      );
    }
    return Scaffold(
      body: Stack(children: expenseList),
    );
  }
}
