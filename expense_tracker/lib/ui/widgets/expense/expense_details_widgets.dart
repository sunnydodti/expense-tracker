import 'package:flutter/material.dart';

import '../../../data/constants/ui_constants.dart';
import '../../../models/expense.dart';
import '../../../models/expense_item.dart';
import '../../../utils/expense_utils.dart';
import '../../screens/widget_constants.dart';
import '../common/scaled_text.dart';

class ExpenseDetailsWidgets {
  final double paddingTop = uiPaddingHalf;
  final double paddingBottom = uiPaddingHalf;
  final double paddingHorizontal = uiPaddingHalf;

  EdgeInsets _buildPadding() {
    return EdgeInsets.only(
        top: paddingTop,
        bottom: paddingBottom,
        left: paddingHorizontal,
        right: paddingHorizontal);
  }

  Color _getColor(int i, BuildContext context) {
    ThemeData theme = Theme.of(context);
    Brightness brightness = theme.brightness;
    double opacity0 = (brightness == Brightness.dark) ? .05 : .1;
    double opacity1 = (brightness == Brightness.dark) ? .1 : .3;
    Color rowColor = (i == 1)
        ? Colors.white.withValues(alpha: opacity1)
        : Colors.white.withValues(alpha: opacity0);
    return rowColor;
  }

  Container buildKeyValRow(
      String key, String value, int i, BuildContext context,
      {Color? valueColor}) {
    Color rowColor = _getColor(i, context);
    return Container(
      color: rowColor,
      padding: _buildPadding(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ScaledText("$key:"),
          ScaledText(value, style: TextStyle(color: valueColor)),
        ],
      ),
    );
  }

  Container buildNotesKeyValColumn(
    String key,
    String? value,
    int i,
    BuildContext context,
  ) {
    Color rowColor = _getColor(i, context);
    return Container(
      width: double.infinity,
      color: rowColor,
      padding: _buildPadding(),
      child: Column(
        children: <Widget>[
          Row(children: <Widget>[ScaledText("$key:")]),
          if (value != null && value.isNotEmpty) wcDividerIndented,
          if (value != null && value.isNotEmpty)
            ScaledText(value,
                maxLines: 5,
                overflow: TextOverflow.fade,
                textAlign: TextAlign.start),
        ],
      ),
    );
  }

  Container buildExpenseItemsColumn(
    Expense expense,
    Function(int exenseId) fetchMethod,
    int i,
    BuildContext context,
  ) {
    Color rowColor = _getColor(i, context);
    return Container(
      width: double.infinity,
      color: rowColor,
      padding: _buildPadding(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Row(children: <Widget>[ScaledText("Expense Items:")]),
          wcDividerIndented,
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
            return wcSpinnerDefault;
          }
          if (snapshot.hasError) {
            return wcSnapshotErrorText(snapshot.error);
          }
          return buildExpenseItemsList(snapshot.data, expense, context);
        });
  }

  Container buildExpenseItemsList(List<ExpenseItemFormModel> expenseItems,
      Expense expense, BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 250),
      child: SingleChildScrollView(
        child: DataTable(
          columnSpacing: uiSizeX2,
          dataRowMinHeight: uiDataRowSize,
          dataRowMaxHeight: uiDataRowSize,
          columns: const [
            DataColumn(label: ScaledText('Name')),
            DataColumn(label: ScaledText('Amt')),
            DataColumn(label: ScaledText('Qty')),
            DataColumn(label: ScaledText('Total')),
          ],
          rows: [
            ..._buildDataRows(expenseItems),
            _buildTotalRow(expenseItems, expense, context),
          ],
        ),
      ),
    );
  }

  List<DataRow> _buildDataRows(List<ExpenseItemFormModel> expenseItems) {
    var dataRows = expenseItems.map((expenseItem) {
      return DataRow(cells: [
        DataCell(ScaledText(expenseItem.name)),
        DataCell(ScaledText('${expenseItem.amount.round()}')),
        DataCell(ScaledText('${expenseItem.quantity}')),
        DataCell(ScaledText('${expenseItem.total.round()}')),
      ]);
    });

    return dataRows.toList();
  }

  DataRow _buildTotalRow(List<ExpenseItemFormModel> expenseItems,
      Expense expense, BuildContext context) {
    double overallTotal =
        expenseItems.fold(0, (prev, curr) => prev + curr.total);
    Color color = getAmountColor(expense.transactionType, context);
    return DataRow(cells: [
      const DataCell(
        ScaledText('Total', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      const DataCell(ScaledText('')),
      DataCell(
        ScaledText(
          getAmountText(overallTotal, expense.transactionType, expense.currency,
              includeAmount: false),
          style: TextStyle(color: color),
        ),
      ),
      DataCell(
        ScaledText(
          '${overallTotal.round()}',
          style: TextStyle(fontWeight: FontWeight.bold, color: color),
        ),
      ),
    ]);
  }
}
