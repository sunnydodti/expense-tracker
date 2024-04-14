import 'dart:io';

import 'package:expense_tracker/data/constants/file_name_constants.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:share/share.dart';

import '../data/constants/response_constants.dart';
import '../models/export_result.dart';
import '../service/export_service.dart';
import '../service/path_service.dart';
import '../service/permission_service.dart';
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

  final fileNameController = TextEditingController();

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
            getFileNameField(),
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
        ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                submit();
              }
            },
            child: const Text('Export'))
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
    String storagePath = _defaultStoragePath;
    if (isExternalStoragePath) {
      if (!Directory(_externalStoragePath).existsSync()) {
        setState(() {
          isError = true;
          isErrorMessage = ResponseConstants.export.folderNotFound;
        });
        return;
      }

      if (!await PermissionService.isExternalStoragePermission) {
        if (!await PermissionService.requestExternalPermission()) {
          setState(() {
            isError = true;
            isErrorMessage =
                ResponseConstants.export.externalStoragePermissionDenied;
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
            isErrorMessage = ResponseConstants.export.storagePermissionDenied;
          });
          return;
        }
      }
      storagePath = '';
    }

    String fileName = fileNameController.text;
    if (fileName.isNotEmpty || fileName != "") {
      if (!fileName.endsWith(FileConstants.export.extension)) {
        fileName += FileConstants.export.extension;
      }
    }
    ExportResult result = await _exportAllData(storagePath, fileName);
    if (!result.result) {
      setState(() {
        isError = true;
        isErrorMessage = result.message;
      });
      return;
    }
    fileNameController.clear();
    setState(() {
      isError = false;
    });
  }

  Future<ExportResult> _exportAllData(String filePath, String fileName) async {
    ExportService exportService = ExportService();
    ExportResult result = await exportService.exportAllDataToJson(
        userPath: filePath, fileName: fileName);
    if (mounted) {
      if (result.result) {
        SnackBarService.showSuccessSnackBarWithContext(
            context, "${result.message}\nPath: ${result.outputPath}",
            duration: 5);
      } else {
        SnackBarService.showErrorSnackBarWithContext(context, result.message);
      }
      if (result.result) _showShareDialog(result.path!);
    }
    return result;
  }

  Future<void> _showShareDialog(String filePath) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Complete'),
        content: const Text('Share exported file?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await Share.shareFiles([filePath]);
              if (mounted) Navigator.pop(context);
            },
            child: const Text('Share'),
          ),
        ],
      ),
    );
  }

  getFileNameField() {
    return TextFormField(
      controller: fileNameController,
      maxLines: 1,
      maxLength: 30,
      decoration: InputDecoration(
        focusColor: Colors.green,
        labelText: 'File Name',
        hintText: "Enter name for exported file",
        suffixIcon: IconButton(
          onPressed: () {
            fileNameController.clear();
          },
          icon: const Icon(Icons.clear, size: 20),
        ),
      ),
      validator: (value) => validateTextField(value, "enter FileName"),
      keyboardType: TextInputType.text,
      onChanged: (value) {
        _logger.i('title: $value');
      },
    );
  }

  String? validateTextField(var value, String errorMessage) {
    if (fileNameController.text.isEmpty) return null;
    if (fileNameController.text.length > 30) return 'max length is 30';
    // Add additional validation logic if needed
    return null; // Return null if the input is valid
  }
}
