import 'package:flutter/material.dart';

import '../../../data/helpers/color_helper.dart';
import '../../widgets/common/screen_app_bar.dart';
import '../../widgets/preferences/preferences_list.dart';

class PreferencesSettingsScreen extends StatefulWidget {
  const PreferencesSettingsScreen({super.key});

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
      appBar: const ScreenAppBar(title: 'Preferences'),
      body: const Column(
        children: [
          Expanded(
            child: PreferencesList(),
          )
        ],
      ),
    );
  }
}
