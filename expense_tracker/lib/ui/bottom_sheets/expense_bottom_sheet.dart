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
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(50))),
      builder: (BuildContext context) {
        return _buildExpenseBottomSheetContent(
          context,
          expense,
          viewCallBack,
          editCallBack,
          deleteCallBack,
        );
      },
    );
  }

  static Container _buildExpenseBottomSheetContent(
      BuildContext context,
      Expense expense,
      VoidCallback viewCallBack,
      VoidCallback editCallBack,
      VoidCallback deleteCallBack) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        color: Colors.grey.shade900,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDecoration(),
          Text(expense.title),
          const Divider(),
          _buildOptionList(context, viewCallBack, editCallBack, deleteCallBack),
        ],
      ),
    );
  }

  static Padding _buildDecoration() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        height: 5,
        width: 50,
        decoration: const BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.all(Radius.circular(5))),
      ),
    );
  }

  static ListView _buildOptionList(
      BuildContext context,
      VoidCallback viewCallBack,
      VoidCallback editCallBack,
      VoidCallback deleteCallBack) {
    return ListView(
      shrinkWrap: true,
      children: [
        ListTile(
          iconColor: Colors.green.shade800,
          title: const Text("View"),
          trailing: const Icon(Icons.notes_outlined),
          onTap: () => handleCallBack(context, viewCallBack),
        ),
        ListTile(
          iconColor: Colors.orange.shade800,
          title: const Text("Edit"),
          trailing: const Icon(Icons.edit_outlined),
          onTap: () => handleCallBack(context, editCallBack),
        ),
        ListTile(
          iconColor: Colors.red.shade800,
          title: const Text("Delete"),
          trailing: const Icon(Icons.delete_outline),
          onTap: () => handleCallBack(context, deleteCallBack, pop: true),
        ),
      ],
    );
  }

  static void handleCallBack(BuildContext context, VoidCallback callBack,
      {bool pop = false}) {
    callBack();
    if (pop) NavigationHelper.navigateBack(context);
  }
}
