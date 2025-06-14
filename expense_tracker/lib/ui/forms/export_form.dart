import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../../data/constants/file_name_constants.dart';
import '../../data/constants/response_constants.dart';
import '../../data/helpers/color_helper.dart';
import '../../models/export_result.dart';
import '../../service/export_service.dart';
import '../../service/path_service.dart';
import '../../ui/dialogs/share_file_dialog.dart';
import '../../ui/notifications/snackbar_service.dart';

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
    if (kIsWeb) return;

    String defaultPath = await PathService.fileExportPathForView();
    setState(() {
      _defaultStoragePath = defaultPath;
      _externalStoragePath = "select a path";
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!kIsWeb) getPathToggle(theme),
            if (!kIsWeb) getStoragePathFile(),
            const SizedBox(height: 20),
            if (isError) getErrorMessage(),
            if (isError) const SizedBox(height: 20),
            getFileNameField(),
            getExportButton(theme),
            const SizedBox(height: 10)
          ],
        ));
  }

  Text getErrorMessage() => Text(
        isErrorMessage,
        style: const TextStyle(color: Colors.red),
      );

  Row getExportButton(ThemeData theme) {
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
            child: Text(
              'Export',
              style: TextStyle(color: ColorHelper.getButtonTextColor(theme)),
            ))
      ],
    );
  }

  SwitchListTile getPathToggle(ThemeData theme) {
    return SwitchListTile(
      activeColor: ColorHelper.getToggleColor(theme),
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
        icon: Icon(icon, color: ColorHelper.getIconColor(Theme.of(context))),
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
    try {
      await _exportAllData();
      return;
    } catch (e) {
      _logger.e("Error - : $e");
      setState(() {
        isError = true;
        isErrorMessage = ResponseConstants.export.exportFailed;
      });
    }
  }

  Future<ExportResult> _exportAllData() async {
    ExportService exportService = ExportService();

    String fileName = _getExportFileName();
    ExportResult result = await exportService.exportAllDataToJson(
      userPath: exportFilePath,
      fileName: fileName,
    );
    if (!result.result) {
      SnackBarService.showErrorSnackBar(result.message);
      setState(() {
        isError = true;
        isErrorMessage = result.message;
      });
      return result;
    }
    setState(() => isError = false);
    SnackBarService.showSuccessSnackBar(
      "${result.message}\nPath: ${result.outputPath}",
      duration: 5,
    );
    _showShareDialog(result.path!);
    return result;
  }

  String get exportFilePath {
    if (kIsWeb) return '';
    if (isExternalStoragePath) return _externalStoragePath;
    return '';
  }

  Future<void> _showShareDialog(String filePath) async {
    await ShareFileDialog.show(
      context,
      title: "Export Complete",
      content: "Share exported file?",
      filePath: filePath,
      showFileName: true,
    );
  }

  getFileNameField() {
    return TextFormField(
      controller: fileNameController,
      maxLines: 1,
      maxLength: 30,
      decoration: InputDecoration(
        focusColor: Colors.green,
        labelText: 'File Name (optional)',
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
        _logger.i('file name: $value');
      },
    );
  }

  String? validateTextField(var value, String errorMessage) {
    if (fileNameController.text.isEmpty) return null;
    if (fileNameController.text.length > 30) return 'max length is 30';
    return null;
  }

  String _getExportFileName() {
    String fileName = fileNameController.text.trim();
    if (fileName.isNotEmpty || fileName != "") {
      if (!fileName.endsWith(FileConstants.export.extension)) {
        fileName += FileConstants.export.extension;
      }
    }
    return fileName;
  }
}
