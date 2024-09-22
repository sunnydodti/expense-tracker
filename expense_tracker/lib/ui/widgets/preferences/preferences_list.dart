import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../../data/helpers/color_helper.dart';
import '../../../providers/settings_provider.dart';
import '../form_widgets.dart';

class PreferencesList extends StatelessWidget {
  const PreferencesList({Key? key}) : super(key: key);

  static final Logger _logger =
      Logger(printer: SimplePrinter(), level: Level.info);

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) => ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Default Currency'),
                _buildDefaultCurrencySelector(settingsProvider, context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SizedBox _buildDefaultCurrencySelector(
      SettingsProvider settingsProvider, BuildContext context) {
    return SizedBox(
      width: 90,
      child: DropdownButton(
        dropdownColor: ColorHelper.getTileColor(Theme.of(context)),
        isExpanded: true,
        value: settingsProvider.defaultCurrency,
        items: FormWidgets.getCurrencyDropdownItems(),
        hint: const Text('Currency'),
        alignment: Alignment.centerRight,
        onChanged: (value) => _setDefaultCurrency(value, settingsProvider),
        underline: Container(),
        focusColor: Colors.transparent,
      ),
    );
  }

  void _setDefaultCurrency(value, SettingsProvider settingsProvider) async {
    settingsProvider.setDefaultCurrency(value);
    _logger.i('selected currency: ${settingsProvider.defaultCurrency}');
  }
}
