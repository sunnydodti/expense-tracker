import 'package:expense_tracker/builder/form_builder.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/models/transaction_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class ExpenseFormV2 extends StatefulWidget {
  // const ExpenseFormV2({super.key});
  const ExpenseFormV2({Key? key, required this.formMode}) : super(key: key);
  final String formMode;
  @override
  State<ExpenseFormV2> createState() => _ExpenseFormV2State();
}

class _ExpenseFormV2State extends State<ExpenseFormV2> {
  final _formKey = GlobalKey<FormState>();

  // ---------------------------------{ form data display --------------------------------- //
  // creata a dictionary of common currencies
  static Map<String, String> currencies = FromBuilder.getCurrenciesListMap();
  // String defaultCurrency = FromBuilder.getCurrencyDropdownItems().first.value;
  String defaultCurrency = currencies.values.first;
  final List<String> tags = ['Item 1', 'Item 2', 'Item 3'];
  final List<String> selectedTags = [];
  var _value = false;
  // --------------------------------- form data display }--------------------------------- //

  // ---------------------------------{ form data input --------------------------------- //
  String? _userCurrency;
  double? _userAmount;
  TransactionType? _userTransactionType;
  String? _userCategory;
  List<String>? _userTags;
  DateTime? _userDate;
  String? _userNote;
  bool? _userContainsNestedExpenses;
  List<Expense>? _userExpenses;
  // --------------------------------- form data input }--------------------------------- //

  // ---------------------------------{ controllers --------------------------------- //
  TextEditingController currencyController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController transactionTypeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController tagsController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  // TextEditingController containsNestedExpensesController =
  // TextEditingController();
  // TextEditingController expensesController = TextEditingController();
  // --------------------------------- controllers }--------------------------------- //

  //---------------------------------{ methods --------------------------------- //
  //--------------------------------- methods }--------------------------------- //


  // ---------------------------------{ initState --------------------------------- //
  @override
  void initState() {
    super.initState();
    currencyController.text = defaultCurrency;
    amountController.text = '';
    transactionTypeController.text = FromBuilder.getTransactionTypesList().first;
    dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    categoryController.text = FromBuilder.getCategoriesList().first;
    tagsController.text = FromBuilder.getTagsList().first;
    notesController.text = '';
    // containsNestedExpensesController.text = '';
    // expensesController.text = '';
  }
  // --------------------------------- initState --------------------------------- //


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
                  flex: 3,
                  child: Container(
                      padding: const EdgeInsets.all(10),
                      child: DropdownButtonFormField(
                        value: FromBuilder.getCurrencyDropdownItems().first.value,
                        items: FromBuilder.getCurrencyDropdownItems(),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Currency',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select currency';
                          }
                          // Add additional validation logic if needed
                          return null; // Return null if the input is valid
                        },
                        onChanged: (value) {
                          setState(() {
                            _userCurrency = currencies[value.toString()]!;
                            currencyController.text = _userCurrency!;
                          });
                          print('user currency: $_userCurrency');
                          print('currency controller: ' + currencyController.text);
                        },
                      )),
                ),
                // -------------------------------- amount --------------------------------- //
                Expanded(
                  flex: 5,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      controller: amountController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        prefixText: _userCurrency ?? defaultCurrency,
                        labelText: 'Amount',
                        suffixIcon: IconButton(
                          onPressed: () {
                            amountController.clear();
                          },
                          icon: const Icon(Icons.clear),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter amount';
                        }
                        // You can add additional validation logic here
                        return null; // Return null if the input is valid
                      },
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (value) {
                        print('amount: $value');
                      },
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                // --------------------------------- transaction type --------------------------------- //
                Expanded(
                  flex: 1,
                  child: Container(
                      padding: const EdgeInsets.all(10),
                      child: DropdownButtonFormField(
                        value: FromBuilder.getTransactionTypeDropdownItems()
                            .first.value,
                        items: FromBuilder.getTransactionTypeDropdownItems(),
                        decoration: const InputDecoration(
                          prefixIcon: const Icon(Icons.monetization_on_outlined),
                          border: OutlineInputBorder(),
                          labelText: 'Transaction Type',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select transaction type';
                          }
                          // Add additional validation logic if needed
                          return null; // Return null if the input is valid
                        },
                        onChanged: (value) {
                          print('transaction type : $value');
                          transactionTypeController.text = value!;
                          print(transactionTypeController.text);
                        },
                      )),
                ),
                // --------------------------------- date --------------------------------- //
                Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        controller: dateController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Date',
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select date';
                          }
                          // Add additional validation logic if needed
                          return null; // Return null if the input is valid
                        },
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101));
                          if (pickedDate != null) {
                            String formattedDate =
                            DateFormat('yyyy-MM-dd HH:mm:ss')
                                .format(pickedDate);
                            setState(() {
                              dateController.text = formattedDate;
                              print(dateController.text);
                            });
                            print('date: $formattedDate');
                          } else {
                            print("Date is not selected");
                          }

                          if (pickedDate != null) {
                            setState(() {
                              dateController.text =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);
                            });
                          } else {
                            // dateController.text =
                            //     DateFormat('yyyy-MM-dd').format(DateTime.now());
                          }
                        },
                        // keyboardType: TextInputType.datetime,
                        onChanged: (value) {
                          print('Date: $value');
                        },
                      ),
                    )),
              ],
            ),
            Row(
              children: [
                // --------------------------------- category --------------------------------- //
                Expanded(
                  flex: 1,
                  child: Container(
                      padding: const EdgeInsets.all(10),
                      child: DropdownButtonFormField(
                        value:
                        FromBuilder.getCategoryDropdownItems().first.value,
                        items: FromBuilder.getCategoryDropdownItems(),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Category',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select category';
                          }
                          // Add additional validation logic if needed
                          return null; // Return null if the input is valid
                        },
                        onChanged: (value) {
                          print('category: $value');
                        },
                      )),
                ),
                // --------------------------------- tags --------------------------------- //
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: DropdownButtonFormField(
                      value: FromBuilder.getTagsDropdownItems().first.value,
                      items: FromBuilder.getTagsDropdownItems(),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Tags',
                      ),
                      onChanged: (value) {
                        print('category: $value');
                      },
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        controller: notesController,
                        maxLines: 1,
                        // textInputAction: TextInputAction.newline,
                        // onEditingComplete: () {},
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.edit),
                          labelText: 'Notes',
                          suffixIcon: IconButton(
                            onPressed: () {
                              notesController.clear();
                            },
                            icon: const Icon(Icons.clear),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          print('note: $value');
                        },
                      ),
                    )
                )
              ],
            ),
            ElevatedButton(
              onPressed: _sumbitExpense,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  void _sumbitExpense() {
    // Validate the form
    if (_formKey.currentState?.validate() ?? false) {
      // Form is valid, perform your action
      print('submitting');
      print('currency: ${currencyController.text}');
      print('amount: ${amountController.text}');
      print('transaction type: ${transactionTypeController.text}');
      print('date: ${dateController.text}');
      print('category: ${categoryController.text}');
      print('tags: ${tagsController.text}');
      print('notes: ${notesController.text}');

      // Navigator.pop(context);
    }
  }
}
