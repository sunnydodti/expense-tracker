import 'package:flutter/material.dart';

import '../../../data/constants/ui_constants.dart';
import '../../../data/helpers/color_helper.dart';
import '../../../service/external_service.dart';

class CreditTile extends StatelessWidget {
  final String name;
  final String description;
  final String? link;
  const CreditTile(
      {super.key, required this.name, required this.description, this.link});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = ColorHelper.getTileColor(theme);
    final textColor = ColorHelper.getButtonTextColor(theme);
    final accentColor = ColorHelper.getIconColor(theme);
    String initials =
        name.split(" ").take(2).map((s) => s[0]).join().toUpperCase();
    return ListTile(
        contentPadding: const EdgeInsets.all(uiPaddingQuarter),
        title: Text(
          name,
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(description, style: TextStyle(color: textColor)),
        onTap: _launchURL,
        leading: CircleAvatar(
          backgroundColor: accentColor,
          child: Text(
            initials,
            style: TextStyle(color: cardColor),
          ),
        ),
        trailing: IconButton(
          onPressed: _launchURL,
          icon: const Icon(Icons.link, size: uiIconSize),
        ));
  }

  Future<void> _launchURL() async => await ExternalService.launchURL(link);
}
