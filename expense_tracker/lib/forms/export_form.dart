import 'dart:io';

import 'package:expense_tracker/service/permission_service.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../models/export_result.dart';
import '../service/export_service.dart';
import '../service/path_service.dart';
import '../ui/notifications/snackbar_service.dart';

class ExportForm extends StatefulWidget {
  const ExportForm({Key? key}) : super(key: key);

  @override
  State<ExportForm> createState() => _ExportFormState();
}

class _ExportFormState extends State<ExportForm> {
  final _formKey = GlobalKey<FormState>();

  static final Logger _logger =
      Logger(printer: SimplePrinter(), level: Level.info);

  String _defaultStoragePath = '';
  String _externalStoragePath = '';

  bool isExternalStoragePath = false;

  bool isError = false;
  String isErrorMessage = "";

  // final _externalPathController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getPaths();
  }

  Future<void> _getPaths() async {
    String defaultPath = await PathService.fileExportPathForView();
    setState(() {
      _defaultStoragePath = defaultPath;
      _externalStoragePath = "select a path";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getPathToggle(),
            getStoragePathFile(),
            const SizedBox(height: 20),
            if (isError) getErrorMessage(),
            if (isError) const SizedBox(height: 20),
            getExportButton()
          ],
        ));
  }

  Text getErrorMessage() => Text(
        isErrorMessage,
        style: const TextStyle(color: Colors.red),
      );

  Row getExportButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(onPressed: () => submit(), child: const Text('Export'))
      ],
    );
  }

  SwitchListTile getPathToggle() {
    return SwitchListTile(
      title: const Text("Use Custom Storage Location"),
      value: isExternalStoragePath,
      onChanged: (bool newValue) {
        setState(() {
          isExternalStoragePath = newValue;
        });
      },
    );
  }

  getStoragePathFile() {
    if (!isExternalStoragePath) {
      return _buildStoragePathListTile(
          _defaultStoragePath, Icons.folder_off_outlined, () => {});
    }
    return _buildStoragePathListTile(
      _externalStoragePath,
      Icons.folder_outlined,
      getFolderFromUser,
    );
  }

  ListTile _buildStoragePathListTile(
      String path, IconData? icon, Function() onPressed) {
    return ListTile(
      title: Text(path),
      trailing: IconButton(
        onPressed: onPressed,
        icon: Icon(icon),
      ),
    );
  }

  void getFolderFromUser() async {
    String path = await ExportService.getPathFromUserFolder();
    if (path.isNotEmpty) {
      setState(() {
        _externalStoragePath = path;
      });
    }
  }

  void submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      String storagePath = _defaultStoragePath;
      if (isExternalStoragePath) {
        if (!Directory(_externalStoragePath).existsSync()) {
          setState(() {
            isError = true;
            isErrorMessage = "Folder not found";
          });
          return;
        }

        if (!await PermissionService.isExternalStoragePermission) {
          if (!await PermissionService.requestExternalPermission()) {
            setState(() {
              isError = true;
              isErrorMessage =
                  "No Permission: allow All Files permission in settings or use default storage";
            });
          }
          return;
        }
        storagePath = _externalStoragePath;
      } else {
        if (!await PermissionService.isStoragePermission) {
          if (!await PermissionService.requestStoragePermission()) {
            setState(() {
              isError = true;
              isErrorMessage =
              "No Permission: allow media storage permission in settings to continue";
            });
            return;
          }
        }
        storagePath = '';
      }

      ExportResult result = await _exportAllData(storagePath);
      if (!result.result) {
        setState(() {
          isError = true;
          isErrorMessage = result.message;
        });
        return;
      }

      setState(() {
        isError = false;
      });
    }
  }

  Future<ExportResult> _exportAllData(String filePath) async {
    ExportService exportService = ExportService();
    ExportResult result =
        await exportService.exportAllDataToJson(userPath: filePath);
    if (mounted) {
      if (result.result) {
        SnackBarService.showSuccessSnackBarWithContext(
            context, "${result.message}\nPath: ${result.outputPath}",
            duration: 5);
      } else {
        SnackBarService.showErrorSnackBarWithContext(context, result.message);
      }
      // if (result.result) _showSaveDialog(result.path!);
    }
    return result;
  }

  String? _validatePath(value) {
    if (_defaultStoragePath.isEmpty) {
      return 'Please enter a category name.';
    }
    return null;
  }
}
