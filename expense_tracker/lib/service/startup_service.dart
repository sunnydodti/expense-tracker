import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:pwa_install/pwa_install.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';


import 'shared_preferences_service.dart';

class StartUpService {
  static Future initialize() async {
    await _init();
  }

  static Future _init() async {
    await _initSharedPreferences();
    await _initPWA();
    await _initSqflite();
  }

  // static Future<void> _initHive() async {
  //   await Hive.initFlutter();
  //   await Hive.openBox("box");
  // }

  static Future _initPWA() async {
    PWAInstall().setup(installCallback: () {
      debugPrint('PWA INSTALLED!');
    });
  }

  static Future _initSqflite() async {
    // web
    if (kIsWeb) {
      databaseFactoryOrNull = databaseFactoryFfiWeb;
      databaseFactory = databaseFactoryFfiWeb;
    } else if (Platform.isLinux || Platform.isWindows) {
      // sqfliteFfiInit();
      // databaseFactory = databaseFactoryFfi;
    }
    //desktop

    //mobile
  }

  static Future _initSharedPreferences() async {
    await SharedPreferencesService().initializeSharedPreferences();
  }
}
