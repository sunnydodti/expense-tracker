import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import '../data/constants/file_name_constants.dart';
import '../models/export_result.dart';
import 'category_service.dart';
import 'expense_service.dart';
import 'path_service.dart';
import 'permission_service.dart';
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

  Future<ExportResult> exportAllDataToJson({String userPath = "", String fileName = ""}) async {
    _logger.i("Export: Begin");
    ExportResult result = ExportResult();

    File expensesJSON =
        File("${await tempJSONPath}/${FileConstants.export.expenses}");
    File categoriesJSON =
        File("${await tempJSONPath}/${FileConstants.export.categories}");
    File tagsJSON =
        File("${await tempJSONPath}/${FileConstants.export.tags}");

    try {
      await _saveJSONFiles(expensesJSON, categoriesJSON, tagsJSON,);

      Archive archive =
          _getExportArchive(expensesJSON, categoriesJSON, tagsJSON);

      final zipEncoder = ZipEncoder();
      List<int>? encodedZip = zipEncoder.encode(archive);

      if (encodedZip == null) {
        _logger.i("Export: zip is null");
        result.message = "unable to zip files";
        return result;
      }

      String zipFileName = fileName;
      if (zipFileName == "" || zipFileName.isEmpty) {
        zipFileName = FileConstants.export.zip
            .replaceFirst("{0}", DateFormat('yyyy-MM-dd_HH-mm-ss').format(DateTime.now()));
      }

      String zipExportPath = userPath;
      if (zipExportPath == "" || zipExportPath.isEmpty) {
        zipExportPath = await exportPath;
      }

      _logger.i("exporting all data to $zipExportPath/$zipFileName");
      File zipFile = await File("$zipExportPath/$zipFileName")
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

  Future<void> _saveJSONFiles(File expensesJSON, File categoriesJSON, File tagsJSON) async {
    ExpenseService expenseService = await _expenseService;
    CategoryService categoryService = await _categoryService;
    TagService tagService = await _tagService;

    try {
      bool status = await PermissionService.requestStoragePermission();
      if (await PermissionService.isStoragePermission){
        if (status){
          _logger.i("exporting expenses to ${expensesJSON.path}");
          expensesJSON.writeAsStringSync(
              getFormattedJSONString(await expenseService.getExpenseMaps()));

          _logger.i("exporting categories to ${categoriesJSON.path}");
          categoriesJSON.writeAsStringSync(
              getFormattedJSONString(await categoryService.getCategoryMaps()));

          _logger.i("exporting tags to ${tagsJSON.path}");
          tagsJSON.writeAsStringSync(
              getFormattedJSONString(await tagService.getTagMaps()));
        }
        else {
          throw Exception("storage permission denied");
        }
      }
    } on Exception catch (e) {
      _logger.i("unable to save json files $e");
      rethrow;
    }
  }

  Archive _getExportArchive(
      File expensesJSON, File categoriesJSON, File tagsJSON) {
    Archive archive = Archive();

    archive.addFile(ArchiveFile(FileConstants.export.expenses,
        expensesJSON.lengthSync(), expensesJSON.readAsBytesSync()));
    archive.addFile(ArchiveFile(FileConstants.export.categories,
        categoriesJSON.lengthSync(), categoriesJSON.readAsBytesSync()));
    archive.addFile(ArchiveFile(FileConstants.export.tags,
        tagsJSON.lengthSync(), tagsJSON.readAsBytesSync()));

    return archive;
  }

  String getFormattedJSONString(jsonObject) {
    var encoder = const JsonEncoder.withIndent("    ");
    return encoder.convert(jsonObject);
  }

  Future<String> get exportPath async => await PathService.fileExportPath;
  Future<String> get tempPath async => await PathService.tempPath;
  Future<String> get tempJSONPath async => await PathService.tempFolderPath(FileConstants.cache.json);

  static Future<String> getPathFromUserFolder() async {
    String folderPath = '';
    try {
      folderPath = await _pickFolder();
    } catch (e, stackTrace) {
      _logger.e("error at getPathFromUserFolder(): $e - \n$stackTrace");
    }
    return folderPath;
  }

  static Future<String> _pickFolder() async {
    final result = await FilePicker.platform.getDirectoryPath();
    if (result != null) {
      return result;
    } else {
      // Handle selection cancellation
      return '';
    }
  }
}
