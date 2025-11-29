import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../data/constants/db_constants.dart';
import '../../data/constants/ui_constants.dart';
import '../../data/helpers/color_helper.dart';
import '../widgets/common/link_tile.dart';
import '../widgets/common/screen_app_bar.dart';
import '../widgets/common/credit_tile.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PackageInfo packageInfo = PackageInfo(
      appName: 'Expense Tracker',
      packageName: 'com.sunnydodti.expense_tracker',
      version: '${DBConstants.version.appVersion}-alpha',
      buildNumber: '1',
    );

    final theme = Theme.of(context);
    final cardColor = ColorHelper.getTileColor(theme);
    final textColor = ColorHelper.getButtonTextColor(theme);
    final accentColor = ColorHelper.getIconColor(theme);

    return Scaffold(
      appBar: const ScreenAppBar(title: 'About'),
      backgroundColor: ColorHelper.getBackgroundColor(Theme.of(context)),
      body: _buildAboutList(
        context,
        cardColor,
        textColor,
        accentColor,
        packageInfo,
      ),
    );
  }

  Padding _buildAboutList(BuildContext context, Color cardColor,
      Color? textColor, Color accentColor, PackageInfo packageInfo) {
    return Padding(
      padding: const EdgeInsets.only(
        left: uiPadding,
        right: uiPadding,
        top: uiPadding,
      ),
      child: ListView(
        children: [
          _buildAppInfoSection(
              context, cardColor, textColor, accentColor, packageInfo),
          _buildLinksSection(cardColor, textColor, accentColor),
          _buildCreatorSection(cardColor, textColor, accentColor),
          _buildCreditsSection(cardColor, textColor, accentColor),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    String? title,
    required Color cardColor,
    required List<Widget> children,
  }) {
    return Card(
      color: cardColor,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: uiMargin),
      child: Padding(
        padding: const EdgeInsets.all(uiPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null) _buildSectionTitle(title, null),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color? textColor) {
    return Text(
      title,
      textScaler: const TextScaler.linear(uiTextScalerAboutSubTitle),
      style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
    );
  }

  Widget _buildAppInfoSection(
    BuildContext context,
    Color cardColor,
    Color? textColor,
    Color accentColor,
    PackageInfo packageInfo,
  ) {
    return _buildSectionCard(
      cardColor: cardColor,
      children: [
        Center(
          child: Column(
            children: [
              // App Logo
              Stack(
                children: [
                  Image.asset('assets/icon/icon-72.png'),
                  Opacity(
                    opacity: ColorHelper.getOpacity(Theme.of(context)),
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        ColorHelper.getIconColor(Theme.of(context)),
                        BlendMode.srcIn,
                      ),
                      child: Image.asset('assets/icon/icon-72.png'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: uiSizeX2),
              // App Name
              Text(
                packageInfo.appName,
                textScaler: const TextScaler.linear(uiTextScalerAboutAppTitle),
                style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
              ),

              const SizedBox(height: uiPadding),

              // Version Info
              Text(
                'Version ${packageInfo.version} (${packageInfo.buildNumber})',
                style: TextStyle(
                  fontSize: uiSizeX2,
                  color: textColor,
                ),
              ),

              const SizedBox(height: uiSizeX2),

              // App Description
              Text(
                'A simple, intuitive expense tracker app to help you manage your finances across multiple devices.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: uiSizeX2, color: textColor),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLinksSection(
    Color cardColor,
    Color? textColor,
    Color accentColor,
  ) {
    return _buildSectionCard(
      title: 'Links',
      cardColor: cardColor,
      children: [
        const LinkTile(
          title: "GitHub Repository",
          description: "View source code and contribute",
          link: "https://github.com/sunnydodti/expense-tracker",
          icon: Icons.code_outlined,
        ),
        const LinkTile(
          title: 'Release Notes',
          description: 'Check out the latest features',
          link: 'https://github.com/sunnydodti/expense-tracker/releases',
          icon: Icons.update_outlined,
        ),
        const LinkTile(
          title: 'Web App',
          description: 'Use Expense Tracker in your browser',
          link: 'https://expense-tracker.persist.site',
          icon: Icons.web_outlined,
        ),
      ],
    );
  }

  Widget _buildCreatorSection(
      Color cardColor, Color? textColor, Color accentColor) {
    return _buildSectionCard(
      title: 'Developer',
      cardColor: cardColor,
      children: [
        const CreditTile(
          name: 'Sunny Dodti',
          description: 'Software Engineer',
          link: 'https://sunnydodti.com',
        ),
        const LinkTile(
          title: 'Portfolio',
          description: 'See more projects',
          link: 'https://sunnydodti.com',
          icon: Icons.link_outlined,
        ),
        const LinkTile(
          title: 'Contact',
          description: 'Email the developer',
          link: 'mailto:sunny@persist.site',
          icon: Icons.alternate_email_outlined,
        ),
      ],
    );
  }

  Widget _buildCreditsSection(
      Color cardColor, Color? textColor, Color accentColor) {
    return _buildSectionCard(
      title: 'Credits & Thanks',
      cardColor: cardColor,
      children: [
        const CreditTile(
            name: 'Zara Qureshi',
            description: 'Bench Tester',
            link: 'https://github.com/ZaraQureshi'),
        Text(
          'Special thanks to everyone who provided feedback, reported bugs, and helped test the app.',
          style: TextStyle(fontStyle: FontStyle.italic, color: textColor),
        ),
      ],
    );
  }
}
