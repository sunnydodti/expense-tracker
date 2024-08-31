import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/category_provider.dart';
import 'providers/chart_data_provider.dart';
import 'providers/expense_items_provider.dart';
import 'providers/expense_provider.dart';
import 'providers/profile_provider.dart';
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
  bool refreshTheme = true;
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool refreshTheme = true;

  refreshAppTheme(ThemeProvider themeProvider) async {
    if (refreshTheme) {
      await themeProvider.refreshTheme();
      refreshTheme = false;
    }
  }

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
        ChangeNotifierProvider(create: (context) => ChartDataProvider()),
        ChangeNotifierProvider(create: (context) => ProfileProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return FutureBuilder<void>(
            future: refreshAppTheme(themeProvider),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return MaterialApp(
                  key: navigatorKey,
                  theme: themeProvider.themeData,
                  home: const ResponsiveLayout(
                      mobileScaffold: MobileScaffold(),
                      tabletScaffold: TabletScaffold(),
                      desktopScaffold: DesktopScaffold()),
                );
              }
            },
          );
        },
      ),
    );
  }
}
