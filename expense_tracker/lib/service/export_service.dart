import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:logger/logger.dart';

import '../data/constants/file_name_constants.dart';
import '../models/export_result.dart';
import 'category_service.dart';
import 'expense_service.dart';
import 'tag_service.dart';

class ExportService {
  late final Future<ExpenseService> _expenseService;
  late final Future<CategoryService> _categoryService;
  late final Future<TagService> _tagService;

  static final Logger _logger =
      Logger(printer: SimplePrinter(), level: Level.info);

  ExportService() {
    _init();
  }

  Future<void> _init() async {
    _expenseService = ExpenseService.create();
    _categoryService = CategoryService.create();
    _tagService = TagService.create();
  }

  void exportToJson(Map<String, dynamic> data, String filePath) {
    File file = File(filePath);
    file.writeAsStringSync(jsonEncode(data));
  }

  Future<ExportResult> exportAllDataToJson() async {
    _logger.i("Export: Begin");
    ExportResult result = ExportResult();

    File expensesJSON =
        File("${await getExportPath()}/${FileConstants.export.expenses}");
    File categoriesJSON =
        File("${await getExportPath()}/${FileConstants.export.categories}");
    File tagsJSON =
        File("${await getExportPath()}/${FileConstants.export.tags}");

    try {
      ExpenseService expenseService = await _expenseService;
      CategoryService categoryService = await _categoryService;
      TagService tagService = await _tagService;

      List<Map<String, dynamic>> expenses =
          await expenseService.getExpenseMaps();
      List<Map<String, dynamic>> categories =
          await categoryService.getCategoryMaps();
      List<Map<String, dynamic>> tags = await tagService.getTagMaps();

      File expensesJSON =
          File("${await getExportPath()}/${FileConstants.export.expenses}");
      File categoriesJSON =
          File("${await getExportPath()}/${FileConstants.export.categories}");
      File tagsJSON =
          File("${await getExportPath()}/${FileConstants.export.tags}");

      _logger.i("exporting expenses to ${expensesJSON.path}");
      expensesJSON.writeAsStringSync(getFormattedJSONString(expenses));

      _logger.i("exporting categories to ${categoriesJSON.path}");
      categoriesJSON.writeAsStringSync(getFormattedJSONString(categories));

      _logger.i("exporting tags to ${tagsJSON.path}");
      tagsJSON.writeAsStringSync(getFormattedJSONString(tags));

      Archive archive = Archive();
      archive.addFile(ArchiveFile(FileConstants.export.expenses,
          expensesJSON.lengthSync(), expensesJSON.readAsBytesSync()));
      archive.addFile(ArchiveFile(FileConstants.export.categories,
          categoriesJSON.lengthSync(), categoriesJSON.readAsBytesSync()));
      archive.addFile(ArchiveFile(FileConstants.export.tags,
          tagsJSON.lengthSync(), tagsJSON.readAsBytesSync()));

      final zipEncoder = ZipEncoder();
      List<int>? encodedZip = zipEncoder.encode(archive);

      if (encodedZip == null) {
        _logger.i("Export: zip is null");
        return result;
      }

      String zipFileName = FileConstants.export.zip
          .replaceFirst("{0}", DateTime.now().toString());
      File zipFile = await File("${await getExportPath()}/$zipFileName")
          .writeAsBytes(encodedZip);

      result.result = true;
      result.message = "Successfully Exported";
      result.path = zipFile.path;
    } catch (e, stackTrace) {
      _logger.e('Error at exportAllDataToJson() $e - \n$stackTrace');
    } finally {
      if (await expensesJSON.exists()) expensesJSON.delete();
      if (await categoriesJSON.exists()) categoriesJSON.delete();
      if (await tagsJSON.exists()) tagsJSON.delete();
    }

    _logger.i("Export: End");
    return result;
  }

  String getFormattedJSONString(jsonObject) {
    var encoder = const JsonEncoder.withIndent("    ");
    return encoder.convert(jsonObject);
  }

  Future<String> getExportPath() async {
    return FileConstants.export.filePath();
  }
}
