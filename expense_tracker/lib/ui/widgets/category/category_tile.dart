import 'package:flutter/material.dart';

import '../common/list_tile.dart';

class CategoryTile extends StatelessWidget {
  final String categoryName;
  final VoidCallback onDelete;

  const CategoryTile({
    Key? key,
    required this.categoryName,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DeletableTile(
      title: categoryName,
      onDelete: onDelete,
    );
  }
}
