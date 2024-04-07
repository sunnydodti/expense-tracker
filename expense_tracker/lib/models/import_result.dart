class ImportResult {
  bool result = false;
  String message = "Unable to import file";
  String? path;
  int? totalExpenses;
  int? successCount;

  ImportResult();
  String? get outputPath => path!.substring('/storage/emulated/0'.length);
// String? getAndroidDataPath() {
//   if (path != null && path!.startsWith('/storage/emulated/0')) {
//     return path!.substring('/storage/emulated/0'.length);
//   }
//   return null;
// }
}
