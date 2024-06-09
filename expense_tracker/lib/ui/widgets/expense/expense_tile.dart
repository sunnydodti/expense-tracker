import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/helpers/color_helper.dart';
import '../../../data/helpers/navigation_helper.dart';
import '../../../models/expense.dart';
import '../../../providers/expense_items_provider.dart';
import '../../../providers/expense_provider.dart';
import '../../bottom_sheets/expense_bottom_sheet.dart';
import 'expense_popup.dart';
import 'expense_widgets.dart';

class ExpenseTile extends StatefulWidget {
  final Expense expense;
  final VoidCallback editCallBack;
  final Future<int> Function() deleteCallBack;

  const ExpenseTile({
    Key? key,
    required this.expense,
    required this.editCallBack,
    required this.deleteCallBack,
  }) : super(key: key);

  @override
  State<ExpenseTile> createState() => _ExpenseTileState();
}

class _ExpenseTileState extends State<ExpenseTile> {
  bool showPopup = false;
  OverlayEntry? overlayEntry;

  void showOverlay() {
    overlayEntry = OverlayEntry(
      builder: (context) => ExpensePopup(expense: widget.expense),
    );
    Overlay.of(context)?.insert(overlayEntry!);
  }

  void hideOverlay() {
    overlayEntry?.remove();
    overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (details) =>
          // expenseProvider.showExpensePopup(widget.expense),
          showOverlay(),
      onLongPressEnd: (details) {
        hideOverlay();
        expenseItemsProvider.clear();
        expenseProvider.hideExpensePopup();
      },
      onTap: _buildBottomSheet,
      onDoubleTap: widget.editCallBack,
      child: Card(
        color: ColorHelper.getTileColor(Theme.of(context)),
        margin: const EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
        child: _buildExpenseTile(),
      ),
    );
  }

  void _buildBottomSheet() {
    ExpenseBottomSheet.show(context, widget.expense,
        deleteCallBack: widget.deleteCallBack,
        editCallBack: widget.editCallBack,
        viewCallBack: viewExpense);
  }

  void viewExpense() {
    NavigationHelper.navigateToRoute(
        context,
        ExpensePopup(
            expense: widget.expense,
            onOutsideTap: () => NavigationHelper.navigateBack(context)));
  }

  Padding _buildExpenseTile() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Column(
        children: [
          Row(
            children: [
              ExpenseWidgets.tile.titleWidget(widget.expense),
              ExpenseWidgets.tile.categoryWidget(widget.expense),
              ExpenseWidgets.tile.getExpenseDate(widget.expense),
            ],
          ),
          const SizedBox(height: 5.0),
          Row(
            children: [
              ExpenseWidgets.tile.tagsWidget(widget.expense),
            ],
          ),
          const SizedBox(height: 2),
          const Divider(height: 5, thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ExpenseWidgets.tile.noteWidget(widget.expense),
              ExpenseWidgets.tile.amountWidget(widget.expense),
            ],
          ),
        ],
      ),
    );
  }

  ExpenseProvider get expenseProvider =>
      Provider.of<ExpenseProvider>(context, listen: false);

  ExpenseItemsProvider get expenseItemsProvider =>
      Provider.of<ExpenseItemsProvider>(context, listen: false);
}
