import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../models/enums/form_modes.dart';
import '../../../models/expense_category.dart';
import '../../../models/tag.dart';
import '../form_widgets.dart';

class ExpenseFormWidgets {
  EdgeInsets _getFieldPadding() =>
      const EdgeInsets.only(left: 20, right: 20, top: 8);

  double _getIconSize() => 20;

  //region Section: validators
  String? _validateTextField(var value, String errorMessage) {
    if (value == null || value.isEmpty) return 'Please $errorMessage';
    return null;
  }

  String? _validateCategory(ExpenseCategory? category, String errorMessage) {
    if (category == null) return 'Please $errorMessage';
    return null;
  }

  String? _validateTag(Tag? tag, String errorMessage) {
    if (tag == null) return 'Please $errorMessage';
    return null;
  }

//endregion

  Container buildTitleField(TextEditingController controller) {
    return Container(
      padding: _getFieldPadding(),
      child: TextFormField(
        controller: controller,
        maxLines: 1,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.title_outlined, size: _getIconSize()),
          labelText: 'Title',
          hintText: 'Add a Title',
          suffixIcon: IconButton(
            onPressed: () => controller.clear(),
            icon: Icon(Icons.clear, size: _getIconSize()),
          ),
        ),
        validator: (value) => _validateTextField(value, 'enter Title'),
        keyboardType: TextInputType.text,
      ),
    );
  }

  Container buildAmountField(TextEditingController controller, String currency,
      {bool isReadOnly = false}) {
    return Container(
      padding: _getFieldPadding(),
      child: TextFormField(
        readOnly: isReadOnly,
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.attach_money_outlined, size: _getIconSize()),
          prefixText: '$currency ',
          labelText: 'Amount',
          hintText: 'Add Amount',
          suffixIcon: IconButton(
            onPressed: () => controller.clear(),
            icon: const Icon(Icons.clear),
          ),
        ),
        validator: (value) => _validateTextField(value, 'enter amount'),
        keyboardType: const TextInputType.numberWithOptions(decimal: false),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}$')),
        ],
      ),
    );
  }

  Container buildTransactionTypeField(TextEditingController controller) {
    return Container(
      padding: _getFieldPadding(),
      child: DropdownButtonFormField(
        isExpanded: true,
        isDense: true,
        value: controller.text,
        items: FormWidgets.getTransactionTypeDropdownItems(),
        decoration: InputDecoration(
          prefixIcon:
              Icon(Icons.monetization_on_outlined, size: _getIconSize()),
          labelText: 'Transaction Type',
        ),
        validator: (value) =>
            _validateTextField(value, "select transaction type"),
        onChanged: (value) => controller.text = value!,
        focusColor: Colors.transparent,
      ),
    );
  }

  Container buildDateField(BuildContext context,
      TextEditingController controller, Function datePicker) {
    return Container(
      padding: _getFieldPadding(),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: 'Date',
          prefixIcon: Icon(Icons.calendar_today_outlined, size: _getIconSize()),
        ),
        readOnly: true,
        onTap: () async => datePicker(),
      ),
    );
  }

  Container buildCategoryField(ExpenseCategory? initialValue,
      List<ExpenseCategory> categories, Function(ExpenseCategory?) onChanged) {
    return Container(
      padding: _getFieldPadding(),
      child: DropdownButtonFormField<ExpenseCategory>(
        isExpanded: true,
        value: initialValue,
        items: FormWidgets.getDropdownItems(
            categories, (category) => category.name),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.edit, size: _getIconSize()),
          labelText: 'Category',
        ),
        validator: (value) => _validateCategory(value, "select category"),
        onChanged: onChanged,
        focusColor: Colors.transparent,
      ),
    );
  }

  Container buildTagsField(
      Tag? initialValue, List<Tag> tags, Function(Tag?) onChanged) {
    return Container(
      padding: _getFieldPadding(),
      child: DropdownButtonFormField<Tag>(
        isExpanded: true,
        value: initialValue,
        items: FormWidgets.getDropdownItems(tags, (tag) => tag.name),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.label_outline, size: _getIconSize()),
          labelText: 'Tags',
        ),
        validator: (value) => _validateTag(value, "select tags"),
        onChanged: onChanged,
        focusColor: Colors.transparent,
      ),
    );
  }

  Container buildNotesField(TextEditingController controller) {
    return Container(
      padding: _getFieldPadding(),
      child: TextFormField(
        controller: controller,
        maxLines: 1,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.edit, size: _getIconSize()),
          labelText: 'Notes',
          hintText: "Add Notes",
          suffixIcon: IconButton(
            onPressed: () => controller.clear(),
            icon: Icon(Icons.clear, size: _getIconSize()),
          ),
        ),
        keyboardType: TextInputType.text,
      ),
    );
  }

  Container buildSubmitButton(
      void Function()? onPressed, FormMode formMode, Color highlightColor) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(highlightColor),
        ),
        child: Text(
          (formMode == FormMode.add) ? 'Submit' : 'Edit',
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
      ),
    );
  }
}
