import 'package:flutter/material.dart';

import '../../../data/helpers/debug_helper.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? populateExpense;
  final VoidCallback? navigateToScreen;
  final VoidCallback? handleProfile;

  const MainAppBar({
    super.key,
    this.title = "Expense Tracker",
    this.populateExpense,
    this.navigateToScreen,
    this.handleProfile,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(title, textScaleFactor: 0.9),
      backgroundColor: Colors.black,
      actions: [
        if (DebugHelper.isDebugMode)
          IconButton(
            icon: Icon(Icons.add, size: 20, color: Theme.of(context).colorScheme.inversePrimary,),
            tooltip: "Add random expense",
            onPressed: populateExpense,
          ),
        if (DebugHelper.isDebugMode)
          IconButton(
            icon: Icon(Icons.add_to_home_screen_outlined, size: 20, color: Theme.of(context).colorScheme.inversePrimary,),
            tooltip: "Navigate to screen",
            onPressed: navigateToScreen,
          ),
        IconButton(
          icon: Icon(Icons.person, size: 20, color: Theme.of(context).colorScheme.inversePrimary,),
          tooltip: "Profile",
          onPressed: handleProfile,
        ),
      ],
    );
  }
}
