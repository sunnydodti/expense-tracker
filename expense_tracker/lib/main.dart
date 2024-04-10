import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/category_provider.dart';
import 'providers/expense_provider.dart';
import 'providers/tag_provider.dart';
import 'ui/screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      ],
      child: MaterialApp(
        theme: ThemeData(colorScheme: const ColorScheme.dark()),
        home: const HomePage(),
      ),
    );
  }
}
