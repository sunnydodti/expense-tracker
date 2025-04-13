import 'package:flutter/material.dart';

import '../../data/helpers/color_helper.dart';
import '../../data/helpers/navigation_helper.dart';
import '../screens/category_screen.dart';
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
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.attach_money_outlined, size: 30),
                SizedBox(height: 20),
                Text("Expense Tracker")
              ],
            ),
          ),
          ListTile(
            title: const Text('Categories'),
            onTap: () => _navigateToCategoryScreen(context),
          ),
          ListTile(
            title: const Text('Tags'),
            onTap: () => _navigateToTagScreen(context),
          ),
          ListTile(
            title: const Text('Settings'),
            onTap: () => _navigateToSettingsScreen(context),
          ),
          ListTile(
            title: const Text('Profiles'),
            onTap: () => _navigateToProfileScreen(context),
          ),
        ],
      ),
    );
  }

  void _navigateToSettingsScreen(BuildContext context) =>
      NavigationHelper.navigateToScreen(context, const SettingsScreen());

  void _navigateToCategoryScreen(BuildContext context) =>
      NavigationHelper.navigateToScreen(context, const CategoryScreen());

  void _navigateToTagScreen(BuildContext context) =>
      NavigationHelper.navigateToScreen(context, const TagScreen());

  void _navigateToProfileScreen(BuildContext context) =>
      NavigationHelper.navigateToScreen(context, const ProfileScreen());
}
