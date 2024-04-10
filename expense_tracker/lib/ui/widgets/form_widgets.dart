import 'package:flutter/material.dart';

import '../../data/constants/form_constants.dart';
import '../../models/enums/transaction_type.dart';

class FormWidgets {
  static List<DropdownMenuItem<T>> getDropdownItems<T>(
      List<T> items, String Function(T) getChildText) {
    return items.map((item) {
      return DropdownMenuItem<T>(
        value: item,
        child: Text(getChildText(item)),
      );
    }).toList();
  }

  static List<DropdownMenuItem> getCurrencyDropdownItems() {
    return FormConstants.expense.currencies.entries
        .map((currency) => DropdownMenuItem(
              value: currency.key,
              child: Text("(${currency.value}) ${currency.key}"),
              // child: Text(e.value),
            ))
        .toList();
  }

  static List<DropdownMenuItem> getTransactionTypeDropdownItems() {
    List<DropdownMenuItem> dropdownItems = [];
    for (String transactionType in getTransactionTypes()) {
      var newItem = DropdownMenuItem(
        value: transactionType,
        child: Text(transactionType, maxLines: 1),
      );
      dropdownItems.add(newItem);
    }
    return dropdownItems;
  }
}
