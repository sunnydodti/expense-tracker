import 'package:expense_tracker/models/ExportResult.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/expense_provider.dart';
import '../../service/expense_service.dart';
import '../../service/export_service.dart';
import '../notifications/snackbar_service.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({super.key});

  @override
  HomeDrawerState createState() => HomeDrawerState();
}

class HomeDrawerState extends State<HomeDrawer> {
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
              onTap: () => _exportExpenses(context),
            ),
            ListTile(
              title: const Text('Settings'),
              onTap: () => {},
            ),
            if (_isDeleteDialogVisible) _buildDeleteConfirmationDialog(context),
          ],
        ),
      ),
    );
  }

  void _exportExpenses(BuildContext context) {
    Navigator.pop(context);
    ExportService exportService = ExportService();
    exportService.exportAllExpensesToJson().then((ExportResult result) => {
    if (result.result) SnackBarService.showSuccessSnackBarWithContext(context, "${result.message} path:${result.outputPath}", duration: 5)
      else SnackBarService.showErrorSnackBarWithContext(context, result.message)
    });
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
    if (mounted) {
      // Check if widget is still mounted
      if (deleteCount > 0) {
        SnackBarService.showSuccessSnackBarWithContext(
            context, "All Expenses Deleted");
      } else if (deleteCount == 0) {
        SnackBarService.showSnackBarWithContext(context, "Nothing to Deleted");
      } else {
        SnackBarService.showErrorSnackBarWithContext(context, "Delete Failed");
      }
    }

    setState(() {
      _isDeleteDialogVisible = false;
    });
  }

  Future<int> _deleteFromDatabase(BuildContext context) async {
    ExpenseService expenseService = await ExpenseService.create();
    int result = await expenseService.deleteAllExpenses();
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
