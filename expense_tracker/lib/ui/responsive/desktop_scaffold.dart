import 'package:flutter/material.dart';

import '../../data/helpers/color_helper.dart';
import '../drawer/home_drawer.dart';
import '../widgets/common/add_expense_fab.dart';
import '../widgets/common/main_app_bar.dart';
import '../widgets/expense/expense_list.dart';
import '../widgets/expense/expense_summary.dart';
import '../widgets/sort_n_filter/sort_filter_tile.dart';

class DesktopScaffold extends StatelessWidget {
  const DesktopScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(centerTitle: false),
      backgroundColor: ColorHelper.getBackgroundColor(Theme.of(context)),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const HomeDrawer(),
          Expanded(
              flex: 2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  SortFilterTile(),
                  Expanded(child: ExpenseList()),
                ],
              )),
          Expanded(
            child: Container(
                color: ColorHelper.getBackgroundColor(Theme.of(context)),
                child: const ExpenseSummary()),
          )
          // ExpenseListDynamic(),
          // ExpenseList(),
        ],
      ),
      floatingActionButton: const AddExpenseFAB(),
    );
  }
}
