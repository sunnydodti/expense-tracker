import 'package:permission_handler/permission_handler.dart';

class PermissionService {

  static Future<bool> get isStoragePermission async => await Permission.storage.isGranted;
  static Future<bool> get isExternalStoragePermission async => await Permission.manageExternalStorage.isGranted;

  static Future<bool> requestStoragePermission() async => _requestPermission(Permission.storage);
  static Future<bool> requestExternalPermission() async => _requestPermission(Permission.manageExternalStorage);

  static Future<bool> _requestPermission(Permission permission) async {
    var status = await permission.request();
    if (status.isGranted) {
      return true;
    } else {
      return false;
    }
  }
}
