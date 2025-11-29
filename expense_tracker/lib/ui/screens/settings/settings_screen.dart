import 'package:flutter/material.dart';

import '../../../data/constants/ui_constants.dart';
import '../../../data/helpers/color_helper.dart';
import '../../../data/helpers/navigation_helper.dart';
import '../../dialogs/delete_all_dialog.dart';
import '../../forms/export_form.dart';
import '../../forms/import_form.dart';
import '../../widgets/common/screen_app_bar.dart';
import '../../widgets/expandable_list_tile.dart';
import '../../widgets/theme_selector.dart';
import 'preferences_settings_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorHelper.getBackgroundColor(Theme.of(context)),
      appBar: const ScreenAppBar(title: 'Settings'),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: uiPadding),
              children: [
                const ExpandableListTile(
                  title: 'Import',
                  content: ImportForm(),
                ),
                const ExpandableListTile(
                  title: 'Export',
                  content: ExportForm(),
                ),
                const DeleteAllDialog(),
                ListTile(
                  title: const Text('Preferences'),
                  onTap: () => NavigationHelper.navigateToScreen(
                    context,
                    const PreferencesSettingsScreen(),
                  ),
                ),
                const ThemeSelector()
                // buildThemeDropdown(context)
              ],
            ),
          )
        ],
      ),
    );
  }
}
