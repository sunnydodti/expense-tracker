import 'package:expense_tracker/models/expense_category.dart';
import 'package:expense_tracker/service/category_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import '../builder/form_builder.dart';
import '../models/enums/form_modes.dart';
import '../models/expense.dart';
import '../models/tag.dart';
import '../service/expense_service.dart';
import '../service/tag_service.dart';

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

  static final Logger _logger =
      Logger(printer: SimplePrinter(), level: Level.info);

  final Future<CategoryService> _categoryService = CategoryService.create();
  final Future<TagService> _tagService = TagService.create();

  //region Section 1: --------------------------------- form data display ---------------------------------
  late Map<String, String> _currencies;
  late String _defaultCurrency;
  late Color _highlightColor;

  List<ExpenseCategory> _categories = [];
  ExpenseCategory? _selectedCategory;

  List<Tag> _tags = [];
  Tag? _selectedTag;

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
  TextEditingController notesController = TextEditingController();

  // TextEditingController containsNestedExpensesController =
  // TextEditingController();
  // TextEditingController expensesController = TextEditingController();
  //endregion

  //region Section 4: --------------------------------- methods ---------------------------------
  Future<void> _populateFormFieldsForEdit(Expense expense) async {
    titleController.text = expense.title;
    currencyController.text = expense.currency;
    amountPrefixController.text = _currencies[expense.currency]!;
    amountController.text = _formatAmount(expense.amount);
    transactionTypeController.text = expense.transactionType;
    dateController.text = DateFormat('yyyy-MM-dd').format(expense.date);
    notesController.text = expense.note!;

    CategoryService categoryService = await _categoryService;
    TagService tagService = await _tagService;

    List<ExpenseCategory> categories = await categoryService.getCategories();
    List<Tag> tags = await tagService.getTags();

    setState(() {
      _categories = categories;
      _tags = tags;

      _selectedCategory =
          categoryService.getMatchingCategory(expense.category, _categories);
      _selectedTag = tagService.getMatchingTag(expense.tags ?? "", _tags);
    });
  }

  String _formatAmount(double amount) {
    if (amount % 1 == 0) return amount.toInt().toString();
    return amount.toStringAsFixed(2);
  }

  void _populateFormFieldsWithDefaults() async {
    titleController.text = '';
    currencyController.text = _defaultCurrency;
    amountPrefixController.text = _currencies[_defaultCurrency]!;
    amountController.text = "";
    transactionTypeController.text =
        FromBuilder.getTransactionTypesList().first;
    dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    notesController.text = '';

    CategoryService categoryService = await _categoryService;
    TagService tagService = await _tagService;

    List<ExpenseCategory> categories = await categoryService.getCategories();
    List<Tag> tags = await tagService.getTags();

    setState(() {
      _categories = categories;
      _tags = tags;

      _selectedCategory = _categories.isNotEmpty ? _categories[0] : null;
      _selectedTag = _tags.isNotEmpty ? _tags[0] : null;
    });
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
            textTheme: Theme.of(context).textTheme.apply(
                  fontSizeFactor: .9,
                ),
            inputDecorationTheme: InputDecorationTheme(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 1),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                color: _highlightColor,
              )),
              prefixIconColor: _highlightColor,
              suffixIconColor: _highlightColor,
              labelStyle: TextStyle(
                color: _highlightColor,
              ),
            )),
        child: _getExpenseFormFields(context),
      ),
    );
  }

  Container _getExpenseFormFields(BuildContext context) {
    return Container(
      color: Colors.grey.shade900,
      child: Form(
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
          padding: _fieldPadding(),
          child: TextFormField(
            controller: titleController,
            maxLines: 1,
            decoration: InputDecoration(
              border: _fieldBorder(),
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
                icon: Icon(Icons.clear, size: _getIconSize()),
              ),
            ),
            validator: (value) => validateTextField(value, "enter Title"),
            keyboardType: TextInputType.text,
            onChanged: (value) {
              _logger.i('title: $value');
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
          padding: _fieldPadding(),
          child: TextFormField(
            controller: notesController,
            maxLines: 1,
            // textInputAction: TextInputAction.newline,
            // onEditingComplete: () {},
            decoration: InputDecoration(
              border: _fieldBorder(),
              prefixIcon: Icon(Icons.edit, size: _getIconSize()),
              labelText: 'Notes',
              suffixIcon: IconButton(
                onPressed: () {
                  notesController.clear();
                },
                icon: Icon(Icons.clear, size: _getIconSize()),
              ),
            ),
            keyboardType: TextInputType.text,
            onChanged: (value) {
              _logger.i('note: $value');
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
        padding: _fieldPadding(),
        child: DropdownButtonFormField<Tag>(
          isExpanded: true,
          value: _selectedTag,
          items: FromBuilder.getTagsDropdownItemsV2(_tags),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Tags',
          ),
          validator: (value) => validateTag("select tags"),
          onChanged: (value) {
            _logger.i('tags: $value');
            _selectedTag = value;
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
          padding: _fieldPadding(),
          child: DropdownButtonFormField<ExpenseCategory>(
            isExpanded: true,
            value: _selectedCategory,
            items: FromBuilder.getCategoryDropdownItemsV2(_categories),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Category',
            ),
            validator: (value) => validateCategory("select category"),
            onChanged: (value) {
              _logger.i('category: ${value!.name}');
              _selectedCategory = value;
            },
          )),
    );
  }

  // --------------------------------- date --------------------------------- //
  Expanded getDateField(BuildContext context) {
    return Expanded(
        flex: 1,
        child: Container(
          padding: _fieldPadding(),
          child: TextFormField(
            controller: dateController,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: 'Date',
              prefixIcon: Icon(Icons.calendar_today, size: _getIconSize()),
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
                  _logger.i(dateController.text);
                });
                _logger.i('date: $formattedDate');
              } else {
                _logger.i("Date is not selected");
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
              _logger.i('Date: $value');
            },
          ),
        ));
  }

  // --------------------------------- transaction type --------------------------------- //
  Expanded getTransactionTypeField() {
    return Expanded(
      flex: 1,
      child: Container(
          padding: _fieldPadding(),
          child: DropdownButtonFormField(
            isExpanded: true,
            value: transactionTypeController.text,
            items: FromBuilder.getTransactionTypeDropdownItems(),
            decoration: InputDecoration(
              prefixIcon:
                  Icon(Icons.monetization_on_outlined, size: _getIconSize()),
              border: const OutlineInputBorder(),
              labelText: 'Transaction Type',
            ),
            validator: (value) =>
                validateTextField(value, "select transaction type"),
            onChanged: (value) {
              _logger.i('transaction type : $value');
              transactionTypeController.text = value!;
              _logger.i(transactionTypeController.text);
            },
          )),
    );
  }

  // -------------------------------- amount --------------------------------- //
  Expanded getAmountField() {
    return Expanded(
      flex: 5,
      child: Container(
        padding: _fieldPadding(),
        child: TextFormField(
          controller: amountController,
          decoration: InputDecoration(
            border: _fieldBorder(),
            prefixText: amountPrefixController.text,
            labelText: 'Amount',
            suffixIcon: IconButton(
              onPressed: () {
                amountController.clear();
              },
              icon: const Icon(Icons.clear),
            ),
          ),
          validator: (value) => validateTextField(value, "enter amount"),
          keyboardType: const TextInputType.numberWithOptions(decimal: false),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}$')),
          ],
          onChanged: (value) {
            _logger.i('amount: $value');
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
          padding: _fieldPadding(),
          child: DropdownButtonFormField(
            isExpanded: true,
            value: currencyController.text,
            items: FromBuilder.getCurrencyDropdownItems(),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Currency',
            ),
            validator: (value) => validateTextField(value, "select currency"),
            onChanged: (value) {
              _logger.i('selected currency: $value');
              setState(() {
                _userCurrency = value;
                currencyController.text = value;
                amountPrefixController.text = _currencies[value]!;
              });

              _logger.i('user currency: $_userCurrency');
              _logger.i('currency controller: ${currencyController.text}');
              _logger
                  .d('amountPrefix controller: ${amountPrefixController.text}');
            },
          )),
    );
  }

  // --------------------------------- currency }--------------------------------- //

  // ---------------------------------{ methods --------------------------------- //

  EdgeInsets _fieldPadding() => const EdgeInsets.all(6);

  OutlineInputBorder _fieldBorder() => const OutlineInputBorder();

  double _getIconSize() => 20;

  void _submitExpense() {
    if (_formKey.currentState?.validate() ?? false) {
      _logger.i('submitting');
      _logger.i('currency: ${currencyController.text}');
      _logger.i('amount: ${amountController.text}');
      _logger.i('transaction type: ${transactionTypeController.text}');
      _logger.i('date: ${dateController.text}');
      _logger.i('category: ${_selectedCategory?.name}');
      _logger.i('tags: ${_selectedTag?.name}');
      _logger.i('notes: ${notesController.text}');

      ExpenseFormModel expense = ExpenseFormModel(
        titleController.text,
        currencyController.text,
        double.parse(amountController.text),
        transactionTypeController.text,
        DateTime.parse(dateController.text),
        _selectedCategory!.name,
        false,
      );

      expense.tags = _selectedTag!.name;
      expense.note = notesController.text;

      if (widget.formMode == FormMode.edit) {
        expense.id = widget.expense!.id;
        updateExpense(expense).then((value) {
          if (value) {
            _logger.i("Expense updated successfully");
            Navigator.pop(context, value);
          } else {
            _logger.i("Failed to update expense");
          }
        });
      } else {
        insertExpense(expense).then((value) {
          if (value) {
            _logger.i("inserted");
            Navigator.pop(context, value);
          }
        });
      }
    }
  }

  Future<bool> insertExpense(ExpenseFormModel expense) async {
    ExpenseService expenseService = await ExpenseService.create();
    return await expenseService.addExpense(expense);
  }

  Future<bool> updateExpense(ExpenseFormModel expense) async {
    ExpenseService expenseService = await ExpenseService.create();
    return await expenseService.updateExpense(expense);
  }

  String? validateTextField(var value, String errorMessage) {
    if (value == null || value.isEmpty) {
      return 'Please $errorMessage';
    }
    // Add additional validation logic if needed
    return null; // Return null if the input is valid
  }

  String? validateCategory(String errorMessage) {
    if (_selectedCategory == null) {
      return 'Please $errorMessage';
    }
    return null;
  }

  String? validateTag(String errorMessage) {
    if (_selectedTag == null) {
      return 'Please $errorMessage';
    }
    return null;
  }
// --------------------------------- methods }--------------------------------- //
}
