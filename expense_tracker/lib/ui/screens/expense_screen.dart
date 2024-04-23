import 'package:flutter/material.dart';

import '../../data/helpers/navigation_helper.dart';
import '../../forms/expense_form.dart';
import '../../models/enums/form_modes.dart';
import '../../models/expense.dart';

class ExpensePage extends StatelessWidget {
  final FormMode formMode;
  final Expense? expense;

  const ExpensePage({Key? key, required this.formMode, this.expense})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => NavigationHelper.navigateBackWithBool(context, false),
        child: Scaffold(
            // backgroundColor: Colors.grey.shade900,
            appBar: AppBar(
              leading: SafeArea(
                  child: BackButton(
                onPressed: () =>
                    NavigationHelper.navigateBackWithBool(context, false),
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
            body: ExpenseForm(formMode: formMode, expense: expense)));
  }
}
