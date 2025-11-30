import 'package:flutter/material.dart';
import 'package:pwa_install/pwa_install.dart';

import '../../../data/constants/ui_constants.dart';
import '../../../data/helpers/color_helper.dart';

class InstallPwaButton extends StatelessWidget {
  final EdgeInsets padding;
  const InstallPwaButton({
    super.key,
    this.padding = const EdgeInsets.all(uiPadding),
  });

  @override
  Widget build(BuildContext context) {
    if (!PWAInstall().installPromptEnabled) return const SizedBox.shrink();
    return _buildPwaInstallButton(context);
  }

  Padding _buildPwaInstallButton(BuildContext context) {
    return Padding(
      padding: padding,
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            PWAInstall().promptInstall_();
          },
          child: Text(
            'Install PWA',
            style: TextStyle(
              color: ColorHelper.getButtonTextColor(Theme.of(context)),
            ),
          ),
        ),
      ),
    );
  }
}
