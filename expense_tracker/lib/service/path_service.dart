import 'dart:io';

import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

class PathService {
  static final Logger _logger =
      Logger(printer: SimplePrinter(), level: Level.info);

  /// returns the path to the export folder)
  static Future<String> get fileExportPath async =>
      await _getAppStoragePath(folderName: "export");

  /// returns the path to the export folder)
  static Future<String> fileExportPathForView() async {
      String path = await _getAppStoragePath(folderName: "export");
      if (Platform.isAndroid) return path.replaceFirst("/storage/emulated/0/", "");
      return path;
  }

  /// getter for temporary storage location
  static Future<String> get tempPath async => await _getAppCachePath();

  /// returns the path to a specific folder in cache storage (creates if not exists)
  static Future<String> tempFolderPath(String folderName) async =>
      await _getAppCachePath(folderName: folderName);

  /// returns path to app's private internal storage
  /// <folderName> optional: can create a new folder if it doesn't exist and return it's path
  static Future<String> _getAppStoragePath({String folderName = ""}) async =>
      _getAppPath(storageType: _getBasePath, folderName: folderName);

  /// returns the path to cache storage
  static Future<String> _getAppCachePath({String folderName = ""}) async =>
      _getAppPath(storageType: _getCachePath, folderName: folderName);

  /// returns path to a specific storage type
  /// <folderName> optional: can create a new folder in storage path if it doesn't exist and return it's path
  static Future<String> _getAppPath({
    required Future<String> Function() storageType,
    String folderName = "",
  }) async {
    String appStoragePath = await storageType();

    if (folderName.isEmpty) return appStoragePath;

    String folderPath = "$appStoragePath/$folderName";
    if (await _createFolderIfNotExist(folderPath)) {
      return folderPath;
    }
    return appStoragePath;
  }

  /// creates a folder if it doesn't exist
  static Future<bool> _createFolderIfNotExist(String path) async {
    try {
      final directory = Directory(path);
      _logger.i("$path - ${directory.existsSync()}");
      if (!directory.existsSync()) {
        _logger.i("creating folder: $path");
        await directory.create();
        _logger.i("folder created: $path");
      }
      return true;
    } on Exception catch (e, stackTrace) {
      _logger.e("unable to create folder ($path): $e - \n$stackTrace");
      return false;
    }
  }

  static Future<String> _getBasePath() async {
    if (Platform.isAndroid) {
      // return '/storage/emulated/0/Download';
      final Directory? directory = await getExternalStorageDirectory();
      return directory!.path;
    }
    final Directory? directory = await getExternalStorageDirectory();
    return directory!.path;
  }

  static Future<String> _getCachePath() async {
    if (Platform.isAndroid) {
      // return '/storage/emulated/0/Download';
      final Directory directory = await getTemporaryDirectory();
      return directory.path;
    }
    final Directory? directory = await getExternalStorageDirectory();
    return directory!.path;
  }
}
