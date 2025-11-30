import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/constants/ui_constants.dart';
import '../../data/helpers/color_helper.dart';
import '../../data/helpers/navigation_helper.dart';
import '../../models/expense_item.dart';
import '../../providers/expense_items_provider.dart';
import '../animations/blur_screen.dart';
import '../animations/scale_up.dart';
import '../forms/expense/expense_item_form.dart';
import 'widget_constants.dart';

class ExpenseItemsScreen extends StatelessWidget {
  final String currency;
  final String expenseTitle;

  const ExpenseItemsScreen(
      {super.key, required this.currency, this.expenseTitle = ""});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        BlurScreen(onTap: () => NavigationHelper.navigateBack(context)),
        ScaleUp(child: _buildExpenseItemsScreen(context)),
      ],
    );
  }

  Card _buildExpenseItemsScreen(BuildContext context) {
    String title = "Expense Items";
    if (expenseTitle.isNotEmpty) title += " for $expenseTitle";
    return Card(
      color: ColorHelper.getTileColor(Theme.of(context)),
      margin: const EdgeInsets.only(left: 40, right: 40, top: 90),
      child: Card(
        color: ColorHelper.getBackgroundColor(Theme.of(context)),
        margin: const EdgeInsets.all(uiPadding),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(title),
                wcDivider,
                ExpenseItemForm(currency: currency),
                _buildExpenseItemsList()
              ],
            )
          ],
        ),
      ),
    );
  }

  Consumer<ExpenseItemsProvider> _buildExpenseItemsList() {
    return Consumer<ExpenseItemsProvider>(
      builder: (context, expenseItemsProvider, child) =>
          _buildExpenseItemsTable(context, expenseItemsProvider.expenseItems),
    );
  }

  Container _buildExpenseItemsTable(
    BuildContext context,
    List<ExpenseItemFormModel> expenseItems,
  ) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 800),
      child: SingleChildScrollView(
        child: DataTable(
          columnSpacing: uiPaddingX2,
          dataRowHeight: uiDataRowSize,
          columns: const [
            DataColumn(
              label: Text('Name'),
            ),
            DataColumn(label: Text('Amt')),
            DataColumn(label: Text('Qty')),
            DataColumn(label: Text('Total')),
            DataColumn(label: Text('')),
          ],
          rows: _buildDataRows(context, expenseItems),
        ),
      ),
    );
  }

  List<DataRow> _buildDataRows(
    BuildContext context,
    List<ExpenseItemFormModel> expenseItems,
  ) {
    return expenseItems.map((expenseItem) {
      return DataRow(cells: [
        DataCell(Text(expenseItem.name)),
        DataCell(Text('$currency${expenseItem.amount.round()}')),
        DataCell(Text('${expenseItem.quantity}')),
        DataCell(Text('$currency${expenseItem.total.round()}')),
        DataCell(_buildDeleteButton(context, expenseItem)),
      ]);
    }).toList();
  }

  IconButton _buildDeleteButton(
    BuildContext context,
    ExpenseItemFormModel expenseItem,
  ) {
    return IconButton(
      icon: Icon(Icons.delete, color: Colors.red.shade300),
      onPressed: () => _deleteExpenseItem(context, expenseItem),
    );
  }

  void _deleteExpenseItem(
    BuildContext context,
    ExpenseItemFormModel expenseItem,
  ) {
    Provider.of<ExpenseItemsProvider>(context, listen: false)
        .deleteExpenseItem(expenseItem.uuid);
  }
}
