import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../../models/expense_item.dart';
import '../../../providers/expense_items_provider.dart';

class ExpenseItemForm extends StatefulWidget {
  const ExpenseItemForm({Key? key}) : super(key: key);

  @override
  State<ExpenseItemForm> createState() => _ExpenseItemFormState();
}

class _ExpenseItemFormState extends State<ExpenseItemForm> {
  final _formKey = GlobalKey<FormState>();

  static final Logger _logger =
      Logger(printer: SimplePrinter(), level: Level.info);

  final _nameController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ListTile(
        title: Form(
          key: _formKey,
          child: Row(
            children: [
              _buildNameField(),
              _buildAmountField(),
            ],
          ),
        ),
        trailing: buildSubmitButton(),
      ),
    );
  }

  Expanded _buildNameField() {
    return Expanded(
      flex: 6,
      child: Container(
        padding: const EdgeInsets.only(right: 5),
        child: TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
              hintText: "Add Name",
              label: Text("Item Name", textScaleFactor: .8)),
          validator: _validateItemName,
          // onSaved: submitCategory,
          onChanged: (value) {
            _logger.i("tag: $value");
          },
          keyboardType: TextInputType.text,
        ),
      ),
    );
  }

  Expanded _buildAmountField() {
    return Expanded(
      flex: 4,
      child: Container(
        padding: const EdgeInsets.only(left: 5),
        child: TextFormField(
          controller: _amountController,
          decoration: const InputDecoration(
            hintText: "Add Amount",
            label: Text("Item Amount", textScaleFactor: .8),
          ),
          validator: _validateItemAmount,
          keyboardType: const TextInputType.numberWithOptions(decimal: false),
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          ],
          // onSaved: submitCategory,
          onChanged: (value) {
            _logger.i("tag: $value");
          },
        ),
      ),
    );
  }

  IconButton buildSubmitButton() {
    return IconButton(
      icon: const Icon(Icons.add, color: Colors.green),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          submitExpenseItem();
        }
      },
    );
  }

  void submitExpenseItem() async {
    if (_formKey.currentState?.validate() ?? false) {
    _logger.i("name: ${_nameController.text}");
    _logger.i("amount: ${_amountController.text}");
    ExpenseItemFormModel expenseItem = ExpenseItemFormModel(
        name: _nameController.text,
        amount: double.parse(_amountController.text));
    _addExpenseItem(expenseItem);
    _nameController.clear();
    _amountController.clear();
    }
  }

  void _addExpenseItem(ExpenseItemFormModel expenseItem) {
    final provider = Provider.of<ExpenseItemsProvider>(context, listen: false);
    provider.addExpenseItem(expenseItem);
  }

  String? _validateItemName(value) {
    if (_nameController.text.isEmpty) {
      return 'Enter name';
    }
    return null;
  }

  String? _validateItemAmount(value) {
    if (_amountController.text.isEmpty) {
      return 'Enter Amount';
    }
    return null;
  }
}
