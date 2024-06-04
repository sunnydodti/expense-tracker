import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/helpers/debug_helper.dart';
import '../../../data/helpers/navigation_helper.dart';
import '../../../providers/expense_provider.dart';
import '../../../service/expense_service.dart';
import '../../dialogs/common/message_dialog.dart';
import '../../screens/settings/settings_screen.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool centerTitle;

  static final Future<ExpenseService> _expenseService = ExpenseService.create();

  const MainAppBar({
    super.key,
    this.title = "Expense Tracker",
    this.centerTitle = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    Future refreshExpenses(BuildContext context) async {
      Provider.of<ExpenseProvider>(context, listen: false).refreshExpenses();
    }

    void populateExpense() async {
      ExpenseService service = await _expenseService;
      service
          .populateExpense(count: 1)
          .then((value) => refreshExpenses(context));
    }

    navigateToScreen() {
      NavigationHelper.navigateToScreen(context, const SettingsScreen());
    }

    void handleProfile() => {
          showDialog(
            context: context,
            builder: (context) => const MessageDialog(
              title: 'To be added',
              message: 'Profile will be added soon',
            ),
          ),
        };

    return AppBar(
      centerTitle: centerTitle,
      title: Text(title, textScaleFactor: .8),
      backgroundColor: Colors.black,
      actions: [
        if (DebugHelper.isDebugMode)
          IconButton(
            icon: Icon(
              Icons.add,
              size: 20,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            tooltip: "Add random expense",
            onPressed: populateExpense,
          ),
        if (DebugHelper.isDebugMode)
          IconButton(
            icon: Icon(
              Icons.add_to_home_screen_outlined,
              size: 20,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            tooltip: "Navigate to screen",
            onPressed: navigateToScreen,
          ),
        IconButton(
          icon: Icon(
            Icons.person,
            size: 20,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
          tooltip: "Profile",
          onPressed: handleProfile,
        ),
      ],
    );
  }
}
