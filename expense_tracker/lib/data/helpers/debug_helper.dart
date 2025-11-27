import 'package:flutter/foundation.dart';

class DebugHelper {
  DebugHelper._();
  static bool get isDebugMode => !kReleaseMode;
}
