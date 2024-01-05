// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:expense_tracker/data/samples/get_sample_data.dart';
import 'package:expense_tracker/pages/expense_page.dart';
import 'package:flutter/material.dart';

import '../models/expense_new.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var expenseCount = 1;
  final List<Expense> expenses = [
    Expense("_title", "_currency", 651, "_transactionType", DateTime.now(), "_category")
  ];

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
      theme: ThemeData(
        // primarySwatch: Colors.grey,
        colorScheme: ColorScheme.dark()
      ),
      home: Scaffold(
        drawer: SafeArea(child: Placeholder()),
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.title),
          // backgroundColor: Colors.black87,
          // foregroundColor: Colors.grey,
          actions: [
            IconButton(
              icon: Icon(Icons.person),
              tooltip: "Profile",
              onPressed: () => {},
            ),
          ],
        ),
        body:  getExpenseListView(),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Add New Expense',
          onPressed: _addExpense,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  ListView getExpenseListView() {
    TextStyle? textStyle = Theme.of(context).textTheme.bodyMedium;

    // Parse the JSON data (replace with your actual data source if needed)
    final jsonString = '''
    [
    {
        "id": "1",
        "title":"expense 1",
        "timestamp": "2019-01-01 00:00:00",
        "currency": "INR",
        "amount": "10.00",
        "transactionType": "expense",
        "date":"2024-01-17",
        "category": "food",
        "tags": "Pizza",
        "note": "Pizza Hut",
        "containsNestedExpenses": "false",
        "expenses": []
    },
    {
        "id": "2",
        "title": "expense 2",
        "timestamp": "2018-01-01 00:00:00",
        "currency": "INR",
        "amount": "1000.00",
        "transactionType": "expense",
        "date": "2024-01-17",
        "category": "party",
        "tags": "",
        "note": "at home",
        "containsNestedExpenses": "false",
        "expenses": []
    }
]
  ''';
    final parsedJson = jsonDecode(jsonString) as List<dynamic>;
    // final expenses = parsedJson.cast<Map<String, dynamic>>().toList();

    List<Map<String, dynamic>> expenses = [
      {
        "id": "1",
        "title": "expense 1",
        "timestamp": "2019-01-01 00:00:00",
        "currency": "INR",
        "amount": "10.00",
        "transactionType": "expense",
        "date": "2024-01-17",
        "category": "food",
        "tags": "Pizza",
        "note": "Pizza Hut",
        "containsNestedExpenses": "false",
        "expenses": []
      },
      {
        "id": "2",
        "title": "expense 2",
        "timestamp": "2018-01-01 00:00:00",
        "currency": "INR",
        "amount": "1000.00",
        "transactionType": "expense",
        "date": "2024-01-17",
        "category": "party",
        "tags": "",
        "note": "at home",
        "containsNestedExpenses": "false",
        "expenses": []
      },
      // Add 8 more copies of the above data
      ...List.generate(
        8,
            (index) => {
          "id": "${index + 3}", // Incrementing the id for uniqueness
          "title": "expense ${index + 3}",
          "timestamp": "2022-01-01 00:00:00", // Update timestamp as needed
          "currency": "USD", // Update currency as needed
          "amount": "20.00", // Update amount as needed
          "transactionType": "expense",
          "date": "2024-01-17", // Update date as needed
          "category": "misc", // Update category as needed
          "tags": "Tag ${index + 3}", // Update tags as needed
          "note": "Note ${index + 3}", // Update note as needed
          "containsNestedExpenses": "false",
          "expenses": []
        },
      ),
    ];
    final randomExpenseDataList = expenses.sublist(0, 10); // Get 10 random expense items

    return ListView.builder(
      itemCount: randomExpenseDataList.length,
      itemBuilder: (context, index) {
        final expenseData = randomExpenseDataList[index];

        return GestureDetector(
          onTap: () => _openEditingForm(), // Pass the specific expense data
          child: Column(
            children: [
              ListTile(
                title: Text(expenseData['title']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.category),
                    Text(expenseData['category']),
                  ],
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.tag),
                  Expanded(
                    child: Text(expenseData['tags']),
                  ),
                ],
              ),
              ListTile(
                title: Text(expenseData['note']),
                trailing: SizedBox(
                  width: 120,
                  child: Text(
                    '${double.parse(expenseData['amount']) > 0 ? '+' : '-'}'
                        '${double.parse(expenseData['amount']).toStringAsFixed(2)}',
                    style: TextStyle(
                      color: double.parse(expenseData['amount']) > 0 ? Colors.green : Colors.red,
                    ),
                  ),
                ),
              ),
              const Divider(),
            ],
          ),
        );
      },
    );


  }

  void _openEditingForm() {
    // Implement logic to open the editing form with expense data
  }
}
