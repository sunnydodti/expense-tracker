import 'package:flutter/material.dart';

import '../../data/helpers/color_helper.dart';
import '../drawer/home_drawer.dart';
import '../widgets/common/add_expense_fab.dart';
import '../widgets/common/main_app_bar.dart';
import '../widgets/expense/expense_list.dart';
import '../widgets/expense/expense_summary.dart';
import '../widgets/sort_n_filter/sort_filter_tile.dart';

class TabletScaffold extends StatelessWidget {
  const TabletScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SafeArea(child: HomeDrawer()),
      appBar: const MainAppBar(),
      backgroundColor: ColorHelper.getBackgroundColor(Theme.of(context)),
      body: Row(
        children: [
          const Expanded(
            flex: 3,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [SortFilterTile(), Expanded(child: ExpenseList())],
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              color: ColorHelper.getBackgroundColor(Theme.of(context)),
              child: const ExpenseSummary(
                margin: EdgeInsets.only(top: 10, right: 10),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: const AddExpenseFAB(),
    );
  }
}
