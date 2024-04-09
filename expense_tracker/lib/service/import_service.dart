import 'dart:convert';
import 'dart:io';

import 'package:expense_tracker/data/constants/db_constants.dart';
import 'package:expense_tracker/models/import_result.dart';
import 'package:file_picker/file_picker.dart';
import 'package:logger/logger.dart';

import '../data/constants/file_name_constants.dart';
import 'expense_service.dart';

class ImportService {
  late final Future<ExpenseService> _expenseService;
  static final Logger _logger =
      Logger(printer: SimplePrinter(), level: Level.info);

  ImportService() {
    _init();
  }

  Future<void> _init() async {
    _expenseService = ExpenseService.create();
  }

  static Future<PlatformFile?> getJsonFileFromUser() async {
    _logger.i('importing');

    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        initialDirectory: await FileConstants.exportFilePath());

    if (result != null) {
      PlatformFile file = result.files.first;
      return file;
    }
    return null;
  }

  Future<ImportResult> importFile(String filepath, Function callback) async {
    _logger.i("importing file ${filepath.split("/").last}");
    ImportResult result = ImportResult();
    int totalExpenses = 0;
    int successCount = 0;
    try {
      File file = File(filepath);
      if (!await file.exists()) {
        result.message = "File does not exist";
        return result;
      }

      String contents = await file.readAsString();
      dynamic jsonData = jsonDecode(contents);

      if (jsonData is! List<dynamic>) {
        result.message = "Invalid JSON format";
        return result;
      }
      totalExpenses = jsonData.length;
      for (Map<String, dynamic> expense in jsonData) {
        // await Future.delayed(const Duration(seconds: 1));
        _logger.i("inserting ${expense[DBConstants.expense.id]}");
        ExpenseService service = await _expenseService;
        service.importExpense(expense).then((bool isInserted) => {
              if (isInserted)
                {
                  // callback(),
                  _logger.i("inserted ${expense[DBConstants.expense.id]}"),
                  successCount++,
                }
            });
      }
    } catch (e) {
      _logger.e('Error importing JSON file: $e');
      result.message = "Error importing JSON file";
      return result;
    }
    result.result = true;
    result.totalExpenses = totalExpenses;
    result.successCount = successCount;
    return result;
  }
}
