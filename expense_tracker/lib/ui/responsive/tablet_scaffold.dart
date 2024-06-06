import 'package:flutter/material.dart';

import '../drawer/home_drawer.dart';
import '../widgets/common/main_app_bar.dart';
import '../widgets/expense/expense_list.dart';
import '../widgets/expense/expense_summary.dart';
import '../widgets/sort_n_filter/sort_filter_tile.dart';

class TabletScaffold extends StatelessWidget {
  const TabletScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    double lerpT = Theme.of(context).colorScheme.brightness == Brightness.light
        ? .85
        : .05;
    return Scaffold(
      drawer: const SafeArea(child: HomeDrawer()),
      appBar: const MainAppBar(),
      backgroundColor: Color.lerp(
          Theme.of(context).colorScheme.primary, Colors.white, lerpT),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          ExpenseSummary(),
          SortFilterTile(),
          Expanded(child: ExpenseList())
        ],
      ),
    );
  }
}
