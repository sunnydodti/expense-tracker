import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/expense.dart';
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
        _buildNotesColumn(expense, 0),
        _buildCreatedDateRow(expense, 1),
        _buildModifiedDateRow(expense, 0),
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

  Container _buildCreatedDateRow(Expense expense, int i) {
    return _buildKeyValRow("Created",
        DateFormat("HH:mm | dd MMM yyy").format(expense.createdAt), i);
  }

  Container _buildModifiedDateRow(Expense expense, int i) {
    return _buildKeyValRow("Modified",
        DateFormat("HH:mm | dd MMM yyy").format(expense.modifiedAt), i);
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
