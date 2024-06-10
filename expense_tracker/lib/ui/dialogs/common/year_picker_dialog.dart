import 'package:flutter/material.dart';

import '../../../data/helpers/color_helper.dart';

class YearPickerDialog {
  static Future<int?> show(BuildContext context) async {
    return showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ColorHelper.getTileColor(Theme.of(context)),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Select Year'),
              IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.clear))
            ],
          ),
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
