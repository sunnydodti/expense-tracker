import 'package:expense_tracker/providers/sort_filter_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/helpers/shared_preferences_helper.dart';
import 'providers/category_provider.dart';
import 'providers/expense_provider.dart';
import 'providers/tag_provider.dart';
import 'ui/screens/home_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await SharedPreferencesHelper.initializeSharedPreferences();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ExpenseProvider()),
        ChangeNotifierProvider(create: (context) => CategoryProvider()),
        ChangeNotifierProvider(create: (context) => TagProvider()),
        ChangeNotifierProvider(create: (context) => SortFilterProvider()),
      ],
      child: MaterialApp(
        key: navigatorKey,
        theme: ThemeData(colorScheme: const ColorScheme.dark()),
        home: const HomePage(),
      ),
    );
  }
}
