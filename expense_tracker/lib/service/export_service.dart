import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' if (dart.library.io) 'dart:io' as platform;

import 'package:archive/archive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import '../data/constants/db_constants.dart';
import '../data/constants/file_name_constants.dart';
import '../data/constants/response_constants.dart';
import '../models/export_result.dart';
import 'category_service.dart';
import 'expense_item_service.dart';
import 'expense_service.dart';
import 'path_service.dart';
import 'permission_service.dart';
import 'profile_service.dart';
import 'tag_service.dart';
import 'user_service.dart';

class ExportService {
  late final Future<ExpenseService> _expenseService;
  late final Future<ExpenseItemService> _expenseItemService;
  late final Future<CategoryService> _categoryService;
  late final Future<TagService> _tagService;
  late final Future<UserService> _userService;
  late final Future<ProfileService> _profileService;

  static final Logger _logger =
      Logger(printer: SimplePrinter(), level: Level.info);

  ExportService() {
    _init();
  }

  Future<void> _init() async {
    _expenseService = ExpenseService.create();
    _expenseItemService = ExpenseItemService.create();
    _categoryService = CategoryService.create();
    _tagService = TagService.create();
    _userService = UserService.create();
    _profileService = ProfileService.create();
  }

  void exportToJson(Map<String, dynamic> data, String filePath) {
    File file = File(filePath);
    file.writeAsStringSync(jsonEncode(data));
  }

  // Future<ExportResult> exportAllDataToJson({
  //   String userPath = "",
  //   String fileName = "",
  // }) async {
  //   _logger.i("Export: Begin");
  //   ExportResult result = ExportResult();
  //   String tempJson = await tempJSONPath;
  //   File expensesJSON = File("$tempJson/${FileConstants.export.expenses}");
  //   File expenseItemsJSON =
  //       File("$tempJson/${FileConstants.export.expenseItems}");
  //   File categoriesJSON = File("$tempJson/${FileConstants.export.categories}");
  //   File tagsJSON = File("$tempJson/${FileConstants.export.tags}");
  //   File usersJSON = File("$tempJson/${FileConstants.export.users}");
  //   File profilesJSON = File("$tempJson/${FileConstants.export.profiles}");
  //   File versionJSON = File("$tempJson/${FileConstants.export.version}");

  //   try {
  //     await _saveJSONFiles(
  //       expensesJSON,
  //       expenseItemsJSON,
  //       categoriesJSON,
  //       tagsJSON,
  //       usersJSON,
  //       profilesJSON,
  //       versionJSON,
  //     );

  //     Archive archive = _getExportArchive(expensesJSON, expenseItemsJSON,
  //         categoriesJSON, tagsJSON, usersJSON, profilesJSON, versionJSON);

  //     final zipEncoder = ZipEncoder();
  //     List<int>? encodedZip = zipEncoder.encode(archive);

  //     String zipFileName = fileName;
  //     if (zipFileName == "" || zipFileName.isEmpty) {
  //       zipFileName = FileConstants.export.zip.replaceFirst(
  //           "{0}", DateFormat('yyyy-MM-dd_HH-mm-ss').format(DateTime.now()));
  //     }

  //     String zipExportPath = userPath;
  //     if (zipExportPath == "" || zipExportPath.isEmpty) {
  //       zipExportPath = await exportPath;
  //     }

  //     _logger.i("exporting all data to $zipExportPath/$zipFileName");
  //     File zipFile =
  //         await File("$zipExportPath/$zipFileName").writeAsBytes(encodedZip);

  //     result.result = true;
  //     result.message = ResponseConstants.export.exportSuccessful;
  //     result.path = zipFile.path;
  //   } catch (e, stackTrace) {
  //     _logger.e('Error at exportAllDataToJson() $e - \n$stackTrace');
  //   } finally {
  //     if (await expensesJSON.exists()) expensesJSON.delete();
  //     if (await expenseItemsJSON.exists()) expenseItemsJSON.delete();
  //     if (await categoriesJSON.exists()) categoriesJSON.delete();
  //     if (await tagsJSON.exists()) tagsJSON.delete();
  //     if (await usersJSON.exists()) usersJSON.delete();
  //     if (await profilesJSON.exists()) profilesJSON.delete();
  //     if (await versionJSON.exists()) versionJSON.delete();
  //   }

