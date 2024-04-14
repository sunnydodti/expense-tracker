import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import '../../forms/export_form.dart';
import '../../models/export_result.dart';
import '../../models/import_result.dart';
import '../../providers/expense_provider.dart';
import '../../service/export_service.dart';
import '../../service/import_service.dart';
import '../notifications/snackbar_service.dart';
import '../widgets/expandable_list_tile.dart';

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
                      ListTile(
                        title: const Text('Export'),
                        onTap: () => _exportExpenses(context),
                      ),
                      // ExpandableListTile(
                      //   title: 'Export New',
                      //   content: _buildSaveDialogWidget(context, ""),
                      // ),
                      const ExpandableListTile(title: 'Export New', content: ExportForm())
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
            child: const Text('Share'),
          ),
          TextButton(
            onPressed: () async {
              // Navigator.pop(context);
              await saveToUserFolder(filePath);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> saveToUserFolder(String filePath) async {
    int a = 0;
    final folderPath = await pickFolder();
    try {
      if (folderPath != null) {
        final file = File('$folderPath/myfile.txt');
        final newFile = await file
            .writeAsString('This is content saved to a picked folder');
        _logger.i('ZIP file saved to: $filePath');
      }
    } catch (e, stackTrace) {
      _logger.e("error saving: $e - \n$stackTrace");
    }
  }

  Future<String?> pickFolder() async {
    final result = await FilePicker.platform.getDirectoryPath();
    if (result != null) {
      return result;
    } else {
      // Handle selection cancellation
      return null;
    }
  }

  Widget _buildSaveDialogWidget(BuildContext context, String filePath) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Export Complete, Save?',
            style: Theme.of(context).textTheme.headline6,
          ),
          const SizedBox(height: 8.0),
          Text(
            'All data is wiped if you uninstall!\n\nDo you want to save file to a different location?',
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
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
            ],
          ),
        ],
      ),
    );
  }

  _refreshExpenses() {
    final expenseProvider =
        Provider.of<ExpenseProvider>(context, listen: false);
    expenseProvider.refreshExpenses();
  }
}
