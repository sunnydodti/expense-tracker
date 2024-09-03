import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/constants/form_constants.dart';
import '../../../data/constants/shared_preferences_constants.dart';
import '../../../data/helpers/color_helper.dart';
import '../../../data/helpers/navigation_helper.dart';
import '../../../data/helpers/shared_preferences_helper.dart';
import '../../../providers/expense_provider.dart';
import '../../../providers/profile_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../../service/shared_preferences_service.dart';
import '../../animations/blur_widget.dart';
import '../../screens/charts_screen.dart';

class ExpenseSummary extends StatefulWidget {
  const ExpenseSummary({Key? key}) : super(key: key);

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

  Future<String> _getCurrency() async {
    String? currencyPreference = await SharedPreferencesHelper()
        .getString(SharedPreferencesConstants.settings.DEFAULT_CURRENCY);
    return FormConstants.expense.currencies[currencyPreference!]!;
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
    bool refreshData = false;
    if (profileProvider.isChanged) {
      refreshData = true;
      profileProvider.isChanged = false;
    }

    if (expenseProvider.isChanged) {
      refreshData = true;
      expenseProvider.isChanged = false;
    }
    NavigationHelper.navigateToScreen(
        context, ChartsScreen(refreshData: refreshData));
  }

  Consumer<ExpenseProvider> _buildSummary(ThemeData theme) {
    return Consumer<ExpenseProvider>(
        builder: (context, expenseProvider, child) {
      return Card(
        color: ColorHelper.getTileColor(Theme.of(context)),
        margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
        child: Column(
          children: [
            Stack(
              children: [
                _buildSummaryContainer(
                  "Total Balance",
                  expenseProvider.getTotalBalance(),
                  theme,
                  top: 10,
                  bottom: 5,
                  left: 10,
                  right: 10,
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
                    top: 5,
                    bottom: 10,
                    left: 10,
                    right: 5,
                  ),
                ),
                Expanded(
                  child: _buildSummaryContainer(
                    "Total Expense",
                    expenseProvider.getTotalExpenses() * -1,
                    theme,
                    top: 5,
                    bottom: 10,
                    left: 5,
                    right: 10,
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
    double top = 10,
    double bottom = 10,
    double left = 10,
    double right = 10,
    double padding = 5,
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
            const SizedBox(height: 5),
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
        textScaleFactor: 1.1,
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
      textScaleFactor: 1.1,
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: IconButton(
          onPressed: () => navigateToChartsScreen(context),
          icon: Icon(Icons.bar_chart_outlined, color: color)),
    );
  }

  Padding buildIHideIcon(Color? color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: IconButton(
        onPressed: () {
          setState(() {
            hideTotal = !hideTotal;
          });
          setHideTotalPreference();
        },
        icon: hideTotal
            ? Icon(Icons.visibility_outlined, color: color)
            : Icon(Icons.visibility_off_outlined, color: color),
      ),
    );
  }

  void setHideTotalPreference() async {
    sharedPreferencesService.setBoolPreference(
        SharedPreferencesConstants.summary.HIDE_TOTAL_KEY, hideTotal);
    await sharedPreferencesService
        .getBoolPreference(SharedPreferencesConstants.summary.HIDE_TOTAL_KEY);
  }
}
