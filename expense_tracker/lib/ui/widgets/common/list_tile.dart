import 'package:flutter/material.dart';

import '../../../data/helpers/color_helper.dart';

class DeletableTile extends StatelessWidget {
  final String title;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const DeletableTile({
    Key? key,
    required this.title,
    this.onDelete,
    this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ColorHelper.getTileColor(Theme.of(context)),
      margin: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 5),
      child: ListTile(
        dense: true,
        title: Text(
          title,
          textScaleFactor: 1,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onEdit != null)
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: onEdit,
              ),
            if (onDelete != null)
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red.shade300),
                onPressed: onDelete,
              ),
          ],
        ),
      ),
    );
  }
}
