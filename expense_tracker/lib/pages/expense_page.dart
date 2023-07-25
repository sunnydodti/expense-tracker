import 'package:expense_tracker/forms/expense_form.dart';
import 'package:flutter/material.dart';

class ExpensePage extends StatefulWidget {
  const ExpensePage({Key? key, required this.formMode}) : super(key: key);

  final String formMode;

  @override
  _ExpensePageState createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
          backgroundColor: Colors.blue[50],
          appBar: AppBar(
            leading: SafeArea(child: BackButton(
              onPressed: () {
                Navigator.pop(context);
              },
            )),
            title: Center(
              child: Text("${widget.formMode} Expense"),
            ),
          ),
          body: ExpenseForm(formMode: widget.formMode)),
    );
  }
}
