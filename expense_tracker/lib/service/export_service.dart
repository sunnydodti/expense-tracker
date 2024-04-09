import 'dart:convert';
import 'dart:io';

import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

import '../data/constants/file_name_constants.dart';
import '../models/export_result.dart';
import 'expense_service.dart';

class ExportService {
  late final Future<ExpenseService> _expenseService;
  static final Logger _logger =
      Logger(printer: SimplePrinter(), level: Level.info);

  ExportService() {
    _init();
  }

  Future<void> _init() async {
    _expenseService = ExpenseService.create();
  }

  void exportToJson(Map<String, dynamic> data, String filePath) {
    File file = File(filePath);
    file.writeAsStringSync(jsonEncode(data));
  }

  Future<ExportResult> exportAllExpensesToJson() async {
    ExportResult result = ExportResult();
    try {
      ExpenseService expenseService = await _expenseService;
      List<Map<String, dynamic>> data = await expenseService.fetchExpenseMaps();
      String fileName = FileConstants.exportedFileName
          .replaceFirst("{0}", DateTime.now().toString());
      File file = File("${await getExportPath()}/$fileName");
      _logger.i("exporting to ${file.path}");
      file.writeAsStringSync(getFormattedJSONString(data));

      result.result = true;
      result.message = "Successfully Exported";
      result.path = file.path;
    } catch (e, stackTrace) {
      _logger.e('Error at exportAllExpensesToJson() $e - \n$stackTrace');
    }
    return result;
  }

  String getFormattedJSONString(jsonObject) {
    var encoder = const JsonEncoder.withIndent("    ");
    return encoder.convert(jsonObject);
  }

  Future<String> getExportPath() async {
    return (await getExternalStorageDirectory())!.path;
  }
}
