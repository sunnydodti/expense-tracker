class ExportResult {
  bool result = false;
  String message = "unable to export";
  String? path;

  ExportResult();

  String? get outputPath => path!.substring('/storage/emulated/0'.length);
// String? getAndroidDataPath() {
//   if (path != null && path!.startsWith('/storage/emulated/0')) {
//     return path!.substring('/storage/emulated/0'.length);
//   }
//   return null;
// }
}
