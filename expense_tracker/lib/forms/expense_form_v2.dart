import 'package:expense_tracker/builder/form_builder.dart';
import 'package:expense_tracker/data/database/database_helper.dart';
import 'package:expense_tracker/models/expense_new.dart';
import 'package:expense_tracker/models/transaction_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class ExpenseFormV2 extends StatefulWidget {
  const ExpenseFormV2({Key? key, required this.formMode}) : super(key: key);
  final String formMode;
  @override
  State<ExpenseFormV2> createState() => _ExpenseFormV2State();
}

class _ExpenseFormV2State extends State<ExpenseFormV2> {
  final _formKey = GlobalKey<FormState>();

  // ---------------------------------{ form data display --------------------------------- //
  static Map<String, String> currencies = FromBuilder.getCurrenciesListMap();
  // String defaultCurrency = FromBuilder.getCurrencyDropdownItems().first.value;
  String defaultCurrency = currencies.values.first;
  final List<String> tags = ['Item 1', 'Item 2', 'Item 3'];
  final List<String> selectedTags = [];
  var _value = false;
  // --------------------------------- form data display }--------------------------------- //

  // ---------------------------------{ form data input --------------------------------- //
  String? _userCurrency;
  // --------------------------------- form data input }--------------------------------- //

  // ---------------------------------{ controllers --------------------------------- //
  TextEditingController titleController = TextEditingController();
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
    titleController.text = '';
    currencyController.text = defaultCurrency;
    // amountController.text = '';
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
                getTitleField()
              ],
            ),
            Row(
              children: [
                getCurrencyField(),
                getAmountField(),
              ],
            ),
            Row(
              children: [
                getTransactionTypeField(),
                getDateField(context),
              ],
            ),
            Row(
              children: [
                getCategoryField(),
                getTagsField(),
              ],
            ),
            Row(
              children: [
                getNotesField()
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

  // ---------------------------------{ title --------------------------------- //
  Expanded getTitleField() {
    return Expanded(
                flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      controller: titleController,
                      maxLines: 1,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'Title',
                        suffixIcon: IconButton(
                          onPressed: () {
                            titleController.clear();
                          },
                          icon: const Icon(Icons.clear),
                        ),
                      ),
                      validator: (value) => validateField(value, "enter Title"),
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        debugPrint('title: $value');
                      },
                    ),
                  )
              );
  }
  // --------------------------------- title }--------------------------------- //

  // ---------------------------------{ notes --------------------------------- //
  Expanded getNotesField() {
    return Expanded(
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
                        debugPrint('note: $value');
                      },
                    ),
                  )
              );
  }
  // --------------------------------- notes }--------------------------------- //

  // --------------------------------- tags --------------------------------- //
  Expanded getTagsField() {
    return Expanded(
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
                    validator: (value) => validateField(value, "select tags"),
                    onChanged: (value) {
                      debugPrint('category: $value');
                    },
                  ),
                ),
              );
  }

  // --------------------------------- category --------------------------------- //
  Expanded getCategoryField() {
    return Expanded(
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
                      validator: (value) => validateField(value, "select category"),
                      onChanged: (value) {
                        debugPrint('category: $value');
                      },
                    )),
              );
  }

  // --------------------------------- date --------------------------------- //
  Expanded getDateField(BuildContext context) {
    return Expanded(
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
                            debugPrint(dateController.text);
                          });
                          debugPrint('date: $formattedDate');
                        } else {
                          debugPrint("Date is not selected");
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
                        debugPrint('Date: $value');
                      },
                    ),
                  ));
  }

  // --------------------------------- transaction type --------------------------------- //
  Expanded getTransactionTypeField() {
    return Expanded(
                flex: 1,
                child: Container(
                    padding: const EdgeInsets.all(10),
                    child: DropdownButtonFormField(
                      value: FromBuilder.getTransactionTypeDropdownItems()
                          .first.value,
                      items: FromBuilder.getTransactionTypeDropdownItems(),
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.monetization_on_outlined),
                        border: OutlineInputBorder(),
                        labelText: 'Transaction Type',
                      ),
                      validator: (value) => validateField(value, "select transaction type"),
                      onChanged: (value) {
                        debugPrint('transaction type : $value');
                        transactionTypeController.text = value!;
                        debugPrint(transactionTypeController.text);
                      },
                    )),
              );
  }

  // -------------------------------- amount --------------------------------- //
  Expanded getAmountField() {
    return Expanded(
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
                    validator: (value) => validateField(value, "enter amount"),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (value) {
                      debugPrint('amount: $value');
                    },
                  ),
                ),
              );
  }

  // ---------------------------------{ currency --------------------------------- //
  Expanded getCurrencyField() {
    return Expanded(
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
                        debugPrint('user currency: $_userCurrency');
                        debugPrint('currency controller: ' + currencyController.text);
                      },
                    )),
              );
  }
  // --------------------------------- currency }--------------------------------- //


  // ---------------------------------{ methods --------------------------------- //
  void _sumbitExpense() {
    // Validate the form
    if (_formKey.currentState?.validate() ?? false) {
      // Form is valid, perform your action
      debugPrint('submitting');
      debugPrint('currency: ${currencyController.text}');
      debugPrint('amount: ${amountController.text}');
      debugPrint('transaction type: ${transactionTypeController.text}');
      debugPrint('date: ${dateController.text}');
      debugPrint('category: ${categoryController.text}');
      debugPrint('tags: ${tagsController.text}');
      debugPrint('notes: ${notesController.text}');
      Expense expense = Expense(
          titleController.text,
          currencyController.text,
          double.parse(amountController.text),
          transactionTypeController.text,
          DateTime.parse(dateController.text),
          categoryController.text);
      expense.tags = tagsController.text;
      expense.note = notesController.text;
      insertExpense(expense).then((value) {
        if (value) {
          debugPrint("inserted");
          Navigator.pop(context, value);
        }}
      );
    }
  }

  Future<bool> insertExpense(Expense expense) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    await databaseHelper.initializeDatabase();
    await databaseHelper.insertExpense(expense);
    return true;
  }

  String? validateField(var value, String errorMessage) {
    if (value == null || value.isEmpty) {
      return 'Please $errorMessage';
    }
    // Add additional validation logic if needed
    return null; // Return null if the input is valid
  }
  // --------------------------------- methods }--------------------------------- //
}

