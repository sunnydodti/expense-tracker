import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/helpers/navigation_helper.dart';
import '../../models/enums/form_modes.dart';
import '../../models/expense.dart';
import '../../providers/expense_items_provider.dart';
import '../forms/expense/expense_form.dart';

class ExpensePage extends StatelessWidget {
  final FormMode formMode;
  final Expense? expense;

  const ExpensePage({Key? key, required this.formMode, this.expense})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double backgroundLerpT =
        Theme.of(context).colorScheme.brightness == Brightness.light
            ? .85
            : .05;
    double appBarLerpT =
        Theme.of(context).colorScheme.brightness == Brightness.light ? .1 : 0;

    Color? backgroundColor = Color.lerp(
        Theme.of(context).colorScheme.primary, Colors.white, backgroundLerpT);
    Color? appBarColor = Color.lerp(
        Theme.of(context).colorScheme.primary, Colors.white, appBarLerpT);

    return WillPopScope(
      onWillPop: () => _navigateBackWithBool(context),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: appBarColor,
          leading: SafeArea(
            child: BackButton(
              onPressed: () => _navigateBackWithBool(context),
            ),
          ),
          centerTitle: true,
          title: Text(
            "${formMode.name.replaceFirst(
              RegExp(r'^\w'),
              formMode.name[0].toUpperCase(),
            )} Expense",
            textScaleFactor: .85,
            overflow: TextOverflow.fade,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.check),
              tooltip: "Save",
              onPressed: () => {},
            ),
          ],
        ),
        body: ExpenseForm(formMode: formMode, expense: expense),
        // body: const Placeholder(),
      ),
    );
  }

  _navigateBackWithBool(BuildContext context) {
    Provider.of<ExpenseItemsProvider>(context, listen: false).clear();
    return NavigationHelper.navigateBackWithBool(context, false);
  }
}
