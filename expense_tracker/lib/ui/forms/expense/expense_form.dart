import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../../data/constants/form_constants.dart';
import '../../../models/enums/form_modes.dart';
import '../../../models/expense.dart';
import '../../../models/expense_category.dart';
import '../../../models/tag.dart';
import '../../../providers/expense_items_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../../service/category_service.dart';
import '../../../service/expense_service.dart';
import '../../../service/tag_service.dart';
import '../../dialogs/common/date_picker_dialog.dart';
import '../../widgets/expense/expense_item/expense_item_list.dart';
import '../../widgets/expense/expense_widgets.dart';
import 'expense_item_form.dart';

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

  //region Section 1: formData
  late Map<String, String> _currencies;
  late String _defaultCurrency;
  late Color _highlightColor;
  late bool _containsExpenseItems;

  List<ExpenseCategory> _categories = [];
  ExpenseCategory? _selectedCategory;

  List<Tag> _tags = [];
  Tag? _selectedTag;

  //endregion

  //region Section 2: controllers
  TextEditingController titleController = TextEditingController();
  TextEditingController currencyController = TextEditingController();
  TextEditingController amountPrefixController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController transactionTypeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController notesController = TextEditingController();

  //endregion

  //region Section 3: initState
  @override
  void initState() {
    super.initState();
    _currencies = FormConstants.expense.currencies;

    _highlightColor = Colors.green.shade300;
    _containsExpenseItems = false;

    if (widget.formMode == FormMode.edit) {
      _populateFormFieldsForEdit(widget.expense!);
      _highlightColor = Colors.orange.shade300;
    } else {
      _populateFormFieldsWithDefaults();
    }
  }

  //endregion

  //region Section 4: initStateMethods
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
    if (mounted) {
      final expenseItemProvider =
          Provider.of<ExpenseItemsProvider>(context, listen: false);
      expenseItemProvider.fetchExpenseItems(expenseId: expense.id);
    }
    setState(() {
      _categories = categories;
      _tags = tags;

      _selectedCategory =
          categoryService.getMatchingCategory(expense.category, _categories);
      _selectedTag = tagService.getMatchingTag(expense.tags ?? "", _tags);
      _containsExpenseItems = expense.containsExpenseItems;
    });
  }

  String _formatAmount(double amount) {
    if (amount % 1 == 0) return amount.toInt().toString();
    return amount.toStringAsFixed(2);
  }

  void _populateFormFieldsWithDefaults() async {
    titleController.text = '';
    amountController.text = "";
    transactionTypeController.text =
        FormConstants.expense.transactionTypes.first;
    dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    notesController.text = '';

    CategoryService categoryService = await _categoryService;
    TagService tagService = await _tagService;

    List<ExpenseCategory> categories = await categoryService.getCategories();
    List<Tag> tags = await tagService.getTags();
    _defaultCurrency = await getDefaultCurrency();

    currencyController.text = _defaultCurrency;
    amountPrefixController.text = _currencies[_defaultCurrency]!;

    setState(() {
      _categories = categories;
      _tags = tags;

      _selectedCategory = _categories.isNotEmpty ? _categories[0] : null;
      _selectedTag = _tags.isNotEmpty ? _tags[0] : null;
    });
  }

  //endregion

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Theme(
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
        child: _buildExpenseFormFields(context),
      ),
    );
  }

  //region Section 5: formFields
  Container _buildExpenseFormFields(BuildContext context) {
    return Container(
      color: Colors.grey.shade900,
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            _buildTitleField(),
            _buildAmountField(),
            _buildTransactionTypeField(),
            _buildDateField(),
            _buildCategoryField(),
            _buildTagsField(),
            _buildNotesField(),
            _buildExpenseItemsToggle(),
            if (_containsExpenseItems) _buildExpenseItemForm(),
            if (_containsExpenseItems) _buildExpenseItemsList(),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  ExpenseItemsList _buildExpenseItemsList() => ExpenseItemsList(
      currency: '${amountPrefixController.text} ',
      expenseTitle: titleController.text);

  ExpenseItemForm _buildExpenseItemForm() =>
      ExpenseItemForm(currency: '${amountPrefixController.text} ');

  Widget _buildExpenseItemsToggle() {
    return SwitchListTile(
      dense: true,
      visualDensity: const VisualDensity(vertical: -2),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      title: const Text("Add Expense Items"),
      value: _containsExpenseItems,
      onChanged: (value) => _toggleExpenseItems(value),
    );
  }

  Container _buildSubmitButton() {
    return ExpenseWidgets.form
        .buildSubmitButton(_submitExpense, widget.formMode, _highlightColor);
  }

  Container _buildTitleField() {
    return ExpenseWidgets.form.buildTitleField(titleController);
  }

  Container _buildAmountField() {
    return ExpenseWidgets.form
        .buildAmountField(amountController, amountPrefixController.text);
  }

  Container _buildTransactionTypeField() {
    return ExpenseWidgets.form
        .buildTransactionTypeField(transactionTypeController);
  }

  Container _buildDateField() {
    return ExpenseWidgets.form
        .buildDateField(context, dateController, showDatePickerDialog);
  }

  Container _buildCategoryField() {
    return ExpenseWidgets.form
        .buildCategoryField(_selectedCategory, _categories, setCategory);
  }

  void setCategory(ExpenseCategory? selectedCategory) =>
      _selectedCategory = selectedCategory;

  Container _buildTagsField() {
    return ExpenseWidgets.form.buildTagsField(_selectedTag, _tags, setTag);
  }

  void setTag(Tag? tag) => _selectedTag = tag;

  Container _buildNotesField() {
    return ExpenseWidgets.form.buildNotesField(notesController);
  }

  Future<void> showDatePickerDialog() async {
    {
      DateTime? pickedDate = await DateTimePickerDialog.datePicker(context);
      if (pickedDate != null) {
        String formattedDate =
            DateFormat('yyyy-MM-dd HH:mm:ss').format(pickedDate);
        setState(() {
          dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
        });
        _logger.i('date: $formattedDate');
      }
    }
  }

  //endregion

  //region Section 6: methods
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
      _logger.i('contains expense items: $_containsExpenseItems');

      ExpenseFormModel expense = ExpenseFormModel(
        titleController.text.trim(),
        currencyController.text.trim(),
        double.parse(amountController.text.trim()),
        transactionTypeController.text.trim(),
        DateTime.parse(dateController.text.trim()),
        _selectedCategory!.name,
        _containsExpenseItems,
      );

      expense.tags = _selectedTag!.name;
      expense.note = notesController.text.trim();

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
    return await expenseService.addExpense(expense, _expenseItemsProvider);
  }

  Future<bool> updateExpense(ExpenseFormModel expense) async {
    ExpenseService expenseService = await ExpenseService.create();
    return await expenseService.updateExpense(expense, _expenseItemsProvider);
  }

  dynamic getDefaultCurrency() async {
    final provider = Provider.of<SettingsProvider>(context, listen: false);
    await provider.refreshDefaultCurrency();
    return provider.defaultCurrency;
  }

  ExpenseItemsProvider get _expenseItemsProvider =>
      Provider.of<ExpenseItemsProvider>(context, listen: false);

  void _toggleExpenseItems(value) {
    setState(() {
      _containsExpenseItems = value!;
    });
  }
//endregion
}
