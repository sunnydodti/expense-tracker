import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../data/constants/ui_constants.dart';
import '../../../models/enums/form_modes.dart';
import '../../../models/expense_category.dart';
import '../../../models/tag.dart';
import '../../screens/widget_constants.dart';
import '../common/scaled_text.dart';
import '../form_widgets.dart';

class ExpenseFormWidgets {
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

  Container buildTitleField(
    TextEditingController controller, {
    FocusNode? focusNode,
  }) {
    return Container(
      padding: fieldPadding,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        autofocus: true,
        maxLines: 1,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.title_outlined, size: uiIconSize),
          labelText: 'Title',
          hintText: 'Add a Title',
          suffixIcon: IconButton(
            onPressed: () => controller.clear(),
            icon: const Icon(Icons.clear, size: uiIconSize),
          ),
        ),
        validator: (value) => _validateTextField(value, 'enter Title'),
        keyboardType: TextInputType.text,
      ),
    );
  }

  Container buildAmountField(
    TextEditingController controller,
    String currency, {
    bool isReadOnly = false,
  }) {
    return Container(
      padding: fieldPadding,
      child: TextFormField(
        readOnly: isReadOnly,
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.attach_money_outlined, size: uiIconSize),
          prefixText: '$currency ',
          labelText: 'Amount',
          hintText: 'Add Amount',
          suffixIcon: IconButton(
            onPressed: () => controller.clear(),
            icon: const Icon(Icons.clear, size: uiIconSize),
          ),
        ),
        validator: (value) => _validateTextField(value, 'enter amount'),
        keyboardType: const TextInputType.numberWithOptions(decimal: false),
        inputFormatters: [
          FilteringTextInputFormatter.allow(
            RegExp(r'^\d*\.?\d{0,2}$'),
          ),
        ],
      ),
    );
  }

  Container buildTransactionTypeField(
    TextEditingController controller,
    Color color,
  ) {
    return Container(
      padding: fieldPadding,
      child: DropdownButtonFormField(
        dropdownColor: color,
        isExpanded: true,
        isDense: true,
        value: controller.text,
        items: FormWidgets.getTransactionTypeDropdownItems(),
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.monetization_on_outlined, size: uiIconSize),
          labelText: 'Transaction Type',
        ),
        validator: (value) => _validateTextField(
          value,
          "select transaction type",
        ),
        onChanged: (value) => controller.text = value!,
        focusColor: Colors.transparent,
      ),
    );
  }

  Container buildDateField(
    BuildContext context,
    TextEditingController controller,
    Function datePicker,
  ) {
    return Container(
      padding: fieldPadding,
      child: TextFormField(
        controller: controller,
        decoration: const InputDecoration(
          labelText: 'Date',
          prefixIcon: Icon(Icons.calendar_today_outlined, size: uiIconSize),
        ),
        readOnly: true,
        onTap: () async => datePicker(),
      ),
    );
  }

  Container buildCategoryField(
    ExpenseCategory? initialValue,
    List<ExpenseCategory> categories,
    Function(ExpenseCategory?) onChanged,
    Color color,
  ) {
    return Container(
      padding: fieldPadding,
      child: DropdownButtonFormField<ExpenseCategory>(
        dropdownColor: color,
        isExpanded: true,
        value: initialValue,
        items: FormWidgets.getDropdownItems(
            categories, (category) => category.name),
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.edit, size: uiIconSize),
          labelText: 'Category',
        ),
        validator: (value) => _validateCategory(value, "select category"),
        onChanged: onChanged,
        focusColor: Colors.transparent,
      ),
    );
  }

  Container buildTagsField(
    Tag? initialValue,
    List<Tag> tags,
    Function(Tag?) onChanged,
    Color color,
  ) {
    return Container(
      padding: fieldPadding,
      child: DropdownButtonFormField<Tag>(
        dropdownColor: color,
        isExpanded: true,
        value: initialValue,
        items: FormWidgets.getDropdownItems(tags, (tag) => tag.name),
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.label_outline, size: uiIconSize),
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
      padding: fieldPadding,
      child: TextFormField(
        controller: controller,
        maxLines: 1,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.edit, size: uiIconSize),
          labelText: 'Notes',
          hintText: "Add Notes",
          suffixIcon: IconButton(
            onPressed: () => controller.clear(),
            icon: const Icon(Icons.clear, size: uiIconSize),
          ),
        ),
        keyboardType: TextInputType.text,
      ),
    );
  }

  Container buildSubmitButton(
    void Function()? onPressed,
    FormMode formMode,
    Color highlightColor,
  ) {
    return Container(
      padding: const EdgeInsets.only(
        left: uiPaddingX2,
        right: uiPaddingX2,
        top: 0,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(highlightColor),
        ),
        child: ScaledText(
          (formMode == FormMode.add) ? 'Submit' : 'Edit',
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
      ),
    );
  }
}
