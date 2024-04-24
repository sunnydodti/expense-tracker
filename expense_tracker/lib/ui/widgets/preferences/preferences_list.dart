import 'package:expense_tracker/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../expandable_list_tile.dart';
import '../form_widgets.dart';

class PreferencesList extends StatelessWidget {
  const PreferencesList({Key? key}) : super(key: key);

  static final Logger _logger =
      Logger(printer: SimplePrinter(), level: Level.info);

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) => Scaffold(
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          children: [
            const ExpandableListTile(
              title: 'some preference',
              content: Placeholder(),
            ),
            const ExpandableListTile(
              title: 'some preference',
              content: Placeholder(),
            ),
            SwitchListTile(
              title: const Text('Preferences'),
              value: false,
              onChanged: (bool value) {},
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Default Currency'),
                  _buildDefaultCurrencySelector(settingsProvider),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  SizedBox _buildDefaultCurrencySelector(SettingsProvider settingsProvider) {
    return SizedBox(
      width: 90,
      child: DropdownButton(
        isExpanded: true,
        value: settingsProvider.defaultCurrency,
        items: FormWidgets.getCurrencyDropdownItems(),
        hint: const Text('Currency'),
        alignment: Alignment.centerRight,
        onChanged: (value) => _setDefaultCurrency(value, settingsProvider),
        underline: Container(),
      ),
    );
  }

  void _setDefaultCurrency(value, SettingsProvider settingsProvider) async {
    settingsProvider.setDefaultCurrency(value);
    _logger.i('selected currency: ${settingsProvider.defaultCurrency}');
  }
}
