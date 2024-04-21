import 'package:flutter/material.dart';

import '../screens/category_screen.dart';
import '../screens/settings_screen.dart';
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
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Menu'),
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
          ],
        ),
      ),
    );
  }

  void _navigateToSettingsScreen(BuildContext context) =>
      _navigateToScreen(context, const SettingsScreen());

  void _navigateToCategoryScreen(BuildContext context) =>
      _navigateToScreen(context, const CategoryScreen());

  void _navigateToTagScreen(BuildContext context) =>
      _navigateToScreen(context, const TagScreen());

  void _navigateToScreen(BuildContext context, Widget screenWidget) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => screenWidget,
      ),
    );
  }
}
