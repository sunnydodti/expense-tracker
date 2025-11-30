import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/constants/form_constants.dart';
import '../../../data/constants/shared_preferences_constants.dart';
import '../../../data/constants/ui_constants.dart';
import '../../../data/helpers/color_helper.dart';
import '../../../data/helpers/navigation_helper.dart';
import '../../../providers/expense_provider.dart';
import '../../../providers/profile_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../../service/shared_preferences_service.dart';
import '../../animations/blur_widget.dart';
import '../../screens/charts_screen.dart';

class ExpenseSummary extends StatefulWidget {
  final EdgeInsets margin;
  const ExpenseSummary({
    super.key,
    this.margin = const EdgeInsets.only(
      top: uiPadding,
      left: uiPadding,
      right: uiPadding,
    ),
  });

  @override
  State<ExpenseSummary> createState() => _ExpenseSummaryState();
}

class _ExpenseSummaryState extends State<ExpenseSummary> {
  late bool hideTotal = false;
  SharedPreferencesService sharedPreferencesService =
      SharedPreferencesService();

  ExpenseProvider get expenseProvider =>
      Provider.of<ExpenseProvider>(context, listen: false);

  ProfileProvider get profileProvider =>
      Provider.of<ProfileProvider>(context, listen: false);

  void getHideTotalPreference() async {
    bool? isTotalHidden = await sharedPreferencesService
        .getBoolPreference(SharedPreferencesConstants.summary.HIDE_TOTAL_KEY);

    setState(() {
      hideTotal = isTotalHidden ?? false;
    });
  }

  @override
  void initState() {
    getHideTotalPreference();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return GestureDetector(
      onTap: () => navigateToChartsScreen(context),
      child: _buildSummary(theme),
    );
  }

  void navigateToChartsScreen(BuildContext context) {
    bool refreshData = true;
    NavigationHelper.navigateToScreen(
      context,
      ChartsScreen(refreshData: refreshData),
    );
  }

  Consumer<ExpenseProvider> _buildSummary(ThemeData theme) {
    return Consumer<ExpenseProvider>(
        builder: (context, expenseProvider, child) {
      return Card(
        color: ColorHelper.getTileColor(Theme.of(context)),
        margin: widget.margin,
        child: Column(
          children: [
            Stack(
              children: [
                _buildSummaryContainer(
                  "Total Balance",
                  expenseProvider.getTotalBalance(),
                  theme,
                  top: uiPadding,
                  bottom: uiPaddingHalf,
                  left: uiPadding,
                  right: uiPadding,
                ),
                buildIcons(theme)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _buildSummaryContainer(
                    "Total Income",
                    expenseProvider.getTotalIncome(),
                    theme,
                    top: uiPaddingHalf,
                    bottom: uiPadding,
                    left: uiPadding,
                    right: uiPaddingHalf,
                  ),
                ),
                Expanded(
                  child: _buildSummaryContainer(
                    "Total Expense",
                    expenseProvider.getTotalExpenses() * -1,
                    theme,
                    top: uiPaddingHalf,
                    bottom: uiPadding,
                    left: uiPaddingHalf,
                    right: uiPadding,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Card _buildSummaryContainer(
    String summaryText,
    double amount,
    ThemeData theme, {
    double top = uiPadding,
    double bottom = uiPadding,
    double left = uiPadding,
    double right = uiPadding,
    double padding = uiPaddingHalf,
  }) {
    return Card(
      margin:
          EdgeInsets.only(top: top, bottom: bottom, left: left, right: right),
      color: ColorHelper.getBackgroundColor(Theme.of(context)),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: padding, horizontal: padding),
        child: Column(
          children: [
            _getSummaryText(summaryText),
            const SizedBox(height: uiSizeHalf),
            hideTotal
                ? BlurWidget(widget: _getSummaryAmountConsumer(amount))
                : _getSummaryAmountConsumer(amount),
          ],
        ),
      ),
    );
  }

  Consumer<SettingsProvider> _getSummaryAmountConsumer(double amount) {
    String sign = amount > 0 ? '+' : (amount < 0 ? '-' : '');
    return Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) {
      String currency =
          FormConstants.expense.currencies[settingsProvider.defaultCurrency]!;
      return Text(
        '$sign $currency ${amount.abs().round()}',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: amount > 0
              ? Colors.green.shade400
              : (amount < 0 ? Colors.red.shade400 : null),
        ),
      );
    });
  }

  Text _getSummaryText(String summaryText) {
    return Text(
      summaryText,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  buildIcons(ThemeData theme) {
    Color? color = ColorHelper.getIconColor(Theme.of(context));

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildChartIcon(color),
        buildIHideIcon(color),
      ],
    );
  }

  Padding buildChartIcon(Color? color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: uiPadding, vertical: 2),
      child: IconButton(
          onPressed: () => navigateToChartsScreen(context),
          tooltip: "View Charts",
          icon: Icon(Icons.bar_chart_outlined, color: color)),
    );
  }

  Padding buildIHideIcon(Color? color) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: uiPadding, vertical: uiPadding),
      child: IconButton(
        onPressed: () {
          setState(() {
            hideTotal = !hideTotal;
          });
          setHideTotalPreference();
        },
        tooltip: hideTotal ? 'Show Total' : 'Hide Total',
        icon: hideTotal
            ? Icon(Icons.visibility_outlined, color: color)
            : Icon(Icons.visibility_off_outlined, color: color),
      ),
    );
  }

  void setHideTotalPreference() async {
    await sharedPreferencesService.setBoolPreference(
      SharedPreferencesConstants.summary.HIDE_TOTAL_KEY,
      hideTotal,
    );
    await sharedPreferencesService.getBoolPreference(
      SharedPreferencesConstants.summary.HIDE_TOTAL_KEY,
    );
  }
}
