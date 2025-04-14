import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/helpers/color_helper.dart';
import '../../data/helpers/navigation_helper.dart';
import '../../models/enums/form_modes.dart';
import '../../models/expense.dart';
import '../../providers/expense_items_provider.dart';
import '../forms/expense/expense_form.dart';
import '../notifications/snackbar_service.dart';
import '../widgets/common/screen_app_bar.dart';

class ExpensePage extends StatelessWidget {
  final FormMode formMode;
  final Expense? expense;

  const ExpensePage({Key? key, required this.formMode, this.expense})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    Color? backgroundColor = ColorHelper.getBackgroundColor(theme);
    String title = '${formMode.name.replaceFirst(
      RegExp(r'^\w'),
      formMode.name[0].toUpperCase(),
    )} Expense';

    return WillPopScope(
      onWillPop: () => _navigateBackWithBool(context),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: backgroundColor,
        appBar: ScreenAppBar(title: title, actions: _buildActions),
        body: ExpenseForm(formMode: formMode, expense: expense),
        // body: const Placeholder(),
      ),
    );
  }

  List<Widget> get _buildActions {
    return [
      IconButton(
        icon: const Icon(Icons.check),
        tooltip: "Save",
        onPressed: () {
          SnackBarService.showSnackBar("Coming soon, use the button below",
              duration: 2);
        },
      ),
    ];
  }

  _navigateBackWithBool(BuildContext context) {
    Provider.of<ExpenseItemsProvider>(context, listen: false).clear();
    return NavigationHelper.navigateBackWithBool(context, false);
  }
}
