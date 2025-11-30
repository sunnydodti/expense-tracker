import 'package:flutter/material.dart';

import '../common/list_tile.dart';

class ProfileTile extends StatelessWidget {
  final String profileName;
  final VoidCallback onDelete;

  const ProfileTile({
    super.key,
    required this.profileName,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return DeletableTile(
      title: profileName,
      onDelete: onDelete,
    );
  }
}
