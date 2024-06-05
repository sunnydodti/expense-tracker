import 'package:flutter/material.dart';

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
        const Text(
          'Click',
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(width: 8),
        const Icon(
          Icons.add,
          color: Colors.grey,
        ),
        const SizedBox(width: 8),
        Text(
          message,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}
