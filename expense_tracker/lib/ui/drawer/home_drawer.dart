import 'package:expense_tracker/data/constants/response_constants.dart';
import 'package:expense_tracker/models/export_result.dart';
import 'package:expense_tracker/ui/screens/category_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../data/constants/file_name_constants.dart';
import '../../models/import_result.dart';
import '../../providers/expense_provider.dart';
import '../../service/expense_service.dart';
import '../../service/export_service.dart';
import '../../service/import_service.dart';
import '../notifications/snackbar_service.dart';
import '../screens/tag_screen.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({super.key});

  @override
  HomeDrawerState createState() => HomeDrawerState();
}

class HomeDrawerState extends State<HomeDrawer> {
  final Logger _logger =
      Logger(printer: SimplePrinter(), level: Level.info);

  bool _isDeleteDialogVisible = false;
  bool _isImportDialogVisible = false;

  String _exportFilePath = '';
  String _selectedFileName = 'ok';
  String _selectedFilePath =
      '/data/user/0/com.sunnydodti.expense_tracker/cache/file_picker/expense_tracker_2024-04-06 16:50:39.513101.json';

  @override
  void initState() {
    super.initState();
    _getExportFilePath();
  }

  Future<void> _getExportFilePath() async {
    final filePath = await FileConstants.exportFilePath();
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
    ).then((value) => Navigator.pop(context));
  }

  _navigateToTagScreen(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TagScreen(),
      ),
    ).then((value) => Navigator.pop(context));
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
            Navigator.pop(context);
            SnackBarService.showSnackBarWithContext(context, "Import Canceled");
            setState(() {
              _isImportDialogVisible = false;
            });
          },
        ),
        TextButton(
          child: const Text("Import"),
          onPressed: () {
            if (_selectedFileName != '') {
              Navigator.pop(context);
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
        .then((ImportResult result) => {
              _logger.d(result.toString()),
              if (result.result)
                {
                  _refreshExpenses(),
                  SnackBarService.showSuccessSnackBarWithContext(context,
                      "imported ${result.successCount}/${result.totalExpenses}",
                      duration: 2)
                }
              else
                SnackBarService.showErrorSnackBarWithContext(
                    context, "not imported"),
            });
  }

  void _exportExpenses(BuildContext context) async {
    Navigator.pop(context);
    ExportService exportService = ExportService();
    exportService.exportAllExpensesToJson().then((ExportResult result) => {
          if (result.result)
            SnackBarService.showSuccessSnackBarWithContext(
                context, "${result.message} \npath:${result.outputPath}",
                duration: 5)
          else
            SnackBarService.showErrorSnackBarWithContext(
                context, result.message)
        });
  }

  Text _showSelectedFileName() {
    if (_selectedFileName != "") return Text(_selectedFileName);
    return const Text("");
  }

  Future<void> _selectFile() async {
    // Open file picker to select a file
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
