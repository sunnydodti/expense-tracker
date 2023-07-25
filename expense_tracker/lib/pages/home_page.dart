// ignore_for_file: prefer_const_constructors

import 'package:expense_tracker/pages/expense_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _addExpense() {
    // if (_formKey.currentState.validate()) {
    print("clicked");
    // Open the new form.
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExpensePage(formMode: "Add"),
      ),
    );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.blue[50],
        drawer: SafeArea(child: Placeholder()),
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Row(
            children: <Widget>[
              Text(
                "body",
                style: TextStyle(
                  color: Colors.amber[900],
                  fontSize: 30,
                  fontFamily: 'Caveat',
                ),
              ),
              // Image(
              // image: NetworkImage(
              // 'https://images.unsplash.com/photo-1575936123452-b67c3203c357?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=870&q=80')),
              Image(image: AssetImage('assets/pic1.jpeg')),
              Image.asset('assets/pic1.jpeg'),
              Icon(Icons.abc_outlined)
            ],
          ),
          // child: Placeholder(),
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Add New Expense',
          onPressed: _addExpense,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
