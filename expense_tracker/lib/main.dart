import 'package:expense_tracker/ui/pages/home_page.dart';
import 'package:flutter/material.dart';

// import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// ...

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(
        // primarySwatch: Colors.grey,
        colorScheme: const ColorScheme.dark()
      ),
      
      home: HomePage(title: 'Expense Tracker'),
    );
  }
}
