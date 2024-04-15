import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/expense_provider.dart';
import '../../service/category_service.dart';
import '../../service/expense_service.dart';
import '../../service/tag_service.dart';
import '../notifications/snackbar_service.dart';
import '../screens/category_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/tag_screen.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({super.key});

  @override
  HomeDrawerState createState() => HomeDrawerState();
}

class HomeDrawerState extends State<HomeDrawer> {
  bool _isDeleteDialogVisible = false;

  @override
  void initState() {
    super.initState();
  }

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
                setState(() {
                  _isDeleteDialogVisible = true;
                });
              },
            ),
            ListTile(
              title: const Text('Categories'),
              onTap: () => _navigateToCategoryScreen(context),
            ),
            ListTile(
              title: const Text('Tags'),
              onTap: () => _navigateToTagScreen(context),
            ),
            ListTile(
              title: const Text('Settings'),
              onTap: () => _navigateToSettingsScreen(context),
            ),
            if (_isDeleteDialogVisible) _buildDeleteConfirmationDialog(context),
          ],
        ),
      ),
    );
  }

  void _navigateToSettingsScreen(BuildContext context) =>
      _navigateToScreen(context, const SettingsScreen());

  void _navigateToCategoryScreen(BuildContext context) =>
      _navigateToScreen(context, const CategoryScreen());

  void _navigateToTagScreen(BuildContext context) =>
      _navigateToScreen(context, const TagScreen());

  void _navigateToScreen(BuildContext context, Widget screenWidget) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => screenWidget,
      ),
    );
  }

  Widget _buildDeleteConfirmationDialog(BuildContext context) {
    return AlertDialog(
      title: const Text("Confirmation"),
      content: const Text(
          "Are you sure you want to delete all data? \n\nNote: Consider Export before proceding"),
      actions: <Widget>[
        TextButton(
          child: const Text("Cancel"),
          onPressed: () {
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
