import 'package:expense_tracker/forms/expense_form.dart';
import 'package:expense_tracker/models/enums/form_modes.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class ExpensePage extends StatelessWidget {
  final FormMode formMode;
  final Expense? expense;

  const ExpensePage({Key? key, required this.formMode, this.expense}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => navigateBack(context, false),
      child: Scaffold(
          appBar: AppBar(
            leading: SafeArea(child: BackButton(
              onPressed: () => navigateBack(context, false),
            )),
            centerTitle: true,
            title: Text("${formMode.name.replaceFirst(
              RegExp(r'^\w'),
              formMode.name[0].toUpperCase(),
            )} Expense"),
            actions: [
              IconButton(
                icon: const Icon(Icons.check),
                tooltip: "Save",
                onPressed: () => {},
              ),
            ],
          ),
          body: ExpenseForm(formMode: formMode, expense: expense)),
    );
  }

  navigateBack(BuildContext context, bool result) {
    Navigator.pop(context, result);
  }
}
