import 'package:flutter/material.dart';

class YearPickerDialog {
  static Future<int?> show(BuildContext context) async {
    return showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Year'),
          content: SizedBox(
            height: 200.0,
            width: 200.0,
            child: ListView.builder(
              itemCount: DateTime.now().year - 1999,
              itemBuilder: (context, index) {
                final year = DateTime.now().year - index;
                return ListTile(
                  title: Text(year.toString()),
                  onTap: () {
                    Navigator.pop(context, year);
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