  //   _logger.i("Export: End");
  //   return result;
  // }

  Future<ExportResult> exportAllDataToJson({
    String userPath = "",
    String fileName = "",
  }) async {
    _logger.i("Export: Begin");
    ExportResult result = ExportResult();

    try {
      if (kIsWeb) {
        result = await _exportForWeb(fileName);
      } else if (Platform.isAndroid || Platform.isIOS) {
        result = await _exportForMobile(userPath, fileName);
      } else if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
        result = await _exportForDesktop(userPath, fileName);
      } else {
        throw UnsupportedError("Unsupported platform for export");
      }
    } catch (e, stackTrace) {
      _logger.e('Error at exportAllDataToJson() $e - \n$stackTrace');
      result.result = false;
      result.message = ResponseConstants.export.exportFailed;
    }

    _logger.i("Export: End");
    return result;
  }

  Future<ExportResult> _exportForMobile(
      String userPath, String fileName) async {
    ExportResult result = ExportResult();
    String tempJson = await tempJSONPath;
    File expensesJSON = File("$tempJson/${FileConstants.export.expenses}");
    File expenseItemsJSON =
        File("$tempJson/${FileConstants.export.expenseItems}");
    File categoriesJSON = File("$tempJson/${FileConstants.export.categories}");
    File tagsJSON = File("$tempJson/${FileConstants.export.tags}");
    File usersJSON = File("$tempJson/${FileConstants.export.users}");
    File profilesJSON = File("$tempJson/${FileConstants.export.profiles}");
    File versionJSON = File("$tempJson/${FileConstants.export.version}");

    try {
      await _saveJSONFiles(
        expensesJSON,
        expenseItemsJSON,
        categoriesJSON,
        tagsJSON,
        usersJSON,
        profilesJSON,
        versionJSON,
      );

      Archive archive = _getExportArchive(expensesJSON, expenseItemsJSON,
          categoriesJSON, tagsJSON, usersJSON, profilesJSON, versionJSON);

      final zipEncoder = ZipEncoder();
      List<int>? encodedZip = zipEncoder.encode(archive);

      String zipFileName = fileName;
      if (zipFileName == "" || zipFileName.isEmpty) {
        zipFileName = FileConstants.export.zip.replaceFirst(
            "{0}", DateFormat('yyyy-MM-dd_HH-mm-ss').format(DateTime.now()));
      }

      String zipExportPath = userPath;
      if (zipExportPath == "" || zipExportPath.isEmpty) {
        zipExportPath = await exportPath;
      }

      _logger.i("exporting all data to $zipExportPath/$zipFileName");
      File zipFile =
          await File("$zipExportPath/$zipFileName").writeAsBytes(encodedZip);

      result.result = true;
      result.message = ResponseConstants.export.exportSuccessful;
      result.path = zipFile.path;
      // result.outputPath = zipExportPath;
    } finally {
      // Clean up temp files
      if (await expensesJSON.exists()) expensesJSON.delete();
      if (await expenseItemsJSON.exists()) expenseItemsJSON.delete();
      if (await categoriesJSON.exists()) categoriesJSON.delete();
      if (await tagsJSON.exists()) tagsJSON.delete();
      if (await usersJSON.exists()) usersJSON.delete();
      if (await profilesJSON.exists()) profilesJSON.delete();
      if (await versionJSON.exists()) versionJSON.delete();
    }

    return result;
  }

  Future<ExportResult> _exportForDesktop(
      String userPath, String fileName) async {
    ExportResult result = ExportResult();
    String tempJson = await tempJSONPath;
    File expensesJSON = File("$tempJson/${FileConstants.export.expenses}");
    File expenseItemsJSON =
        File("$tempJson/${FileConstants.export.expenseItems}");
    File categoriesJSON = File("$tempJson/${FileConstants.export.categories}");
    File tagsJSON = File("$tempJson/${FileConstants.export.tags}");
    File usersJSON = File("$tempJson/${FileConstants.export.users}");
    File profilesJSON = File("$tempJson/${FileConstants.export.profiles}");
    File versionJSON = File("$tempJson/${FileConstants.export.version}");

    try {
      // Desktop doesn't need storage permissions check
      await _saveJSONFilesForDesktop(
        expensesJSON,
        expenseItemsJSON,
        categoriesJSON,
        tagsJSON,
        usersJSON,
        profilesJSON,
        versionJSON,
      );

      Archive archive = _getExportArchive(expensesJSON, expenseItemsJSON,
          categoriesJSON, tagsJSON, usersJSON, profilesJSON, versionJSON);

      final zipEncoder = ZipEncoder();
      List<int>? encodedZip = zipEncoder.encode(archive);

      String zipFileName = fileName;
      if (zipFileName == "" || zipFileName.isEmpty) {
        zipFileName = FileConstants.export.zip.replaceFirst(
            "{0}", DateFormat('yyyy-MM-dd_HH-mm-ss').format(DateTime.now()));
      }

      String zipExportPath = userPath;
      if (zipExportPath == "" || zipExportPath.isEmpty) {
        // Use desktop documents folder as default
        zipExportPath = await PathService.desktopExportPath;
      }

      _logger.i("exporting all data to $zipExportPath/$zipFileName");
      File zipFile =
          await File("$zipExportPath/$zipFileName").writeAsBytes(encodedZip);

      result.result = true;
      result.message = ResponseConstants.export.exportSuccessful;
      result.path = zipFile.path;
      // result.outputPath = zipExportPath;
    } finally {
      // Clean up temp files
      if (await expensesJSON.exists()) await expensesJSON.delete();
      if (await expenseItemsJSON.exists()) await expenseItemsJSON.delete();
      if (await categoriesJSON.exists()) await categoriesJSON.delete();
      if (await tagsJSON.exists()) await tagsJSON.delete();
      if (await usersJSON.exists()) await usersJSON.delete();
      if (await profilesJSON.exists()) await profilesJSON.delete();
      if (await versionJSON.exists()) await versionJSON.delete();
    }

    return result;
  }

  Future<ExportResult> _exportForWeb(String fileName) async {
    ExportResult result = ExportResult();

    try {
      List<Map<String, dynamic>> expenses =
          await (await _expenseService).getExpenseMaps();
      List<Map<String, dynamic>> expenseItems =
          await (await _expenseItemService).getExpenseItemsMaps();
      List<Map<String, dynamic>> categories =
          await (await _categoryService).getCategoryMaps();
      List<Map<String, dynamic>> tags = await (await _tagService).getTagMaps();
      List<Map<String, dynamic>> users =
          await (await _userService).getUserMaps();
      List<Map<String, dynamic>> profiles =
          await (await _profileService).getProfileMaps();
      Map<String, dynamic> versionInfo = await getVersionMap();

      Archive archive = Archive();

      archive.addFile(
        _createArchiveFileFromJson(FileConstants.export.expenses, expenses),
      );
      archive.addFile(
        _createArchiveFileFromJson(
            FileConstants.export.expenseItems, expenseItems),
      );
      archive.addFile(
        _createArchiveFileFromJson(FileConstants.export.categories, categories),
      );
      archive.addFile(
        _createArchiveFileFromJson(FileConstants.export.tags, tags),
      );
      archive.addFile(
        _createArchiveFileFromJson(FileConstants.export.users, users),
      );
      archive.addFile(
        _createArchiveFileFromJson(FileConstants.export.profiles, profiles),
      );
      archive.addFile(
        _createArchiveFileFromJson(FileConstants.export.version, versionInfo),
      );

      final zipEncoder = ZipEncoder();
      List<int>? encodedZip = zipEncoder.encode(archive);

      String zipFileName = fileName;
      if (zipFileName == "" || zipFileName.isEmpty) {
        zipFileName = FileConstants.export.zip.replaceFirst(
            "{0}", DateFormat('yyyy-MM-dd_HH-mm-ss').format(DateTime.now()));
      }

      // Use browser download API
      _downloadBlobData(encodedZip, zipFileName);

      result.result = true;
      result.message = ResponseConstants.export.exportSuccessful;
      result.path = zipFileName; // No real path for web
    } catch (e, stackTrace) {
      _logger.e('Error -  at _exportForWeb() $e - \n$stackTrace');
      result.result = false;
      result.message = "Export failed: ${e.toString()}";
    }

    return result;
  }

