import 'package:flutter/material.dart';

import '../drawer/home_drawer.dart';
import '../widgets/common/main_app_bar.dart';
import '../widgets/expense/expense_list.dart';
import '../widgets/expense/expense_summary.dart';
import '../widgets/sort_n_filter/sort_filter_tile.dart';

class DesktopScaffold extends StatelessWidget {
  const DesktopScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    double lerpT = Theme.of(context).colorScheme.brightness == Brightness.light
        ? .85
        : .05;
    return Scaffold(
      appBar: const MainAppBar(centerTitle: false),
      backgroundColor: Color.lerp(
          Theme.of(context).colorScheme.primary, Colors.white, lerpT),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const HomeDrawer(),
          Expanded(
              flex: 2,
              child: Container(
                // color: Colors.grey.shade400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    SortFilterTile(),
                    Expanded(child: ExpenseList()),
                  ],
                ),
              )),
          Expanded(
            child: Container(
                color: Color.lerp(
                    Theme.of(context).colorScheme.primary, Colors.white, lerpT),
                child: const ExpenseSummary()),
          )
          // ExpenseListDynamic(),
          // ExpenseList(),
        ],
      ),
    );
  }
}
