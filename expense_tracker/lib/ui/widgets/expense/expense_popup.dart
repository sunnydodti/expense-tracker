import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../models/expense.dart';
import '../../../models/expense_item.dart';
import '../../../providers/expense_items_provider.dart';
import '../../../utils/expense_utils.dart';
import '../../animations/blur_screen.dart';
import '../../animations/scale_up.dart';
import 'expense_widgets.dart';

class ExpensePopup extends StatefulWidget {
  final Expense expense;

  const ExpensePopup({super.key, required this.expense});

  @override
  State<ExpensePopup> createState() => _ExpensePopupState();
}

class _ExpensePopupState extends State<ExpensePopup> {
  @override
  void initState() {
    super.initState();
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

  Container _buildAmountRow(Expense expense, int i) {
    return ExpenseWidgets.detail.buildKeyValRow(
        "Amount", getAmountText(expense), i,
        valueColor: getAmountColor(expense.transactionType));
  }

  Container _buildDateRow(Expense expense, int i) {
    return ExpenseWidgets.detail.buildKeyValRow(
        "Date", DateFormat("dd MMM yyy").format(expense.date), i);
  }

  Container _buildTransactionTypeRow(Expense expense, int i) {
    return ExpenseWidgets.detail
        .buildKeyValRow("Transaction Type", expense.transactionType, i);
  }

  Container _buildCategoryRow(Expense expense, int i) {
    return ExpenseWidgets.detail
        .buildKeyValRow("Category", expense.category, i);
  }

  Container _buildTagsRow(Expense expense, int i) {
    return ExpenseWidgets.detail.buildKeyValRow("Tags", expense.tags!, i);
  }

  Container _buildCreatedDateRow(Expense expense, int i) {
    return ExpenseWidgets.detail.buildKeyValRow("Created",
        DateFormat("HH:mm | dd MMM yyy").format(expense.createdAt), i);
  }

  Container _buildModifiedDateRow(Expense expense, int i) {
    return ExpenseWidgets.detail.buildKeyValRow("Modified",
        DateFormat("HH:mm | dd MMM yyy").format(expense.modifiedAt), i);
  }

  Container _buildNotesColumn(Expense expense, int i) {
    return ExpenseWidgets.detail
        .buildNotesKeyValColumn("Notes", expense.note, i);
  }

  Container _buildExpenseItemsColumn(Expense expense, int i) {
    return ExpenseWidgets.detail
        .buildExpenseItemsColumn(expense.id, _refreshExpenseItems, i);
  }

  Future<List<ExpenseItemFormModel>> _refreshExpenseItems(int expenseId) async {
    final expenseItemsProvider =
        Provider.of<ExpenseItemsProvider>(context, listen: false);
    await expenseItemsProvider.fetchExpenseItems(expenseId: expenseId);
    // await Future.delayed(const Duration(milliseconds: 300));
    return expenseItemsProvider.expenseItems;
  }

  Divider _buildDivider() {
    return const Divider(
      thickness: 1.5,
    );
  }
}
