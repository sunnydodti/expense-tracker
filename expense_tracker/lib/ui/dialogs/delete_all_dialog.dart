import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/delete_input.dart';
import '../../models/delete_output.dart';
import '../../providers/expense_provider.dart';
import '../../service/delete_service.dart';
import '../notifications/snackbar_service.dart';
import 'common/delete_confirmation_dialog.dart';

class DeleteAllDialog extends StatefulWidget {
  const DeleteAllDialog({super.key});

  @override
  State<DeleteAllDialog> createState() => _DeleteAllDialogState();
}

class _DeleteAllDialogState extends State<DeleteAllDialog> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: const Text('Delete'), onTap: _showDeleteConfirmationDialog);
  }

  _showDeleteConfirmationDialog() async {
    showDialog(
      context: context,
      builder: (context) => DeleteConfirmationDialog(
        onConfirm: _handleDelete,
      ),
    );
  }

  Future<void> _handleDelete(
      BuildContext context, DeleteInput deleteInput) async {
    DeleteOutput deleteOutput = await DeleteService.deleteFromDatabase(
        deleteInput,
        refreshMethod: _refreshExpenses);

    if (mounted) {
      if (deleteOutput.totalDeletedCount > 0) {
        String message = _getSnackbarMessage(deleteOutput);
        SnackBarService.showSuccessSnackBarWithContext(context, message,
            duration: 5);
      } else if (deleteOutput.totalDeletedCount == 0) {
        SnackBarService.showSnackBarWithContext(context, "Nothing to Deleted");
      } else {
        SnackBarService.showErrorSnackBarWithContext(context, "Delete Failed");
      }
    }
  }

  _refreshExpenses() {
    final expenseProvider =
        Provider.of<ExpenseProvider>(context, listen: false);
    expenseProvider.refreshExpenses();
  }

  String _getSnackbarMessage(DeleteOutput deleteOutput) {
    String message = "${deleteOutput.totalDeletedCount} items Deleted";
    if (deleteOutput.expenses) {
      message += "\nExpenses:       ${deleteOutput.expenseCount}";
    }
    if (deleteOutput.expenseItems) {
      message += "\nExpense Items:  ${deleteOutput.expenseItemsCount}";
    }
    if (deleteOutput.categories) {
      message += "\nCategories:     ${deleteOutput.categoriesCount}";
    }
    if (deleteOutput.tags) {
      message += "\nTags:           ${deleteOutput.tagsCount}";
    }
    return message;
  }
}
