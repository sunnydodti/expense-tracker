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
  final _quantityController = TextEditingController();
  final _totalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _totalController.text = '0';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _quantityController.dispose();
    _totalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.blue,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Form(
        key: _formKey,
        child: ListTile(
          title: Row(
            children: [
              _buildNameField(),
              _buildSubmitButton(),
            ],
          ),
          subtitle: Row(children: [
            _buildAmountField(),
            _buildSign("×"),
            _buildQuantityField(),
            _buildSign("="),
            _buildTotalField(),
          ]),
        ),
      ),
    );
  }

  Padding _buildSign(String sign) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
      child: Text(
        sign,
        style: const TextStyle(fontSize: 20),
      ),
    );
  }

  Expanded _buildNameField() {
    return Expanded(
      flex: 6,
      child: Container(
        child: TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            hintText: "Name",
            label: Text("Name", textScaleFactor: .8),
          ),
          validator: _validateItemName,
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
      child: Container(
        // padding: const EdgeInsets.only(left: 5),
        child: TextFormField(
          controller: _amountController,
          decoration: const InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.only(top: 15, left: 10, bottom: 5),
            helperText: "Amount",
            // label: Text("Amount", textScaleFactor: .8),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
            ),
          ),
          validator: _validateItemAmount,
          keyboardType: const TextInputType.numberWithOptions(decimal: false),
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          ],
          onChanged: (value) {
            _logger.i("tag: $value");
            _updateAmount();
          },
        ),
      ),
    );
  }

  Expanded _buildQuantityField() {
    return Expanded(
      child: Container(
        // padding: const EdgeInsets.only(left: 5),
        child: TextFormField(
          controller: _quantityController,
          decoration: const InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.only(top: 15, left: 10, bottom: 5),
            helperText: "Quantity",
            // label: Text("Quantity", textScaleFactor: .8),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
            ),
          ),
          validator: _validateItemAmount,
          keyboardType: const TextInputType.numberWithOptions(decimal: false),
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          ],
          onChanged: (value) {
            _logger.i("tag: $value");
            _updateAmount();
          },
        ),
      ),
    );
  }

  Expanded _buildTotalField() {
    return Expanded(
      child: Container(
        // padding: const EdgeInsets.only(left: 5),
        child: TextFormField(
          controller: _totalController,
          readOnly: true,
          decoration: const InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.only(top: 15, left: 10, bottom: 5),
            helperText: "Total",
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
            ),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: false),
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          ],
          onChanged: (value) {
            _logger.i("tag: $value");
          },
        ),
      ),
    );
  }

  IconButton _buildSubmitButton() {
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
          amount: double.parse(_amountController.text),
          quantity: int.parse(_quantityController.text),
      );
      _addExpenseItem(expenseItem);
      _nameController.clear();
      _amountController.clear();
      _quantityController.clear();
      _totalController.clear();
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

  void _updateAmount() {
    int amount = _amountController.text.isEmpty ? 0 : int.parse(_amountController.text);
    int quantity = _quantityController.text.isEmpty ? 0 : int.parse(_quantityController.text);
    setState(() {
      _totalController.text = '${amount * quantity}';
    });
  }
}
