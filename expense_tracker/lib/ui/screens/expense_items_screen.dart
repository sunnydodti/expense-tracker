import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/helpers/color_helper.dart';
import '../../data/helpers/navigation_helper.dart';
import '../../models/expense_item.dart';
import '../../providers/expense_items_provider.dart';
import '../animations/blur_screen.dart';
import '../animations/scale_up.dart';
import '../forms/expense/expense_item_form.dart';

class ExpenseItemsScreen extends StatefulWidget {
  final String currency;
  final String expenseTitle;

  const ExpenseItemsScreen(
      {super.key, required this.currency, this.expenseTitle = ""});

  @override
  State<ExpenseItemsScreen> createState() => _ExpenseItemsScreenState();
}

class _ExpenseItemsScreenState extends State<ExpenseItemsScreen> {
  onOutsideTap() {
    NavigationHelper.navigateBack(context);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        BlurScreen(onTap: onOutsideTap),
        ScaleUp(child: buildExpenseItemsScreen()),
      ],
    );
  }

  Card buildExpenseItemsScreen() {
    String title = "Expense Items";
    if (widget.expenseTitle.isNotEmpty) title += " for ${widget.expenseTitle}";
    return Card(
      color: ColorHelper.getTileColor(Theme.of(context)),
      margin: const EdgeInsets.only(left: 40, right: 40, top: 90),
      child: Card(
        color: ColorHelper.getBackgroundColor(Theme.of(context)),
        margin: const EdgeInsets.all(10),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(title),
                _buildDivider(),
                ExpenseItemForm(
                  currency: widget.currency,
                ),
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
          buildExpenseItemsList(expenseItemsProvider.expenseItems),
    );
  }

  Container buildExpenseItemsList(List<ExpenseItemFormModel> expenseItems) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 800),
      child: SingleChildScrollView(
        child: DataTable(
          columnSpacing: 15,
          dataRowHeight: 35,
          columns: const [
            DataColumn(
              label: Text('Name'),
            ),
            DataColumn(label: Text('Amt')),
            DataColumn(label: Text('Qty')),
            DataColumn(label: Text('Total')),
            DataColumn(label: Text('')),
          ],
          rows: _buildDataRows(expenseItems),
        ),
      ),
    );
  }

  List<DataRow> _buildDataRows(List<ExpenseItemFormModel> expenseItems) {
    return expenseItems.map((expenseItem) {
      return DataRow(cells: [
        DataCell(Text(expenseItem.name)),
        DataCell(Text('${widget.currency}${expenseItem.amount.round()}')),
        DataCell(Text('${expenseItem.quantity}')),
        DataCell(Text('${widget.currency}${expenseItem.total.round()}')),
        DataCell(_buildDeleteButton(expenseItem)),
      ]);
    }).toList();
  }

  IconButton _buildDeleteButton(ExpenseItemFormModel expenseItem) {
    return IconButton(
      icon: Icon(Icons.delete, color: Colors.red.shade300),
      onPressed: () => deleteExpenseItem(expenseItem),
    );
  }

  deleteExpenseItem(ExpenseItemFormModel expenseItem) {
    Provider.of<ExpenseItemsProvider>(context, listen: false)
        .deleteExpenseItem(expenseItem.uuid);
  }

  Divider _buildDivider() {
    return const Divider(
      thickness: 1.5,
    );
  }
}
