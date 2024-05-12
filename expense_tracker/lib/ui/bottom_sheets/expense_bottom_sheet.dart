import 'package:flutter/material.dart';

import '../../data/helpers/navigation_helper.dart';
import '../../models/expense.dart';

class ExpenseBottomSheet {
  static void show(BuildContext context, Expense expense,
      {required VoidCallback viewCallBack,
      required VoidCallback editCallBack,
      required VoidCallback deleteCallBack}) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          // height: 200,
          color: Colors.grey.shade900,
          child: ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                title: const Text("View"),
                trailing: const Icon(Icons.notes_outlined),
                onTap: () => handleCallBack(context, viewCallBack),
              ),
              ListTile(
                title: const Text("Edit"),
                trailing: const Icon(Icons.edit_outlined),
                onTap: () => handleCallBack(context, editCallBack),
              ),
              ListTile(
                title: const Text("Delete"),
                trailing: const Icon(Icons.delete_outline),
                onTap: () => handleCallBack(context, deleteCallBack, pop: true),
              ),
            ],
          ),
        );
      },
    );
  }

  static void handleCallBack(BuildContext context, VoidCallback callBack,
      {bool pop = false}) {
    callBack();
    if (pop) NavigationHelper.navigateBack(context);
  }
}
