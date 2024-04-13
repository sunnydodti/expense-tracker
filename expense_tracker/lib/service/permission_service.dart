import 'package:permission_handler/permission_handler.dart';

class PermissionService {

  static Future<bool> get isStoragePermission async => await Permission.storage.isGranted;
  static Future<bool> requestStoragePermission() async => _requestStoragePermission();

  static Future<bool> _requestStoragePermission() async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      // Permission granted, proceed with saving data
      return true;
    } else {
      // Handle permission denied case (e.g., show a snackbar)
      return false;
    }
  }
}
