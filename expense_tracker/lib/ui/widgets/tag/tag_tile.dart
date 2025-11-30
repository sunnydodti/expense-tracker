import 'package:flutter/material.dart';

import '../common/list_tile.dart';

class TagTile extends StatelessWidget {
  final String tagName;
  final VoidCallback onDelete;

  const TagTile({
    super.key,
    required this.tagName,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return DeletableTile(
      title: tagName,
      onDelete: onDelete,
    );
  }
}
