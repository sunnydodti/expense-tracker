import 'package:flutter/material.dart';

import '../../forms/export_form.dart';
import '../../forms/import_form.dart';
import '../widgets/expandable_list_tile.dart';

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

  navigateBack(BuildContext context, bool result) =>
      Navigator.pop(context, result);

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
                onPressed: () => navigateBack(context, false),
              )),
              centerTitle: true,
              title: Text(widget.title, textScaleFactor: 0.9),
              backgroundColor: Colors.black,
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: const [
                      ExpandableListTile(
                          title: 'Import', content: ImportForm()),
                      ExpandableListTile(
                          title: 'Export', content: ExportForm()),
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
