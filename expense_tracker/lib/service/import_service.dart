import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:logger/logger.dart';

import '../data/constants/db_constants.dart';
import '../data/constants/file_name_constants.dart';
import '../models/import_result.dart';
import 'category_service.dart';
import 'expense_item_service.dart';
import 'expense_service.dart';
import 'tag_service.dart';

class ImportService {
  late final Future<ExpenseService> _expenseService;
  late final Future<ExpenseItemService> _expenseItemService;
  late final Future<CategoryService> _categoryService;
  late final Future<TagService> _tagService;

  static final Logger _logger =
      Logger(printer: SimplePrinter(), level: Level.info);

  ImportService() {
    _init();
  }

  Future<void> _init() async {
    _expenseService = ExpenseService.create();
    _expenseItemService = ExpenseItemService.create();
    _categoryService = CategoryService.create();
    _tagService = TagService.create();
  }

  static Future<PlatformFile?> getJsonFileFromUser() async {
    _logger.i('importing');

    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['json', 'zip']);

    if (result != null) {
      PlatformFile file = result.files.first;
      return file;
    }
    return null;
  }

  Future<ImportResult> importFile(String filepath) async {
    _logger.i("importing file ${filepath.split("/").last}");
    _logger.i("filepath:  $filepath");
    ImportResult result = ImportResult();
    try {
      File file = File(filepath);
      if (!await file.exists()) {
        _logger.i("File not found");
        result.message = "File not found";
        return result;
      }
      final fileBytes = file.readAsBytesSync();
      final archive = ZipDecoder().decodeBytes(fileBytes);

      for (ArchiveFile file in archive.files) {
        _logger.i('File: ${file.name}');
        if (isJsonFile(file)) {
          _logger.i("\tis json");
          String jsonString = utf8.decode(file.content as List<int>);
          dynamic jsonData = jsonDecode(jsonString);
          if (jsonData is! List<dynamic>) {
            _logger.d("\tInvalid JSON format");
            // result.message = "${file.name}: Invalid JSON format";
            continue;
          }

          if (file.name == FileConstants.export.expenses) {
            _logger.i("importing ${DBConstants.expense.table}");
            result = await importExpenses(jsonData, result);
          }
          if (file.name == FileConstants.export.expenseItems) {
            _logger.i("importing ${DBConstants.expenseItem.table}");
            result = await importExpenseItems(jsonData, result);
          }
          if (file.name == FileConstants.export.categories) {
            _logger.i("importing ${DBConstants.category.table}");
            result = await importCategories(jsonData, result);
          }
          if (file.name == FileConstants.export.tags) {
            _logger.i("importing ${DBConstants.tag.table}");
            result = await importTags(jsonData, result);
          }
        }
      }
    } catch (e, stackTrace) {
      _logger.e('Error importing JSON file: $e - \n$stackTrace');
      result.message = "Error importing JSON file";
      return result;
    }
    result.result = true;
    return result;
  }

  Future<bool> isValidJson(ArchiveFile file) async {
    final content = await file.content;
    try {
      jsonDecode(utf8.decode(content));
      return true;
    } on FormatException catch (e) {
      return false;
    }
  }

  bool isJsonFile(ArchiveFile file) {
    return file.name.toLowerCase().endsWith('.json');
  }

  dynamic importExpenses(List<dynamic> jsonData, ImportResult result) async {
    int totalExpenses = jsonData.length;
    int successCount = 0;

    ExpenseService service = await _expenseService;

    for (Map<String, dynamic> expense in jsonData) {
      // backward compatibility db v1
      if (expense.containsKey(DBConstants.expense.expenses)) {
        expense.remove(DBConstants.expense.expenses);
      }
      bool isInserted = await service.importExpense(expense);
      if (isInserted) successCount++;
    }

    result.expense.total = totalExpenses;
    result.expense.successCount = successCount;
    return result;
  }

  dynamic importExpenseItems(
      List<dynamic> jsonData, ImportResult result) async {
    int totalExpenses = jsonData.length;
    int successCount = 0;

    ExpenseItemService service = await _expenseItemService;

    for (Map<String, dynamic> expenseItem in jsonData) {
      bool isInserted = await service.importExpenseItem(expenseItem);
      if (isInserted) successCount++;
    }

    result.expenseItems.total = totalExpenses;
    result.expenseItems.successCount = successCount;
    return result;
  }

  dynamic importCategories(List<dynamic> jsonData, ImportResult result) async {
    int totalCategories = jsonData.length;
    int successCount = 0;

    CategoryService service = await _categoryService;

    for (Map<String, dynamic> category in jsonData) {
      bool isInserted = await service.importCategory(category);
      if (isInserted) successCount++;
    }

    result.category.total = totalCategories;
    result.category.successCount = successCount;
    return result;
  }

  dynamic importTags(List<dynamic> jsonData, ImportResult result) async {
    int totalTags = jsonData.length;
    int successCount = 0;

    TagService service = await _tagService;

    for (Map<String, dynamic> tag in jsonData) {
      bool isInserted = await service.importTag(tag);
      if (isInserted) successCount++;
    }

    result.tag.total = totalTags;
    result.tag.successCount = successCount;
    return result;
  }
}
