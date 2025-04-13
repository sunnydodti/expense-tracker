import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../data/constants/response_constants.dart';
import '../../data/helpers/color_helper.dart';
import '../../models/import_result.dart';
import '../../providers/expense_provider.dart';
import '../../service/export_service.dart';
import '../../service/import_service.dart';
import '../../service/path_service.dart';
import '../../service/permission_service.dart';
import '../../ui/notifications/snackbar_service.dart';

class ImportForm extends StatefulWidget {
  const ImportForm({Key? key}) : super(key: key);

  @override
  State<ImportForm> createState() => _ImportFormState();
}

class _ImportFormState extends State<ImportForm> {
  final _formKey = GlobalKey<FormState>();

  static final Logger _logger =
      Logger(printer: SimplePrinter(), level: Level.info);

  String _defaultStoragePath = '';
  String _lastStoragePath = '';

  String isErrorMessage = "";
  bool get isError => isErrorMessage.isNotEmpty;

  PlatformFile? selectedFile;
  bool get isFileSelected => selectedFile != null;
  String selectedFilePath = "";

  final selectedFileController = TextEditingController();

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
      // _lastStoragePath = "select a path";
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
            if (!kIsWeb) getDefaultStoragePathFile(),
            const SizedBox(height: 20),
            getFileNameField(theme),
            if (isError) getErrorMessage(),
            if (isError) const SizedBox(height: 20),
            getImportButton(theme),
            const SizedBox(height: 10)
          ],
        ));
  }

  Text getErrorMessage() =>
      Text(isErrorMessage, style: const TextStyle(color: Colors.red));

  Row getImportButton(ThemeData theme) {
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
            'Import',
            style: TextStyle(color: ColorHelper.getButtonTextColor(theme)),
          ),
        )
      ],
    );
  }

  Future<void> _selectFile() async {
    bool storagePermission = await _requestStoragePermission();
    if (!storagePermission) {
      setState(() =>
          isErrorMessage = ResponseConstants.export.storagePermissionDenied);
      return;
    }

    setState(() => isErrorMessage = '');

    PlatformFile? file = await ImportService.getJsonFileFromUser();
    if (file == null) return;

    if (!kIsWeb) selectedFilePath = file.path!;
    selectedFile = file;
    selectedFileController.text = file.name;
    _formKey.currentState!.validate();
    setState(() {});
  }

  getDefaultStoragePathFile() {
    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Default Storage Path:"),
          Text(
            _defaultStoragePath,
          ),
        ],
      ),
    );
  }

  void getFolderFromUser() async {
    String path = await ExportService.getPathFromUserFolder();
    if (path.isNotEmpty) {
      setState(() {
        _lastStoragePath = path;
      });
    }
  }

  void submit() async {
    if (!isFileSelected) {
      setState(() => isErrorMessage = ResponseConstants.import.fileNotSelected);
      return;
    }

    // TODO: change
    if (!kIsWeb && !File(selectedFile!.path!).existsSync()) {
      isErrorMessage = ResponseConstants.import.fileNotFound;
      setState(() {});
      return;
    }

    setState(() => isErrorMessage = '');

    await _importExpenses();
    // if (!result.result) {
    //   setState(() {
    //     isError = true;
    //     isErrorMessage = result.message;
    //   });
    //   return;
    // }
    selectedFileController.clear();
    setState(() => isErrorMessage = '');
  }

  Future<bool> _importExpenses() async {
    SnackBarService.showSnackBarWithContext(context, "imported started",
        duration: 1);
    ImportService importService = ImportService();
    ImportResult result = await importService.importFile(selectedFile!);
    if (!result.result) {
      setState(() => isErrorMessage = result.message);
      SnackBarService.showErrorSnackBar(result.message);
      return false;
    }
    _logger.i(result.toString());

    _refreshExpenses();
    String message = result.importSuccessMessage();

    SnackBarService.showSuccessSnackBarWithContext(context, message,
        duration: 5);
    return true;
  }

  getFileNameField(ThemeData theme) {
    Color color = ColorHelper.getIconColor(theme);
    return ListTile(
      title: TextFormField(
        controller: selectedFileController,
        maxLines: 1,
        maxLength: 30,
        readOnly: true,
        decoration: InputDecoration(
          labelText: 'Selected File',
          hintText: "click icon to select a file -->",
          suffixIcon: IconButton(
            onPressed: () {
              selectedFileController.clear();
              selectedFile = null;
            },
            icon: const Icon(Icons.clear, size: 20),
          ),
        ),
        validator: (value) => validateTextField(value, "enter FileName"),
        keyboardType: TextInputType.text,
        onChanged: (value) {
          _logger.i('file name: $value');
        },
      ),
      trailing: IconButton(
        onPressed: _selectFile,
        icon: Icon(Icons.file_open_outlined, size: 30, color: color),
      ),
    );
  }

  String? validateTextField(var value, String errorMessage) {
    if (!isFileSelected) return "Select a file";
    if (!kIsWeb && !File(selectedFilePath).existsSync()) {
      return ResponseConstants.import.fileNotFound;
    }
    return null; // Return null if the input is valid
  }

  _refreshExpenses() {
    final expenseProvider =
        Provider.of<ExpenseProvider>(context, listen: false);
    expenseProvider.refreshExpenses();
  }

  Future<bool> _requestStoragePermission() async {
    if (kIsWeb) return true;
    if (!await PermissionService.isStoragePermission) {
      if (!await PermissionService.requestStoragePermission()) {
        setState(() =>
            isErrorMessage = ResponseConstants.export.storagePermissionDenied);
      }
      return false;
    }
    return true;
  }
}
