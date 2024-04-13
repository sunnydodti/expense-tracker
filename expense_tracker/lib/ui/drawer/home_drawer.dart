import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import '../../data/constants/response_constants.dart';
import '../../models/export_result.dart';
import '../../models/import_result.dart';
import '../../providers/expense_provider.dart';
import '../../service/category_service.dart';
import '../../service/expense_service.dart';
import '../../service/export_service.dart';
import '../../service/import_service.dart';
import '../../service/path_service.dart';
import '../../service/tag_service.dart';
import '../notifications/snackbar_service.dart';
import '../screens/category_screen.dart';
import '../screens/tag_screen.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({super.key});

  @override
  HomeDrawerState createState() => HomeDrawerState();
}

class HomeDrawerState extends State<HomeDrawer> {
  final Logger _logger = Logger(printer: SimplePrinter(), level: Level.info);

  bool _isDeleteDialogVisible = false;
  bool _isImportDialogVisible = false;

  String _exportFilePath = '';
  String _selectedFileName = 'Please select a file';
  String _selectedFilePath =
      '/data/user/0/com.sunnydodti.expense_tracker/cache/file_picker/expense_tracker_export.zip';

  @override
  void initState() {
    super.initState();
    _getExportFilePath();
  }

  Future<void> _getExportFilePath() async {
    final filePath = await PathService.fileExportPath;
    setState(() {
      _exportFilePath = filePath;
    });
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
              title: const Text('Import'),
              onTap: () {
                setState(() {
                  _isImportDialogVisible = true;
                });
              },
            ),
            ListTile(
              title: const Text('Export'),
              onTap: () => _exportExpenses(context),
            ),
            ListTile(
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                SnackBarService.showSnackBarWithContext(
                    context, ResponseConstants.upcoming.getRandomMessage);
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
            if (_isDeleteDialogVisible) _buildDeleteConfirmationDialog(context),
            if (_isImportDialogVisible) _buildImportDialog(context),
          ],
        ),
      ),
    );
  }

  _navigateToCategoryScreen(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CategoryScreen(),
      ),
    );
  }

  _navigateToTagScreen(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TagScreen(),
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

  Widget _buildImportDialog(BuildContext context) {
    return AlertDialog(
      title: const Text("Import File"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Export Path:\n$_exportFilePath'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _selectFile,
            child: const Text('Select File'),
          ),
          const SizedBox(height: 8),
          _showSelectedFileName(),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text("Cancel"),
          onPressed: () {
            setState(() {
              _isImportDialogVisible = false;
            });
          },
        ),
        TextButton(
          child: const Text("Import"),
          onPressed: () {
            if (_selectedFileName != '') {
              _importExpenses();
            }
          },
        ),
      ],
    );
  }

  void _importExpenses() async {
    setState(() {
      _isImportDialogVisible = false;
    });
    SnackBarService.showSnackBarWithContext(context, "imported started",
        duration: 1);
    ImportService importService = ImportService();
    importService
        .importFile(_selectedFilePath, _refreshExpenses)
        .then((ImportResult result) {
      _logger.i(result.toString());
      Navigator.pop(context);
      if (result.result) {
        _refreshExpenses();
        String message = "Import complete"
            "\nExpenses:    ${result.expense.successCount}/${result.expense.total}"
            "\nCategories:  ${result.category.successCount}/${result.category.total}"
            "\nTags:             ${result.tag.successCount}/${result.tag.total}\n";
        SnackBarService.showSuccessSnackBarWithContext(context, message,
            duration: 5);
      } else {
        SnackBarService.showErrorSnackBarWithContext(context, result.message);
      }
    });
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

  Text _showSelectedFileName() {
    if (_selectedFileName != "") return Text(_selectedFileName);
    return const Text("");
  }

  Future<void> _selectFile() async {
    PlatformFile? file = await ImportService.getJsonFileFromUser();
    if (file != null) {
      setState(() {
        _selectedFileName = file.name;
        _selectedFilePath = file.path!;
      });
    }
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
