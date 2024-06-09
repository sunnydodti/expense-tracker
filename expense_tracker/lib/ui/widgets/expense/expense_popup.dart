import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../data/helpers/color_helper.dart';
import '../../../models/enums/transaction_type.dart';
import '../../../models/expense.dart';
import '../../../models/expense_item.dart';
import '../../../providers/expense_items_provider.dart';
import '../../../utils/expense_utils.dart';
import '../../animations/blur_screen.dart';
import '../../animations/scale_up.dart';
import 'expense_widgets.dart';

class ExpensePopup extends StatefulWidget {
  final Expense expense;
  final VoidCallback? onOutsideTap;

  const ExpensePopup({super.key, required this.expense, this.onOutsideTap});

  @override
  State<ExpensePopup> createState() => _ExpensePopupState();
}

class _ExpensePopupState extends State<ExpensePopup> {
  ExpenseItemsProvider get expenseItemsProvider =>
      Provider.of<ExpenseItemsProvider>(context, listen: false);

  defaultOnTap() {}

  Color getBlurColor() {
    if (widget.expense.transactionType == TransactionType.expense.name) {
      return Colors.red;
    }
    if (widget.expense.transactionType == TransactionType.income.name) {
      return Colors.green;
    }
    return Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BlurScreen(
            onTap: widget.onOutsideTap ?? defaultOnTap,
            color: getBlurColor(),
            colorOpacity: .1),
        ScaleUp(child: buildExpensePopup(context)),
      ],
    );
  }

  Center buildExpensePopup(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 550),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Card(
            color: ColorHelper.getBackgroundColor(Theme.of(context)),
            margin: const EdgeInsets.all(10),
            child: Card(
              margin: const EdgeInsets.all(10),
              // padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              color: ColorHelper.getTileColor(Theme.of(context)),
              child: buildExpensePopUpContent(widget.expense),
            ),
          ),
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
      "Amount",
      getExpenseAmountText(expense),
      i,
      context,
      valueColor: getAmountColor(expense.transactionType),
    );
  }

  Container _buildDateRow(Expense expense, int i) {
    return ExpenseWidgets.detail.buildKeyValRow(
      "Date",
      DateFormat("dd MMM yyy").format(expense.date),
      i,
      context,
    );
  }

  Container _buildTransactionTypeRow(Expense expense, int i) {
    return ExpenseWidgets.detail.buildKeyValRow(
      "Transaction Type",
      expense.transactionType,
      i,
      context,
    );
  }

  Container _buildCategoryRow(Expense expense, int i) {
    return ExpenseWidgets.detail.buildKeyValRow(
      "Category",
      expense.category,
      i,
      context,
    );
  }

  Container _buildTagsRow(Expense expense, int i) {
    return ExpenseWidgets.detail.buildKeyValRow(
      "Tags",
      expense.tags!,
      i,
      context,
    );
  }

  Container _buildCreatedDateRow(Expense expense, int i) {
    return ExpenseWidgets.detail.buildKeyValRow("Created",
      DateFormat("HH:mm | dd MMM yyy").format(expense.createdAt),
      i,
      context,
    );
  }

  Container _buildModifiedDateRow(Expense expense, int i) {
    return ExpenseWidgets.detail.buildKeyValRow("Modified",
      DateFormat("HH:mm | dd MMM yyy").format(expense.modifiedAt),
      i,
      context,
    );
  }

  Container _buildNotesColumn(Expense expense, int i) {
    return ExpenseWidgets.detail.buildNotesKeyValColumn(
      "Notes",
      expense.note,
      i,
      context,
    );
  }

  Container _buildExpenseItemsColumn(Expense expense, int i) {
    return ExpenseWidgets.detail.buildExpenseItemsColumn(
      expense,
      _refreshExpenseItems,
      i,
      context,
    );
  }

  Future<List<ExpenseItemFormModel>> _refreshExpenseItems(int expenseId) async {
    await expenseItemsProvider.fetchExpenseItems(expenseId: expenseId);
    return expenseItemsProvider.expenseItems;
  }

  Divider _buildDivider() {
    return const Divider(
      thickness: 1.5,
    );
  }
}
