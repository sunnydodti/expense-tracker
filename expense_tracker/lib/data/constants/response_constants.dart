import 'dart:math';

class ResponseConstants {
  static UpcomingFeature upcoming = UpcomingFeature();
  static ExportResponse export = ExportResponse();
  static ImportResponse import = ImportResponse();
}

class UpcomingFeature {
  static const List<String> _messages = [
    "New horizons await! Coming soon.",
    "Exciting updates ahead! Stay tuned.",
    "Exploring new realms! Coming soon.",
    "Discoveries in progress! Coming soon.",
    "Venturing into the unknown! Stay tuned.",
    "Navigating uncharted waters! Coming soon.",
    "Journeying into new territory! Stay tuned.",
    "Embarking on a new quest! Coming soon.",
    "Venturing into unexplored territory! Stay tuned."
  ];

  String get getRandomMessage {
    final random = Random();
    return _messages[random.nextInt(_messages.length)];
  }
}

class ExportResponse {
  final String storagePermissionDenied =
      "No Permission: allow media storage permission in settings to continue";
  final String externalStoragePermissionDenied =
      "No Permission: allow All Files permission in settings or use default storage";
  final String folderNotFound = "Folder not found";
  final String unableToZip = "Unable to zip files";

  final String exportSuccessful = "Successfully Exported";
  final String exportFailed = "Export Failed";
}

class ImportResponse {
  final String storagePermissionDenied =
      "No Permission: allow media storage permission in settings to continue";
  final String externalStoragePermissionDenied =
      "No Permission: allow All Files permission in settings or use default storage";
  final String fileNotFound = "file not found";
  final String unableToImport = "Unable to Import file";

  final String importSuccessful = "Successfully Imported";
}
