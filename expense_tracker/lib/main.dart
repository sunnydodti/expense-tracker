import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/category_provider.dart';
import 'providers/expense_items_provider.dart';
import 'providers/expense_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/sort_filter_provider.dart';
import 'providers/tag_provider.dart';
import 'providers/theme_provider.dart';
import 'service/shared_preferences_service.dart';
import 'ui/responsive/desktop_scaffold.dart';
import 'ui/responsive/mobile_scaffold.dart';
import 'ui/responsive/responsive_layout.dart';
import 'ui/responsive/tablet_scaffold.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SharedPreferencesService().initializeSharedPreferences();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => ExpenseProvider()),
        ChangeNotifierProvider(create: (context) => ExpenseItemsProvider()),
        ChangeNotifierProvider(create: (context) => CategoryProvider()),
        ChangeNotifierProvider(create: (context) => TagProvider()),
        ChangeNotifierProvider(create: (context) => SortFilterProvider()),
        ChangeNotifierProvider(create: (context) => SettingsProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            key: navigatorKey,
            theme: themeProvider.themeData,
            home: Consumer<ThemeProvider>(
                builder: (context, themeProvider, child) =>
                    const ResponsiveLayout(
                        mobileScaffold: MobileScaffold(),
                        tabletScaffold: TabletScaffold(),
                        desktopScaffold: DesktopScaffold())),
          );
        },
      ),
    );
  }
}
