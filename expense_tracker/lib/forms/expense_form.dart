import 'package:expense_tracker/forms/tags_dialog.dart';
import 'package:expense_tracker/model/expense.dart';
import 'package:expense_tracker/model/transaction_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:expense_tracker/builder/form_builder.dart';
import 'package:intl/intl.dart';

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
  String? _userCurrency;
  double? _userAmount;
  TransactionType? _userTransactionType;
  String? _userCategory;
  List<String>? _userTags;
  DateTime? _userDate;
  String? _userNote;
  bool? _userContainsNestedExpenses;
  List<Expense>? _userExpenses;
  // --------------------------------- controllers --------------------------------- //
  TextEditingController currencyController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController transactionTypeController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController tagsController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController containsNestedExpensesController =
      TextEditingController();
  TextEditingController expensesController = TextEditingController();

  //--------------------------------- methods --------------------------------- //

  // --------------------------------- initState --------------------------------- //
  @override
  void initState() {
    super.initState();

    _userCurrency = currencies.values.first;

    currencyController.text = defaultCurrency;
    amountController.text = '';
    transactionTypeController.text = '';
    categoryController.text = '';
    tagsController.text = '';
    dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    noteController.text = '';
    containsNestedExpensesController.text = '';
    expensesController.text = '';
  }

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
                        value:
                            FromBuilder.getCurrencyDropdownItems().first.value,
                        items: FromBuilder.getCurrencyDropdownItems(),
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
                          icon: const Icon(Icons.clear),
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
                        value: FromBuilder.getTransactionTypeDropdownItems()
                            .first
                            .value,
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
                        value:
                            FromBuilder.getCategoryDropdownItems().first.value,
                        items: FromBuilder.getCategoryDropdownItems(),
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
                // --------------------------------- date --------------------------------- //
                Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        controller: dateController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Date',
                          // prefix: const Icon(Icons.calendar_today),
                          // suffix: IconButton(
                          //     icon: const Icon(Icons.clear),
                          //     onPressed: () {
                          //       dateController.clear();
                          //     }),
                        ),
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
