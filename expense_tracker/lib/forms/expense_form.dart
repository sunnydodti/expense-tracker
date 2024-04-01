import 'package:expense_tracker/builder/form_builder.dart';
import 'package:expense_tracker/forms/form_modes.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/service/expense_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../models/expense_new.dart';

class ExpenseForm extends StatefulWidget {
  final FormMode formMode;
  final Expense? expense;

  const ExpenseForm({Key? key, required this.formMode, this.expense})
      : super(key: key);

  @override
  State<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  final _formKey = GlobalKey<FormState>();

  //region Section 1: --------------------------------- form data display ---------------------------------
  late Map<String, String> _currencies;
  late String _defaultCurrency;
  late Color _highlightColor;

  final List<String> tags = ['Item 1', 'Item 2', 'Item 3'];
  final List<String> selectedTags = [];

  //endregion

  //region Section 2: --------------------------------- form data input ---------------------------------
  String? _userCurrency;

  //endregion

  //region Section 3: --------------------------------- controllers ---------------------------------
  TextEditingController titleController = TextEditingController();
  TextEditingController currencyController = TextEditingController();
  TextEditingController amountPrefixController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController transactionTypeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController tagsController = TextEditingController();
  TextEditingController notesController = TextEditingController();

  // TextEditingController containsNestedExpensesController =
  // TextEditingController();
  // TextEditingController expensesController = TextEditingController();
  //endregion

  //region Section 4: --------------------------------- methods ---------------------------------
  void _populateFormFieldsForEdit(Expense expense) {
    titleController.text = expense.title;
    currencyController.text = expense.currency;
    amountPrefixController.text = _currencies[expense.currency]!;
    amountController.text = expense.amount.toString();
    transactionTypeController.text = expense.transactionType;
    dateController.text = DateFormat('yyyy-MM-dd').format(expense.date);
    categoryController.text = expense.category;
    tagsController.text = expense.tags!;
    notesController.text = expense.note!;
  }

  void _populateFormFieldsWithDefaults() {
    {
      titleController.text = '';
      currencyController.text = _defaultCurrency;
      amountPrefixController.text = _currencies[_defaultCurrency]!;
      amountController.text = "";
      transactionTypeController.text =
          FromBuilder.getTransactionTypesList().first;
      dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
      categoryController.text = FromBuilder.getCategoriesList().first;
      tagsController.text = FromBuilder.getTagsList().first;
      notesController.text = '';
    }
  }

  //endregion

  //region Section 5: --------------------------------- initState ---------------------------------
  @override
  void initState() {
    super.initState();

    _currencies = FromBuilder.getCurrenciesListMap();
    _defaultCurrency = _currencies.keys.first;

    _highlightColor = Colors.green.shade300;

    if (widget.formMode == FormMode.edit) {
      _populateFormFieldsForEdit(widget.expense!);
      _highlightColor = Colors.orange.shade300;
    } else {
      _populateFormFieldsWithDefaults();
    }
  }

