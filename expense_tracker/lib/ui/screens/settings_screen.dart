import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../models/import_result.dart';
import '../../providers/expense_provider.dart';
import '../../service/import_service.dart';
import '../notifications/snackbar_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  final String title = "Settings";

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final Logger _logger = Logger(printer: SimplePrinter(), level: Level.info);
  String exportFilePath = '';

  String _selectedFileName = 'Please select a file';
  String _selectedFilePath =
      '/data/user/0/com.sunnydodti.expense_tracker/cache/file_picker/expense_tracker_export.zip';

  Future<void> _refreshSettings(BuildContext context) async {
    // final provider = Provider.of<CategoryProvider>(context, listen: false);
    // provider.refreshCategories();
  }

  navigateBack(BuildContext context, bool result) =>
      Navigator.pop(context, result);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _refreshSettings(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Scaffold(
            appBar: AppBar(
              leading: SafeArea(
                  child: BackButton(
                onPressed: () => navigateBack(context, false),
              )),
              centerTitle: true,
              title: Text(widget.title, textScaleFactor: 0.9),
              backgroundColor: Colors.black,
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      ListTile(
                        title: const Text('Import'),
                        onTap: () => _showImportDialog(context),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        }
      },
    );
  }

  Future<void> _showImportDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Import File"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Export Path:\n$exportFilePath'),
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
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text("Import"),
              onPressed: () {
                if (_selectedFileName != '') {
                  _importExpenses();
                }
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
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

  Text _showSelectedFileName() {
    if (_selectedFileName != "") return Text(_selectedFileName);
    return const Text("");
  }

  void _importExpenses() async {
    SnackBarService.showSnackBarWithContext(context, "imported started",
        duration: 1);
    ImportService importService = ImportService();
    importService
        .importFile(_selectedFilePath, _refreshExpenses)
        .then((ImportResult result) {
      _logger.i(result.toString());
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

  _refreshExpenses() {
    final expenseProvider =
        Provider.of<ExpenseProvider>(context, listen: false);
    expenseProvider.refreshExpenses();
  }
}
