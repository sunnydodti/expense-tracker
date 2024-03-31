import 'package:expense_tracker/providers/expense_provider.dart';
import 'package:expense_tracker/ui/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      ],
      child: MaterialApp(
        theme: ThemeData(
          // primarySwatch: Colors.grey,
          colorScheme: const ColorScheme.dark()
        ),
        home: const HomePage(),
      ),
    );
  }
}
