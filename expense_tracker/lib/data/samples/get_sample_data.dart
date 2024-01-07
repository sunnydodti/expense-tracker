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

  static dynamic getDemoExpenses() {
    return [
      {
        "id": "1",
        "title": "expense 01",
        "timestamp": "2019-01-01 00:00:00",
        "currency": "₹",
        "amount": "10.00",
        "transactionType": "expense",
        "date": "2024-01-17",
        "category": "food",
        "tags": "Pizza",
        "note": "Pizza Hut",
        "containsNestedExpenses": "false",
        "expenses": []
      },
      ...List.generate(
        9,
            (index) => {
          "id": "${index + 3}", // Incrementing the id for uniqueness
          "title": "expense ${index + 3}",
          "timestamp": "2022-01-01 00:00:00", // Update timestamp as needed
          "currency": "₹", // Update currency as needed
          "amount": "900.00", // Update amount as needed
          "transactionType": "expense",
          "date": "2024-01-17", // Update date as needed
          "category": "misc", // Update category as needed
          "tags": "Tag ${index + 3}", // Update tags as needed
          "note": "Note ${index + 3}", // Update note as needed
          "containsNestedExpenses": "false",
          "expenses": []
        },
      ),
    ];
  }
}
