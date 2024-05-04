import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../models/expense.dart';
import '../../../models/expense_item.dart';
import '../../../providers/expense_items_provider.dart';
import '../../animations/blur_screen.dart';
import '../../animations/scale_up.dart';

class ExpensePopup extends StatefulWidget {
  final Expense expense;

  const ExpensePopup({super.key, required this.expense});

  @override
  State<ExpensePopup> createState() => _ExpensePopupState();
}

class _ExpensePopupState extends State<ExpensePopup> {
  final double paddingTop = 5;
  final double paddingBottom = 5;
  final double paddingHorizontal = 5;

  @override
  void initState() {
    super.initState();

    // if (widget.expense.containsExpenseItems){
    //   if (mounted) {
    //     final expenseItemProvider =
    //     Provider.of<ExpenseItemsProvider>(context, listen: false);
    //     expenseItemProvider.fetchExpenseItems(expenseId: expense.id);
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const BlurScreen(),
        ScaleUp(child: buildExpensePopup()),
      ],
    );
  }

  Container buildExpensePopup() {
    return Container(
      width: 500,
      margin: const EdgeInsets.only(left: 40, right: 40, top: 75),
      child: Card(
        color: Colors.grey.shade700,
        child: Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          color: Colors.grey.shade800,
          child: buildExpensePopUpContent(widget.expense),
        ),
      ),
    );
  }

  Column buildExpensePopUpContent(Expense expense) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(expense.title),
        _buildDivider(),
        _buildAmountRow(expense, 1),
        _buildDateRow(expense, 0),
        _buildTransactionTypeRow(expense, 1),
        _buildCategoryRow(expense, 0),
        _buildTagsRow(expense, 1),
        _buildCreatedDateRow(expense, 0),
        _buildModifiedDateRow(expense, 1),
        _buildNotesColumn(expense, 0),
        if (expense.containsExpenseItems) _buildExpenseItemsColumn(expense, 1),
      ],
    );
  }

  Container _buildKeyValRow(String key, String value, int i) {
    Color rowColor = Colors.white10.withOpacity(.1);
    if (i == 1) rowColor = Colors.white10.withOpacity(.05);
    return Container(
      color: rowColor,
      padding: _buildPadding(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text("$key:"),
          Text(value),
        ],
      ),
    );
  }

  Container _buildAmountRow(Expense expense, int i) {
    return _buildKeyValRow("Amount", "${expense.amount.round()}", i);
  }

  Container _buildDateRow(Expense expense, int i) {
    return _buildKeyValRow(
        "Date", DateFormat("dd MMM yyy").format(expense.date), i);
  }

  Container _buildTransactionTypeRow(Expense expense, int i) {
    return _buildKeyValRow("Transaction Type", expense.transactionType, i);
  }

  Container _buildCategoryRow(Expense expense, int i) {
    return _buildKeyValRow("Category", expense.category, i);
  }

  Container _buildTagsRow(Expense expense, int i) {
    return _buildKeyValRow("Tags", expense.tags!, i);
  }

  Container _buildCreatedDateRow(Expense expense, int i) {
    return _buildKeyValRow("Created",
        DateFormat("HH:mm | dd MMM yyy").format(expense.createdAt), i);
  }

  Container _buildModifiedDateRow(Expense expense, int i) {
    return _buildKeyValRow("Modified",
        DateFormat("HH:mm | dd MMM yyy").format(expense.modifiedAt), i);
  }

  Container _buildNotesColumn(Expense expense, int i) {
    Color rowColor = Colors.white10.withOpacity(.1);
    if (i == 1) rowColor = Colors.white10.withOpacity(.05);
    return Container(
      width: double.infinity,
      color: rowColor,
      padding: _buildPadding(),
      child: Column(
        children: <Widget>[
          Row(
            children: const [
              Text("Notes:"),
            ],
          ),
          if (expense.note != null && expense.note!.isNotEmpty)
            const Divider(
              thickness: .8,
              indent: 8,
              endIndent: 8,
            ),
          if (expense.note != null && expense.note!.isNotEmpty)
            Text(expense.note!,
                maxLines: 5,
                overflow: TextOverflow.fade,
                textAlign: TextAlign.end),
        ],
      ),
    );
  }

  Container _buildExpenseItemsColumn(Expense expense, int i) {
    Color rowColor = Colors.white10.withOpacity(.1);
    if (i == 1) rowColor = Colors.white10.withOpacity(.05);
    return Container(
      width: double.infinity,
      color: rowColor,
      padding: _buildPadding(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: const [
              Text("Expense Items:"),
            ],
          ),
          const Divider(
            thickness: .8,
            indent: 8,
            endIndent: 8,
          ),
          _fetchAndBuildExpenseItemsList(expense),
        ],
      ),
    );
  }

  FutureBuilder _fetchAndBuildExpenseItemsList(Expense expense) {
    return FutureBuilder(
        future: _refreshExpenseItems(expense),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return _buildExpenseItemsList(snapshot.data);
          }
        });
  }

  Container _buildExpenseItemsList(List<ExpenseItemFormModel> expenseItems) {
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

  Future<List<ExpenseItemFormModel>> _refreshExpenseItems(
      Expense expense) async {
    final expenseItemsProvider =
        Provider.of<ExpenseItemsProvider>(context, listen: false);
    await expenseItemsProvider.fetchExpenseItems(expenseId: expense.id);
    // await Future.delayed(const Duration(milliseconds: 300));
    return expenseItemsProvider.expenseItems;
  }

  Divider _buildDivider() {
    return const Divider(
      thickness: 1.5,
    );
  }

  EdgeInsets _buildPadding() {
    return EdgeInsets.only(
        top: paddingTop,
        bottom: paddingBottom,
        left: paddingHorizontal,
        right: paddingHorizontal);
  }
}
