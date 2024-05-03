import 'package:flutter/material.dart';

import '../../../models/delete_input.dart';

class DeleteConfirmationDialog extends StatefulWidget {
  VoidCallback? onCancel;
  final Future<void> Function(
    BuildContext context,
    DeleteInput deleteInput,
  )? onConfirm;

  DeleteConfirmationDialog({super.key, this.onCancel, this.onConfirm});

  @override
  State<DeleteConfirmationDialog> createState() =>
      _DeleteConfirmationDialogState();
}

class _DeleteConfirmationDialogState extends State<DeleteConfirmationDialog> {
  bool deleteExpenses = false;
  bool deleteExpenseItems = false;
  bool deleteCategories = false;
  bool deleteTags = false;

  final String cancelAction = "Cancel";
  final String confirmAction = "Confirm";

  defaultOnTap() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Confirm Deletion"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Please select what's to be deleted"),
          CheckboxListTile(
            title: const Text("Expenses"),
            value: deleteExpenses,
            onChanged: (value) => setState(() {
              deleteExpenses = value!;
            }),
          ),
          CheckboxListTile(
            title: const Text("Expense Items"),
            value: deleteExpenseItems,
            onChanged: (value) => setState(() {
              deleteExpenseItems = value!;
            }),
          ),
          CheckboxListTile(
            title: const Text("Categories"),
            value: deleteCategories,
            onChanged: (value) => setState(() {
              deleteCategories = value!;
            }),
          ),
          CheckboxListTile(
            title: const Text("Tags"),
            value: deleteTags,
            onChanged: (value) => setState(() {
              deleteTags = value!;
            }),
          ),
          const Text("Note: Consider Export before proceeding"),
        ],
      ),
      actions: <Widget>[
        TextButton(
            child: Text(cancelAction),
            onPressed: () {
              if (widget.onCancel != null) widget.onCancel!();
              defaultOnTap();
            }),
        TextButton(
          onPressed: handleConfirmation,
          child: Text(confirmAction),
        ),
      ],
    );
  }

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
