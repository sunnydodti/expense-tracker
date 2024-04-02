import 'package:expense_tracker/providers/expense_provider.dart';
import 'package:expense_tracker/service/expense_service.dart';
import 'package:expense_tracker/ui/notifications/snackbar_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeDrawer extends StatefulWidget {
  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  bool _isDeleteDialogVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Menu'),
            ),
            ListTile(
              title: const Text('Delete'),
              onTap: () {
                // Navigator.pop(context);
                setState(() {
                  _isDeleteDialogVisible = true;
                });
              },
            ),
            ListTile(
              title: const Text('Export'),
              onTap: () {
                // Handle Export option
              },
            ),
            ListTile(
              title: const Text('Settings'),
              onTap: () {
                // Handle Settings option
              },
            ),
            if (_isDeleteDialogVisible)
              _buildDeleteConfirmationDialog(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDeleteConfirmationDialog(BuildContext context) {
    return AlertDialog(
      title: const Text("Confirmation"),
      content: const Text("Are you sure you want to delete?"),
      actions: <Widget>[
        TextButton(
          child: const Text("Cancel"),
          onPressed: () {
            Navigator.pop(context);
            SnackBarService.showSnackBarWithContext(context, "Not Deleted");
            setState(() {
              _isDeleteDialogVisible = false;
            });
          },
        ),
        TextButton(
          child: const Text("Delete"),
          onPressed: () async {
            Navigator.pop(context);
            await _handleDelete(context);
          },
        ),
      ],
    );
  }

  Future<void> _handleDelete(BuildContext context) async {
    int deleteCount = await _deleteFromDatabase(context);
    if (deleteCount > 0)
      SnackBarService.showSuccessSnackBarWithContext(context, "All Expenses Deleted");
    else if (deleteCount == 0)
      SnackBarService.showSnackBarWithContext(context, "Nothing to Deleted");
    else
      SnackBarService.showErrorSnackBarWithContext(context, "Delete Failed");

    setState(() {
      _isDeleteDialogVisible = false;
    });
  }

  Future<int> _deleteFromDatabase(BuildContext context) async {
    ExpenseService expenseService = ExpenseService();
    int result = await expenseService.deleteAllExpenses();
    if (result > 0) {
      _refreshExpenses();
    }
    return result;
  }

  _refreshExpenses() {
    final expenseProvider = Provider.of<ExpenseProvider>(context, listen: false);
    expenseProvider.refreshExpenses();
  }
}
