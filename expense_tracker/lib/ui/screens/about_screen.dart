import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/constants/db_constants.dart';
import '../../data/helpers/color_helper.dart';
import '../notifications/snackbar_service.dart';
import '../widgets/common/screen_app_bar.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  final PackageInfo _packageInfo = PackageInfo(
    appName: 'Expense Tracker',
    packageName: 'com.sunnydodti.expense_tracker',
    version: '${DBConstants.version.appVersion}-alpha',
    buildNumber: '1',
  );

  @override
  void initState() {
    super.initState();
    // _initPackageInfo();
  }

  // Future<void> _initPackageInfo() async {
  //   final info = await PackageInfo.fromPlatform();
  //   setState(() {
  //     _packageInfo = info;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = ColorHelper.getTileColor(theme);
    final textColor = ColorHelper.getButtonTextColor(theme);
    final accentColor = ColorHelper.getIconColor(theme);

    return Scaffold(
      appBar: const ScreenAppBar(title: 'About'),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          _buildAppInfoSection(cardColor, textColor, accentColor),
          const SizedBox(height: 4),
          _buildLinksSection(cardColor, textColor, accentColor),
          const SizedBox(height: 4),
          _buildCreatorSection(cardColor, textColor, accentColor),
          const SizedBox(height: 4),
          _buildCreditsSection(cardColor, textColor, accentColor),
        ],
      ),
    );
  }

  Widget _buildAppInfoSection(
      Color cardColor, Color? textColor, Color accentColor) {
    return Card(
      color: cardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
            const SizedBox(height: 16),
            // App Name
            Text(
              _packageInfo.appName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),

            const SizedBox(height: 8),

            // Version Info
            Text(
              'Version ${_packageInfo.version} (${_packageInfo.buildNumber})',
              style: TextStyle(
                fontSize: 16,
                color: textColor,
              ),
            ),

            const SizedBox(height: 16),

            // App Description
            Text(
              'A simple, intuitive expense tracker app to help you manage your finances across multiple devices.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLinksSection(
      Color cardColor, Color? textColor, Color accentColor) {
    return Card(
      color: cardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Links',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 16),
            _buildLinkItem(
              icon: Icons.code,
              title: 'GitHub Repository',
              subtitle: 'View source code and contribute',
              url: 'https://github.com/sunnydodti/expense-tracker',
              textColor: textColor,
              accentColor: accentColor,
            ),
            const Divider(),
            _buildLinkItem(
              icon: Icons.update,
              title: 'Release Notes',
              subtitle: 'Check out the latest features',
              url: 'https://github.com/sunnydodti/expense-tracker/releases',
              textColor: textColor,
              accentColor: accentColor,
            ),
            const Divider(),
            _buildLinkItem(
              icon: Icons.web,
              title: 'Web App',
              subtitle: 'Use Expense Tracker in your browser',
              url: 'https://expense-tracker.persist.site',
              textColor: textColor,
              accentColor: accentColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreatorSection(
      Color cardColor, Color? textColor, Color accentColor) {
    return Card(
      color: cardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Creator',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: accentColor,
                  radius: 30,
                  child: Text(
                    'SD',
                    style: TextStyle(
                      color: cardColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sunny Dodti',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Developer & Designer',
                        style: TextStyle(
                          fontSize: 14,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildLinkItem(
              icon: Icons.link,
              title: 'Portfolio',
              subtitle: 'See more projects',
              url: 'https://sunnydodti.com',
              textColor: textColor,
              accentColor: accentColor,
            ),
            const Divider(),
            _buildLinkItem(
              icon: Icons.alternate_email,
              title: 'Contact',
              subtitle: 'Email the developer',
              url: 'mailto:sunny@persist.site',
              textColor: textColor,
              accentColor: accentColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreditsSection(
      Color cardColor, Color? textColor, Color accentColor) {
    return Card(
      color: cardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Credits & Thanks',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 16),
            _buildCreditItem(
              name: 'Zara Qureshi',
              role: 'Bench Tester',
              link: 'https://github.com/ZaraQureshi',
              textColor: textColor,
              accentColor: accentColor,
              cardColor: cardColor,
            ),
            const SizedBox(height: 16),
            Text(
              'Special thanks to everyone who provided feedback, reported bugs, and helped test the app.',
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLinkItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String url,
    required Color? textColor,
    required Color accentColor,
  }) {
    return InkWell(
      onTap: () => _launchURL(url),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(
              icon,
              color: accentColor,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: textColor,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreditItem({
    required String name,
    required String role,
    required String? link,
    required Color? textColor,
    required Color accentColor,
    required Color cardColor,
  }) {
    String initials =
        name.split(" ").take(2).map((s) => s[0]).join().toUpperCase();
    return InkWell(
      onTap: link != null ? () => _launchURL(link) : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: accentColor,
              radius: 20,
              child: Text(
                initials,
                style: TextStyle(
                  color: cardColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                  Text(
                    role,
                    style: TextStyle(
                      fontSize: 14,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
            if (link != null)
              Icon(
                Icons.link,
                color: accentColor,
                size: 16,
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      SnackBarService.showErrorSnackBar('Could not launch $url');
    }
  }
}