  //endregion

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Material(
      child: Theme(
        data: theme.copyWith(
            inputDecorationTheme: InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
            color: _highlightColor,
          )),
          prefixIconColor: _highlightColor,
          suffixIconColor: _highlightColor,
          labelStyle: TextStyle(
            color: _highlightColor, // Define your label color
          ),
        )),
        child: _getExpenseFormFields(context),
      ),
    );
  }

  Form _getExpenseFormFields(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            children: [getTitleField()],
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
            children: [getNotesField()],
          ),
          getSubmitButton(),
        ],
      ),
    );
  }

  ElevatedButton getSubmitButton() {
    return ElevatedButton(
      onPressed: _submitExpense,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(_highlightColor),
      ),
      child: Text((widget.formMode == FormMode.add) ? 'Submit' : 'Edit'),
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
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                color: _highlightColor,
              )),
              focusColor: _highlightColor,
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
        ));
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
        ));
  }

  // --------------------------------- notes }--------------------------------- //

  // --------------------------------- tags --------------------------------- //
  Expanded getTagsField() {
    return Expanded(
      flex: 1,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: DropdownButtonFormField(
          value: tagsController.text,
          items: FromBuilder.getTagsDropdownItems(),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Tags',
          ),
          validator: (value) => validateField(value, "select tags"),
          onChanged: (value) {
            debugPrint('tags: $value');
            tagsController.text = value;
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
            value: categoryController.text,
            items: FromBuilder.getCategoryDropdownItems(),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Category',
            ),
            validator: (value) => validateField(value, "select category"),
            onChanged: (value) {
              debugPrint('category: $value');
              categoryController.text = value;
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
                    DateFormat('yyyy-MM-dd HH:mm:ss').format(pickedDate);
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
            value: transactionTypeController.text,
            items: FromBuilder.getTransactionTypeDropdownItems(),
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.monetization_on_outlined),
              border: OutlineInputBorder(),
              labelText: 'Transaction Type',
            ),
            validator: (value) =>
                validateField(value, "select transaction type"),
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
            prefixText: amountPrefixController.text,
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

  // String? _getAmountPrefix() => (widget.expense != null) ? _currencies[widget.expense?.currency.toString()] : _currencies[_defaultCurrency.toString()];

  // ---------------------------------{ currency --------------------------------- //
  Expanded getCurrencyField() {
    return Expanded(
      flex: 3,
      child: Container(
          padding: const EdgeInsets.all(10),
          child: DropdownButtonFormField(
            value: currencyController.text,
            items: FromBuilder.getCurrencyDropdownItems(),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Currency',
            ),
            validator: (value) => validateField(value, "select currency"),
            onChanged: (value) {
              debugPrint('selected currency: $value');
              setState(() {
                _userCurrency = value;
                currencyController.text = value;
                amountPrefixController.text = _currencies[value]!;
              });

              debugPrint('user currency: $_userCurrency');
              debugPrint('currency controller: ${currencyController.text}');
              debugPrint(
                  'amountPrefix controller: ${amountPrefixController.text}');
            },
          )),
    );
  }

  // --------------------------------- currency }--------------------------------- //

  // ---------------------------------{ methods --------------------------------- //
  void _submitExpense() {
    if (_formKey.currentState?.validate() ?? false) {
      debugPrint('submitting');
      debugPrint('currency: ${currencyController.text}');
      debugPrint('amount: ${amountController.text}');
      debugPrint('transaction type: ${transactionTypeController.text}');
      debugPrint('date: ${dateController.text}');
      debugPrint('category: ${categoryController.text}');
      debugPrint('tags: ${tagsController.text}');
      debugPrint('notes: ${notesController.text}');

      ExpenseFormModel expense = ExpenseFormModel(
        titleController.text,
        currencyController.text,
        double.parse(amountController.text),
        transactionTypeController.text,
        DateTime.parse(dateController.text),
        categoryController.text,
        false,
      );

      expense.tags = tagsController.text;
      expense.note = notesController.text;
      expense.createdAt =
          widget.expense != null ? widget.expense!.createdAt : DateTime.now();
      expense.modifiedAt = DateTime.now();

      if (widget.formMode == FormMode.edit) {
        expense.id = widget.expense!.id;
        updateExpense(expense).then((value) {
          if (value) {
            debugPrint("Expense updated successfully");
            Navigator.pop(
                context, value);
          } else {
            debugPrint("Failed to update expense");
          }
        });
      } else {
        insertExpense(expense).then((value) {
          if (value) {
            debugPrint("inserted");
            Navigator.pop(context, value);
          }
        });
      }
    }
  }

  Future<bool> insertExpense(ExpenseFormModel expense) async {
    ExpenseService expenseService = ExpenseService();
    return await expenseService.addExpense(expense);
  }

  Future<bool> updateExpense(ExpenseFormModel expense) async {
    ExpenseService expenseService = ExpenseService();
    return await expenseService.updateExpense(expense);
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
