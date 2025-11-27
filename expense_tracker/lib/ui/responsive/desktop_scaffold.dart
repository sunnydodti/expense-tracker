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

class DesktopScaffold extends StatelessWidget {
  const DesktopScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return NavigationHelper.withSmartBackNavigation(
      context,
      child: Scaffold(
        appBar: const MainAppBar(centerTitle: false),
        backgroundColor: ColorHelper.getBackgroundColor(Theme.of(context)),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: uiPadding),
              child: HomeDrawer(),
            ),
            Expanded(
              flex: 2,
              child: ContentAreaNavigation(
                key: desktopContentAreaKey,
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
              child: Column(
                children: [
                  ExpenseSummary(
                    margin: EdgeInsets.only(top: uiSize, right: uiSize),
                  ),
                  InstallPwaButton(
                    padding: EdgeInsets.only(
                      top: uiPadding,
                      bottom: uiPadding,
                      left: uiPadding,
                      right: uiPaddingX2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: const AddExpenseFAB(),
      ),
    );
  }
}
