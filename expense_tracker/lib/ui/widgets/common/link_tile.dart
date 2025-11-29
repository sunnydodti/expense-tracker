import 'package:flutter/material.dart';

import '../../../data/constants/ui_constants.dart';
import '../../../data/helpers/color_helper.dart';
import '../../../service/external_service.dart';

class LinkTile extends StatelessWidget {
  final String title;
  final String description;
  final String link;
  final IconData icon;
  const LinkTile({
    super.key,
    required this.title,
    required this.description,
    required this.link,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = ColorHelper.getButtonTextColor(theme);
    final accentColor = ColorHelper.getIconColor(theme);
    return ListTile(
      contentPadding: const EdgeInsets.all(uiPaddingQuarter),
      title: Text(
        title,
        style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(description, style: TextStyle(color: textColor)),
      leading: Icon(icon, color: accentColor, size: uiIconSize),
      onTap: _launchURL,
      trailing: IconButton(
        onPressed: _launchURL,
        icon: const Icon(Icons.arrow_forward_ios_outlined, size: uiIconSize),
      ),
    );
  }

  Future<void> _launchURL() async => await ExternalService.launchURL(link);
}
