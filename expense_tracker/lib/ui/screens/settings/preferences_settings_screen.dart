import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/helpers/color_helper.dart';
import '../../../data/helpers/navigation_helper.dart';
import '../../../providers/settings_provider.dart';
import '../../widgets/preferences/preferences_list.dart';

class PreferencesSettingsScreen extends StatefulWidget {
  const PreferencesSettingsScreen({super.key});

  final String title = 'Preferences';

  @override
  State<PreferencesSettingsScreen> createState() =>
      _PreferencesSettingsScreenState();
}

class _PreferencesSettingsScreenState extends State<PreferencesSettingsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return buildPreferencesWidget();
  }

  Scaffold buildPreferencesWidget() {
    return Scaffold(
      backgroundColor: ColorHelper.getBackgroundColor(Theme.of(context)),
      appBar: AppBar(
        leading: SafeArea(
          child: BackButton(
            onPressed: () => NavigationHelper.navigateBack(context),
          ),
        ),
        centerTitle: true,
        title: Text(widget.title, textScaleFactor: 0.9),
        backgroundColor: ColorHelper.getAppBarColor(Theme.of(context)),
      ),
      body: Column(
        children: const [
          Expanded(
            child: PreferencesList(),
          )
        ],
      ),
    );
  }

  void _refreshPreferences() {
    final provider = Provider.of<SettingsProvider>(context, listen: false);
    provider.refreshPreferences();
  }
}
