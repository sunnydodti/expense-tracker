import 'package:expense_tracker/utils/expense_utils.dart';
import 'package:flutter/material.dart';

import '../../../models/expense.dart';
import '../../../models/expense_item.dart';

class ExpenseDetailsWidgets {
  final double paddingTop = 5;
  final double paddingBottom = 5;
  final double paddingHorizontal = 5;

  EdgeInsets _buildPadding() {
    return EdgeInsets.only(
        top: paddingTop,
        bottom: paddingBottom,
        left: paddingHorizontal,
        right: paddingHorizontal);
  }

  Color _getColor(int i) {
    Color rowColor = Colors.white10.withOpacity(.1);
    if (i == 1) rowColor = Colors.white10.withOpacity(.05);
    return rowColor;
  }

  Container buildKeyValRow(String key, String value, int i,
      {Color? valueColor}) {
    Color rowColor = _getColor(i);
    return Container(
      color: rowColor,
      padding: _buildPadding(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text("$key:"),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Container buildNotesKeyValColumn(String key, String? value, int i) {
    Color rowColor = _getColor(i);
    return Container(
      width: double.infinity,
      color: rowColor,
      padding: _buildPadding(),
      child: Column(
        children: <Widget>[
          Row(children: <Widget>[Text("$key:")]),
          if (value != null && value.isNotEmpty)
            const Divider(
              thickness: .8,
              indent: 8,
              endIndent: 8,
            ),
          if (value != null && value.isNotEmpty)
            Text(value,
                maxLines: 5,
                overflow: TextOverflow.fade,
                textAlign: TextAlign.end),
        ],
      ),
    );
  }

  Container buildExpenseItemsColumn(
      Expense expense, Function(int exenseId) fetchMethod, int i) {
    Color rowColor = Colors.white10.withOpacity(.1);
    if (i == 1) rowColor = Colors.white10.withOpacity(.05);
    return Container(
      width: double.infinity,
      color: rowColor,
      padding: _buildPadding(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(children: const <Widget>[Text("Expense Items:")]),
          const Divider(thickness: .8, indent: 8, endIndent: 8),
          _fetchAndBuildExpenseItemsList(expense, fetchMethod),
        ],
      ),
    );
  }

  FutureBuilder _fetchAndBuildExpenseItemsList(
      Expense expense, Function(int expenseId) fetchMethod) {
    return FutureBuilder(
        future: fetchMethod(expense.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return buildExpenseItemsList(snapshot.data, expense);
          }
        });
  }

  Container buildExpenseItemsList(
      List<ExpenseItemFormModel> expenseItems, Expense expense) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 200),
      child: SingleChildScrollView(
        child: DataTable(
          columnSpacing: 15,
          dataRowHeight: 35,
          columns: const [
            DataColumn(
              label: Text('Name'),
            ),
            DataColumn(label: Text('Amount')),
            DataColumn(label: Text('Quantity')),
            DataColumn(label: Text('Total')),
          ],
          rows: [
            ..._buildDataRows(expenseItems),
            _buildTotalRow(expenseItems, expense),
          ],
        ),
      ),
    );
  }

  List<DataRow> _buildDataRows(List<ExpenseItemFormModel> expenseItems) {
    var dataRows = expenseItems.map((expenseItem) {
      return DataRow(cells: [
        DataCell(Text(expenseItem.name)),
        DataCell(Text('${expenseItem.amount.round()}')),
        DataCell(Text('${expenseItem.quantity}')),
        DataCell(Text('${expenseItem.total.round()}')),
      ]);
    });

    return dataRows.toList();
  }

  DataRow _buildTotalRow(
      List<ExpenseItemFormModel> expenseItems, Expense expense) {
    double overallTotal =
        expenseItems.fold(0, (prev, curr) => prev + curr.total);
    Color color = getAmountColor(expense.transactionType);
    return DataRow(cells: [
      const DataCell(
          Text('Total', style: TextStyle(fontWeight: FontWeight.bold))),
      const DataCell(Text('')),
      DataCell(
        Text(
          getAmountText(overallTotal, expense.transactionType, expense.currency,
              includeAmount: false),
          style: TextStyle(color: color),
        ),
      ),
      DataCell(
        Text(
          '${overallTotal.round()}',
          style: TextStyle(fontWeight: FontWeight.bold, color: color),
        ),
      ),
    ]);
  }
}
