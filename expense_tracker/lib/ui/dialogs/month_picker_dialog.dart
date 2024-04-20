import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthPickerDialog {
  static Future<String?> show(BuildContext context) async {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Select Month'),
              IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.clear))
            ],
          ),
          content: SizedBox(
            height: 200.0,
            width: 200.0,
            child: ListView.builder(
              itemCount: 12,
              itemBuilder: (context, index) {
                final fullMonth =
                    DateFormat('MMMM').format(DateTime(2000, index + 1));
                final shortMonth =
                    DateFormat('MMMM').format(DateTime(2000, index + 1));
                return ListTile(
                  title: Text(fullMonth),
                  onTap: () {
                    Navigator.pop(context, shortMonth);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
