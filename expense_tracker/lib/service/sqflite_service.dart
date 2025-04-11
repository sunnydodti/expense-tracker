import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class SqfliteWindowsService {
  static Future init() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
}
