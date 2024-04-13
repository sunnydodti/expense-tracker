import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import '../../models/export_result.dart';
import '../../providers/expense_provider.dart';
import '../../service/category_service.dart';
import '../../service/expense_service.dart';
import '../../service/export_service.dart';
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
  final Logger _logger = Logger(printer: SimplePrinter(), level: Level.info);

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
              title: const Text('Export'),
              onTap: () => _exportExpenses(context),
            ),
            ListTile(
              title: const Text('Settings'),
              onTap: () => _navigateToSettingsScreen(context),
            ),
            ListTile(
              title: const Text('Categories'),
              onTap: () => _navigateToCategoryScreen(context),
            ),
            ListTile(
              title: const Text('Tags'),
              onTap: () => _navigateToTagScreen(context),
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

  void _exportExpenses(BuildContext context) async {
    ExportService exportService = ExportService();
    ExportResult result = await exportService.exportAllDataToJson();
    if (mounted) {
      if (result.result) {
        SnackBarService.showSuccessSnackBarWithContext(
            context, "${result.message}\nPath: ${result.outputPath}",
            duration: 5);
      } else {
        SnackBarService.showErrorSnackBarWithContext(context, result.message);
      }
      Navigator.pop(context);
      if (result.result) _showSaveDialog(result.path!);
    }
  }

  Future<void> _showSaveDialog(String filePath) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Complete, Save?'),
        content: const Text(
            'All data is wiped if you uninstall!\n\nDo you want to save file to a different location?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await Share.shareFiles([filePath]);
            },
            child: const Text('Save'),
          ),
          // TextButton(
          //   onPressed: () async {
          //     Navigator.pop(context);
          //     // Show a message or open the downloaded file (optional)
          //     print('ZIP file saved to: $filePath');
          //   },
          //   child: const Text('View'),
          // ),
        ],
      ),
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
