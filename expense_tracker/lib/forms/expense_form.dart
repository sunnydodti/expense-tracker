import 'package:expense_tracker/forms/tags_dialog.dart';
import 'package:expense_tracker/model/expense.dart';
import 'package:expense_tracker/model/transaction_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:expense_tracker/builder/form_builder.dart';

class ExpenseForm extends StatefulWidget {
  const ExpenseForm({Key? key, required this.formMode}) : super(key: key);
  final String formMode;
  @override
  _ExpenseFormState createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  final _formKey = GlobalKey<FormState>();

  // --------------------------------- form data display --------------------------------- //
  // creata a dictionary of common currencies
  static Map<String, String> currencies = FromBuilder.getCurrenciesList();
  String defaultCurrency = currencies.values.first;
  final List<String> tags = ['Item 1', 'Item 2', 'Item 3'];
  final List<String> selectedTags = [];
  var _value = false;

  // --------------------------------- form data input --------------------------------- //
  String _userCurrency = currencies.values.first;
  double? _userAmount;
  TransactionType? _userTransactionType;
  String? _userCategory;
  List<String>? _userTags;
  DateTime? _userTimestamp;
  String? _userNote;
  bool? _userContainsNestedExpenses;
  List<Expense>? _userExpenses;
  // --------------------------------- controllers --------------------------------- //
  TextEditingController currencyController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController transactionTypeController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController tagsController = TextEditingController();
  TextEditingController timestampController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController containsNestedExpensesController =
      TextEditingController();
  TextEditingController expensesController = TextEditingController();

  //--------------------------------- methods --------------------------------- //

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Row(
              children: [
                // --------------------------------- currency --------------------------------- //
                Expanded(
                  flex: 1,
                  child: Container(
                      padding: const EdgeInsets.all(10),
                      child: DropdownButtonFormField(
                        items: currencies.entries
                            .map((e) => DropdownMenuItem(
                                  value: e.key,
                                  child: Text("(${e.value}) ${e.key}"),
                                ))
                            .toList(),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'currency',
                        ),
                        onChanged: (value) {
                          print('currency: $value');
                          setState(() {
                            _userCurrency = currencies[value.toString()]!;
                          });
                        },
                      )),
                ),
                // --------------------------------- amount --------------------------------- //
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      controller: amountController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        prefixText: _userCurrency ?? defaultCurrency,
                        labelText: 'Amount',
                        suffixIcon: IconButton(
                          onPressed: () {
                            amountController.clear();
                          },
                          icon: Icon(Icons.clear),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (value) {
                        print('amount: $value');
                      },
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  // --------------------------------- transaction type --------------------------------- //
                  child: Container(
                      padding: const EdgeInsets.all(10),
                      child: DropdownButtonFormField(
                        items: FromBuilder.getTransactionTypeDropdownItems(),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Transaction Type',
                        ),
                        onChanged: (value) {
                          print('transaction type: $value');
                        },
                      )),
                ),
              ],
            ),
            Row(
              children: [
                // --------------------------------- category --------------------------------- //
                Expanded(
                  flex: 3,
                  child: Container(
                      padding: const EdgeInsets.all(10),
                      child: DropdownButtonFormField(
                        items: FromBuilder.getCategoriesList().map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Category',
                        ),
                        onChanged: (value) {
                          print('category: $value');
                        },
                      )),
                ),
                // --------------------------------- tags --------------------------------- //
                Expanded(
                  flex: 2,
                  // add child widget ths lets user select tags
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: TagsDialog(),
                  ),
                ),
                // --------------------------------- timestamp --------------------------------- //
                Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        controller: timestampController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'timestamp',
                        ),
                        keyboardType: TextInputType.datetime,
                        onChanged: (value) {
                          print('timestamp: $value');
                        },
                      ),
                    )),
                // --------------------------------- tags --------------------------------- //
              ],
            ),
            // currency
          ],
        ),
      ),
    );
  }
}
