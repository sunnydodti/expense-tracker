import 'package:flutter/material.dart';

import '../../../data/helpers/navigation_helper.dart';
import '../../../forms/export_form.dart';
import '../../../forms/import_form.dart';
import '../../dialogs/delete_all_tile.dart';
import '../../widgets/expandable_list_tile.dart';
import 'preferences_settings_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  final String title = "Settings";

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    _getDefaults();
  }

  void _getDefaults() async {}

  Future<void> _refreshSettings(BuildContext context) async {
    // final provider = Provider.of<CategoryProvider>(context, listen: false);
    // provider.refreshCategories();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _refreshSettings(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Scaffold(
            appBar: AppBar(
              leading: SafeArea(
                  child: BackButton(
                    onPressed: () => NavigationHelper.navigateBack(context),
              )),
              centerTitle: true,
              title: Text(widget.title, textScaleFactor: 0.9),
              backgroundColor: Colors.black,
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    children: [
                      const ExpandableListTile(
                          title: 'Import', content: ImportForm()),
                      const ExpandableListTile(
                          title: 'Export', content: ExportForm()),
                      const DeleteAllTile(),
                      ListTile(
                        title: const Text('Preferences'),
                        onTap: () => NavigationHelper.navigateToScreen(
                            context, const PreferencesSettingsScreen()),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        }
      },
    );
  }
}
