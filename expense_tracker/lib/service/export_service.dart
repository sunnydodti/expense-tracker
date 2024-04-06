import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../data/constants/file_name_constants.dart';
import '../models/ExportResult.dart';
import 'expense_service.dart';

class ExportService {
  late final Future<ExpenseService> _expenseService;

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
      String fileName = FileNameConstants.exportedFileName.replaceFirst("{0}", DateTime.now().toString());
      File file = File("${await getExportPath()}/$fileName");
      debugPrint("exporting to ${file.path}");
      file.writeAsStringSync(getFormattedJSONString(data));

      result.result = true;
      result.message = "Successfully Exported";
      result.path = file.path;
    } catch(e) {
      debugPrint('Error at exportAllExpensesToJson() $e');
    }
    return result;
  }

  String getFormattedJSONString(jsonObject){
    var encoder = const JsonEncoder.withIndent("    ");
    return encoder.convert(jsonObject);
  }

  Future<String> getExportPath() async {
    return (await getExternalStorageDirectory())!.path;
  }

}


