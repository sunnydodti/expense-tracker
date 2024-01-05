import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class GetSampleData {
  static Future<Map<String, dynamic>> readJsonFile() async {
    // Replace 'path/to/your/sample_data.json' with the actual path to your JSON file
    const String filePath = 'lib/data/samples/sample_expenses.json';

    final file = await rootBundle.loadString(filePath);
    debugPrint(file);
    return jsonDecode(file) as Map<String, dynamic>;
  }
}
