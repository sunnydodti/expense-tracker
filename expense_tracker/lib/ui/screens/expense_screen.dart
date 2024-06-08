import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/helpers/color_helper.dart';
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
    ThemeData theme = Theme.of(context);

    Color? backgroundColor = ColorHelper.getBackgroundColor(theme);
    Color? appBarColor = ColorHelper.getAppBarColor(theme);

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
