import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/expense_provider.dart';
import '../../service/category_service.dart';
import '../../service/expense_service.dart';
import '../../service/tag_service.dart';
import '../notifications/snackbar_service.dart';
import 'confirmation_dialog.dart';

class DeleteAllTile extends StatefulWidget {
  const DeleteAllTile({super.key});

  @override
  State<DeleteAllTile> createState() => _DeleteAllTileState();
}

class _DeleteAllTileState extends State<DeleteAllTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: const Text('Delete'), onTap: _showDeleteConfirmationDialog);
  }

  _showDeleteConfirmationDialog() async {
    String content =
        "Are you sure you want to delete all data? This includes:\n"
        "\n\t All Expenses"
        "\n\t All Categories"
        "\n\t All Tags"
        "\n\nNote: Consider Export before proceeding";
    ConfirmationDialog deleteConfirmationDialog = ConfirmationDialog(
        title: "Confirm Deletion",
        content: content,
        onConfirm: () => _handleDelete(context));

    showDialog(
      context: context,
      builder: (context) => deleteConfirmationDialog,
    );
  }

  Future<void> _handleDelete(BuildContext context) async {
    int deleteCount = await _deleteFromDatabase();
    if (mounted) {
      if (deleteCount > 0) {
        SnackBarService.showSuccessSnackBarWithContext(
            context, "All Expenses Deleted");
      } else if (deleteCount == 0) {
        SnackBarService.showSnackBarWithContext(context, "Nothing to Deleted");
      } else {
        SnackBarService.showErrorSnackBarWithContext(context, "Delete Failed");
      }
    }
  }

  Future<int> _deleteFromDatabase() async {
    ExpenseService expenseService = await ExpenseService.create();
    CategoryService categoryService = await CategoryService.create();
    TagService tagService = await TagService.create();
    int result = 0;
    result += await expenseService.deleteAllExpenses();
    result += await categoryService.deleteAllCategories();
    result += await tagService.deleteAllTags();
    if (result > 0) {
      _refreshExpenses();
    }
    return result;
  }

  _refreshExpenses() {
    final expenseProvider =
        Provider.of<ExpenseProvider>(context, listen: false);
    expenseProvider.refreshExpenses();
  }
}
