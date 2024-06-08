import 'package:flutter/material.dart';

import '../../data/helpers/color_helper.dart';
import '../drawer/home_drawer.dart';
import '../widgets/common/add_expense_fab.dart';
import '../widgets/common/main_app_bar.dart';
import '../widgets/expense/expense_list.dart';
import '../widgets/expense/expense_summary.dart';
import '../widgets/sort_n_filter/sort_filter_tile.dart';

class MobileScaffold extends StatelessWidget {
  const MobileScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SafeArea(child: HomeDrawer()),
      appBar: const MainAppBar(),
      backgroundColor: ColorHelper.getBackgroundColor(Theme.of(context)),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          ExpenseSummary(),
          SortFilterTile(),
          Expanded(child: ExpenseList())
        ],
      ),
      floatingActionButton: const AddExpenseFAB(),
    );
  }
}
