import 'package:flutter/material.dart';

import '../../data/constants/ui_constants.dart';
import '../../data/helpers/color_helper.dart';
import '../../data/helpers/navigation_helper.dart';
import '../../globals.dart';
import '../drawer/home_drawer.dart';
import '../widgets/common/add_expense_fab.dart';
import '../widgets/common/install_pwa_button.dart';
import '../widgets/common/main_app_bar.dart';
import '../widgets/content_area_navigation.dart';
import '../widgets/expense/expense_list.dart';
import '../widgets/expense/expense_summary.dart';
import '../widgets/sort_n_filter/sort_filter_tile.dart';

class TabletScaffold extends StatelessWidget {
  const TabletScaffold({super.key});
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: NavigationHelper.handleBackPress,
      child: Scaffold(
        drawer: const SafeArea(child: HomeDrawer()),
        appBar: const MainAppBar(),
        backgroundColor: ColorHelper.getBackgroundColor(Theme.of(context)),
        body: Row(
          children: [
            Expanded(
              flex: 3,
              child: ContentAreaNavigation(
                key: tabletContentAreaKey,
                defaultContent: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SortFilterTile(),
                    SizedBox(height: uiSize),
                    Expanded(child: ExpenseList()),
                  ],
                ),
              ),
            ),
            const Expanded(
              flex: 2,
              child: Column(
                children: [
                  ExpenseSummary(
                    margin: EdgeInsets.only(top: uiSize, right: uiSize),
                  ),
                  InstallPwaButton(
                    padding: EdgeInsets.only(
                      top: uiSize,
                      bottom: uiSize,
                      left: uiSize,
                      right: uiPaddingX2,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        floatingActionButton: const AddExpenseFAB(),
      ),
    );
  }
}