// Helper method to create archive files from JSON data for web
  ArchiveFile _createArchiveFileFromJson(String filename, dynamic data) {
    String jsonStr = getFormattedJSONString(data);
    List<int> jsonBytes = utf8.encode(jsonStr);
    return ArchiveFile(filename, jsonBytes.length, jsonBytes);
  }

// Web-specific download method
  void _downloadBlobData(List<int> bytes, String fileName) {
    if (kIsWeb) {
      // The following code only works on web
      final blob = platform.Blob([bytes]);
      final url = platform.Url.createObjectUrlFromBlob(blob);
      final anchor = platform.AnchorElement(href: url);
      anchor.setAttribute('download', fileName);
      anchor.click();
      platform.Url.revokeObjectUrl(url);
    }
  }

// Desktop version of saveJSONFiles without permission checks
  Future<void> _saveJSONFilesForDesktop(
      File expensesJSON,
      File expenseItemsJSON,
      File categoriesJSON,
      File tagsJSON,
      File usersJSON,
      File profilesJSON,
      File versionJSON) async {
    ExpenseService expenseService = await _expenseService;
    ExpenseItemService expenseItemService = await _expenseItemService;
    CategoryService categoryService = await _categoryService;
    TagService tagService = await _tagService;
    UserService userService = await _userService;
    ProfileService profileService = await _profileService;

    try {
      _logger.i("exporting expenses to ${expensesJSON.path}");
      expensesJSON.writeAsStringSync(
          getFormattedJSONString(await expenseService.getExpenseMaps()));

      _logger.i("exporting expense items to ${expenseItemsJSON.path}");
      expenseItemsJSON.writeAsStringSync(getFormattedJSONString(
          await expenseItemService.getExpenseItemsMaps()));

      _logger.i("exporting categories to ${categoriesJSON.path}");
      categoriesJSON.writeAsStringSync(
          getFormattedJSONString(await categoryService.getCategoryMaps()));

      _logger.i("exporting tags to ${tagsJSON.path}");
      tagsJSON.writeAsStringSync(
          getFormattedJSONString(await tagService.getTagMaps()));

      _logger.i("exporting users to ${usersJSON.path}");
      usersJSON.writeAsStringSync(
          getFormattedJSONString(await userService.getUserMaps()));

      _logger.i("exporting profiles to ${profilesJSON.path}");
      profilesJSON.writeAsStringSync(
          getFormattedJSONString(await profileService.getProfileMaps()));

      _logger.i("exporting version info to ${versionJSON.path}");
      versionJSON
          .writeAsStringSync(getFormattedJSONString(await getVersionMap()));
    } catch (e) {
      _logger.e("unable to save json files $e");
      rethrow;
    }
  }

  Future<void> _saveJSONFiles(
      File expensesJSON,
      File expenseItemsJSON,
      File categoriesJSON,
      File tagsJSON,
      File usersJSON,
      File profilesJSON,
      File versionJSON) async {
    ExpenseService expenseService = await _expenseService;
    ExpenseItemService expenseItemService = await _expenseItemService;
    CategoryService categoryService = await _categoryService;
    TagService tagService = await _tagService;
    UserService userService = await _userService;
    ProfileService profileService = await _profileService;

    try {
      bool status = await PermissionService.requestStoragePermission();
      if (await PermissionService.isStoragePermission) {
        if (status) {
          _logger.i("exporting expenses to ${expensesJSON.path}");
          expensesJSON.writeAsStringSync(
              getFormattedJSONString(await expenseService.getExpenseMaps()));

          _logger.i("exporting expense items to ${expenseItemsJSON.path}");
          expenseItemsJSON.writeAsStringSync(getFormattedJSONString(
              await expenseItemService.getExpenseItemsMaps()));

          _logger.i("exporting categories to ${categoriesJSON.path}");
          categoriesJSON.writeAsStringSync(
              getFormattedJSONString(await categoryService.getCategoryMaps()));

          _logger.i("exporting tags to ${tagsJSON.path}");
          tagsJSON.writeAsStringSync(
              getFormattedJSONString(await tagService.getTagMaps()));

          _logger.i("exporting users to ${usersJSON.path}");
          usersJSON.writeAsStringSync(
              getFormattedJSONString(await userService.getUserMaps()));

          _logger.i("exporting profiles to ${profilesJSON.path}");
          profilesJSON.writeAsStringSync(
              getFormattedJSONString(await profileService.getProfileMaps()));

          _logger.i("exporting version info to ${versionJSON.path}");
          versionJSON
              .writeAsStringSync(getFormattedJSONString(await getVersionMap()));
        } else {
          throw Exception("storage permission denied");
        }
      }
    } catch (e) {
      _logger.i("unable to save json files $e");
      rethrow;
    }
  }

  Archive _getExportArchive(
      File expensesJSON,
      File expenseItemsJSON,
      File categoriesJSON,
      File tagsJSON,
      File usersJSON,
      File profilesJSON,
      File versionJSON) {
    Archive archive = Archive();

    archive.addFile(ArchiveFile(FileConstants.export.expenses,
        expensesJSON.lengthSync(), expensesJSON.readAsBytesSync()));
    archive.addFile(ArchiveFile(FileConstants.export.expenseItems,
        expenseItemsJSON.lengthSync(), expenseItemsJSON.readAsBytesSync()));
    archive.addFile(ArchiveFile(FileConstants.export.categories,
        categoriesJSON.lengthSync(), categoriesJSON.readAsBytesSync()));
    archive.addFile(ArchiveFile(FileConstants.export.tags,
        tagsJSON.lengthSync(), tagsJSON.readAsBytesSync()));
    archive.addFile(ArchiveFile(FileConstants.export.users,
        usersJSON.lengthSync(), usersJSON.readAsBytesSync()));
    archive.addFile(ArchiveFile(FileConstants.export.profiles,
        profilesJSON.lengthSync(), profilesJSON.readAsBytesSync()));
    archive.addFile(ArchiveFile(FileConstants.export.version,
        versionJSON.lengthSync(), versionJSON.readAsBytesSync()));

    return archive;
  }

  String getFormattedJSONString(jsonObject) {
    var encoder = const JsonEncoder.withIndent("    ");
    return encoder.convert(jsonObject);
  }

  Future<String> get exportPath async => await PathService.fileExportPath;

  Future<String> get tempPath async => await PathService.tempPath;

  Future<String> get tempJSONPath async =>
      await PathService.tempFolderPath(FileConstants.cache.json);

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
      return '';
    }
  }

  getVersionMap() {
    Map<String, dynamic> versionInfo = {};
    versionInfo[DBConstants.version.appVersionKey] =
        DBConstants.version.appVersion;
    versionInfo[DBConstants.version.databaseVersionKey] =
        DBConstants.version.databaseVersion;
    versionInfo[DBConstants.version.createdAt] =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    return versionInfo;
  }
}
