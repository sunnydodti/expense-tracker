import 'package:flutter/material.dart';

import '../../data/constants/ui_constants.dart';

class EmptyListWidget extends StatelessWidget {
  final String listName;

  const EmptyListWidget({
    super.key,
    required this.listName,
  });

  @override
  Widget build(BuildContext context) {
    final message = "icon to add $listName";
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text('Click', style: TextStyle(color: Colors.grey)),
        const SizedBox(width: uiSize),
        const Icon(Icons.add, color: Colors.grey),
        const SizedBox(width: uiSize),
        Text(message, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
