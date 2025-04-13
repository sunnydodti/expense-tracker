// Conditionally export the appropriate implementation based on platform
export 'web_service_web.dart' if (dart.library.io) 'web_service_io.dart';