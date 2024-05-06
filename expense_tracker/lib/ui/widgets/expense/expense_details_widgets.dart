import 'package:flutter/material.dart';

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
      int expenseId, Function(int exenseId) fetchMethod, int i) {
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
          _fetchAndBuildExpenseItemsList(expenseId, fetchMethod),
        ],
      ),
    );
  }

  FutureBuilder _fetchAndBuildExpenseItemsList(
      int expenseId, Function(int expenseId) fetchMethod) {
    return FutureBuilder(
        future: fetchMethod(expenseId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return buildExpenseItemsList(snapshot.data);
          }
        });
  }

  Container buildExpenseItemsList(List<ExpenseItemFormModel> expenseItems) {
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
          rows: _buildDataRows(expenseItems),
        ),
      ),
    );
  }

  List<DataRow> _buildDataRows(List<ExpenseItemFormModel> expenseItems) {
    return expenseItems.map((expenseItem) {
      return DataRow(cells: [
        DataCell(Text(expenseItem.name)),
        DataCell(Text('${expenseItem.amount.round()}')),
        DataCell(Text('${expenseItem.quantity}')),
        DataCell(Text('${expenseItem.total.round()}')),
      ]);
    }).toList();
  }
}
