import 'package:flutter/material.dart';

import '../../../data/helpers/color_helper.dart';
import '../../../models/delete_input.dart';

class DeleteConfirmationDialog extends StatefulWidget {
  final VoidCallback? onCancel;

  final Future<void> Function(
    BuildContext context,
    DeleteInput deleteInput,
  )? onConfirm;

  const DeleteConfirmationDialog({super.key, this.onCancel, this.onConfirm});

  @override
  State<DeleteConfirmationDialog> createState() =>
      _DeleteConfirmationDialogState();
}

class _DeleteConfirmationDialogState extends State<DeleteConfirmationDialog> {
  bool deleteExpenses = false;
  bool deleteExpenseItems = false;
  bool deleteCategories = false;
  bool deleteTags = false;

  bool deleteEverything = false;

  final String cancelAction = "Cancel";
  final String confirmAction = "Confirm";

  defaultOnTap() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Color? activeColor = ColorHelper.getToggleColor(theme);
    return AlertDialog(
      backgroundColor: ColorHelper.getTileColor(theme),
      title: _buildDialogTitle(),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text("Please select what's to be deleted"),
          CheckboxListTile(
            activeColor: activeColor,
            title: const Text("Expenses"),
            value: deleteExpenses,
            onChanged: (value) => setState(() {
              deleteExpenses = value!;
            }),
          ),
          CheckboxListTile(
            activeColor: activeColor,
            title: const Text("Expense Items"),
            value: deleteExpenseItems,
            onChanged: (value) => setState(() {
              deleteExpenseItems = value!;
            }),
          ),
          CheckboxListTile(
            activeColor: activeColor,
            title: const Text("Categories"),
            value: deleteCategories,
            onChanged: (value) => setState(() {
              deleteCategories = value!;
            }),
          ),
          CheckboxListTile(
            activeColor: activeColor,
            title: const Text("Tags"),
            value: deleteTags,
            onChanged: (value) => setState(() {
              deleteTags = value!;
            }),
          ),
          CheckboxListTile(
            activeColor: activeColor,
            title: const Text("Delete All"),
            value: deleteEverything,
            onChanged: handleDeleteAll,
          ),
          const Text("Note: Consider Export before proceeding"),
        ],
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
                child: Text(
                  cancelAction,
                  style:
                      TextStyle(color: ColorHelper.getButtonTextColor(theme)),
                ),
                onPressed: () {
                  if (widget.onCancel != null) widget.onCancel!();
                  defaultOnTap();
                }),
            ElevatedButton(
              onPressed: handleConfirmation,
              child: Text(
                confirmAction,
                style: TextStyle(color: ColorHelper.getButtonTextColor(theme)),
              ),
            ),
          ],
        )
      ],
    );
  }

  Row _buildDialogTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Confirm Deletion'),
        IconButton(
          onPressed: _closeFilterDialog,
          icon: const Icon(Icons.clear),
        )
      ],
    );
  }

  void _closeFilterDialog() => Navigator.pop(context);

  void handleDeleteAll(value) => setState(() {
        deleteEverything = value!;
        deleteExpenses = deleteEverything ? true : false;
        deleteExpenseItems = deleteEverything ? true : false;
        deleteCategories = deleteEverything ? true : false;
        deleteTags = deleteEverything ? true : false;
      });

  handleConfirmation() {
    if (widget.onConfirm != null) {
      DeleteInput deleteInput = DeleteInput(
          deleteExpenses: deleteExpenses,
          deleteExpenseItems: deleteExpenseItems,
          deleteCategories: deleteCategories,
          deleteTags: deleteTags);

      widget.onConfirm!(context, deleteInput);
    }
    defaultOnTap();
  }
}
