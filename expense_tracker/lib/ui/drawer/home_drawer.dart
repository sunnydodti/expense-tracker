import 'package:flutter/material.dart';

import '../../data/helpers/color_helper.dart';
import '../../data/helpers/navigation_helper.dart';
import '../screens/category_screen.dart';
import '../screens/charts_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/tag_screen.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({super.key});

  @override
  HomeDrawerState createState() => HomeDrawerState();
}

class HomeDrawerState extends State<HomeDrawer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Drawer(
      backgroundColor: ColorHelper.getBackgroundColor(theme),
      width: 250,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: ColorHelper.getTileColor(theme),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Image.asset('assets/icon/icon-72.png'),
                    Opacity(
                      opacity: _getOpacity,
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          ColorHelper.getIconColor(theme),
                          BlendMode.srcIn,
                        ),
                        child: Image.asset('assets/icon/icon-72.png'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text("Expense Tracker")
              ],
            ),
          ),
          if (NavigationHelper.isLargeScreen(context))
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Home'),
              onTap: () => _navigateToHomeScreen(context),
            ),
          ListTile(
            leading: const Icon(Icons.category_outlined),
            title: const Text('Categories'),
            onTap: () => _navigateToCategoryScreen(context),
          ),
          ListTile(
            leading: const Icon(Icons.label_outline),
            title: const Text('Tags'),
            onTap: () => _navigateToTagScreen(context),
          ),
          ListTile(
            title: const Text('Settings'),
            leading: const Icon(Icons.settings_outlined),
            onTap: () => _navigateToSettingsScreen(context),
          ),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Profiles'),
            onTap: () => _navigateToProfileScreen(context),
          ),
          ListTile(
            leading: const Icon(Icons.pie_chart_outline),
            title: const Text('Charts'),
            onTap: () => _navigateToChartsScreen(context),
          ),
        ],
      ),
    );
  }

  double get _getOpacity {
    return Theme.of(context).brightness == Brightness.light ? 0.6 : 0;
  }

  void _navigateToHomeScreen(BuildContext context) =>
      NavigationHelper.navigateToHomeScreen(context);

  void _navigateToSettingsScreen(BuildContext context) =>
      NavigationHelper.navigateToScreen(context, const SettingsScreen());

  void _navigateToCategoryScreen(BuildContext context) =>
      NavigationHelper.navigateToScreen(context, const CategoryScreen());

  void _navigateToTagScreen(BuildContext context) =>
      NavigationHelper.navigateToScreen(context, const TagScreen());

  void _navigateToProfileScreen(BuildContext context) =>
      NavigationHelper.navigateToScreen(context, const ProfileScreen());

  void _navigateToChartsScreen(BuildContext context) =>
      NavigationHelper.navigateToScreen(
          context, const ChartsScreen(refreshData: true));
}
