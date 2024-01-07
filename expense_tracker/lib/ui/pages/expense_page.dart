import 'package:expense_tracker/forms/expense_form.dart';
import 'package:expense_tracker/forms/expense_form_v2.dart';
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
          appBar: AppBar(
            leading: SafeArea(child: BackButton(
              onPressed: () {
                Navigator.pop(context);
              },
            )),
            centerTitle: true,
            title: Text("${widget.formMode} Expense"),
            actions: [
              IconButton(
                icon: const Icon(Icons.check),
                tooltip: "Save",
                onPressed: () => {},
              ),
            ],
          ),
          // body: ExpenseForm(formMode: widget.formMode)),
          body: ExpenseFormV2(formMode: widget.formMode)),
    );
  }
}
