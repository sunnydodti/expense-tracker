import 'package:flutter/material.dart';

import '../../../data/helpers/color_helper.dart';
import '../../widgets/common/screen_app_bar.dart';
import '../../widgets/preferences/preferences_list.dart';

class PreferencesSettingsScreen extends StatelessWidget {
  const PreferencesSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorHelper.getBackgroundColor(Theme.of(context)),
      appBar: const ScreenAppBar(title: 'Preferences'),
      body: const Column(
        children: [Expanded(child: PreferencesList())],
      ),
    );
  }
}
