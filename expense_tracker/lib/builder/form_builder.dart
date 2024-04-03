import 'package:expense_tracker/models/enums/transaction_type.dart';
import 'package:flutter/material.dart';

class FromBuilder {
  // ---------------------------------- data ----------------------------------

  static List<String> transactionTypes = getTransactionTypes();

  static List<String> categories = [
    "Food",
    "Transport",
    "Shopping",
    "Entertainment",
    "Health",
    "Bills",
    "Others"
  ];

  // creata a dictionary of common currencies
  static const Map<String, String> currencies = {
    'INR': '\u20B9',
    'USD': '\$',
    'EUR': '\u20AC',
    'GBP': '\u00A3',
    'JPY': '\u00A5',
    'CAD': '\$',
    'AUD': '\$',
    'NZD': '\$',
  };

  static List<String> tags = [
    'home',
    'work',
    'college',
    'friends',
    'family',
  ];

  // ---------------------------------- methods ----------------------------------
  //getters for transaction types and categories
  static List<String> getTransactionTypesList() => transactionTypes;
  static List<String> getCategoriesList() => categories;
  static Map<String, String> getCurrenciesListMap() => currencies;
  static List<String> getTagsList() => tags;

  static List<DropdownMenuItem> getTransactionTypeDropdownItems() {
    List<DropdownMenuItem> dropdownItems = [];
    for (String transactionType in transactionTypes) {
      var newItem = DropdownMenuItem(
        value: transactionType,
        child: Text(transactionType),
      );
      dropdownItems.add(newItem);
    }
    return dropdownItems;
  }

  static List<DropdownMenuItem> getCategoryDropdownItemsWithNew() {
    List<DropdownMenuItem> dropdownItems = [];
    // map categories to dropdown items
    for (String category in categories) {
      bool isChecked = false;
      onChanged(value) => isChecked = value!;
      var newItem = DropdownMenuItem(
        value: category,
        child: Text(category),
      );
      dropdownItems.add(newItem);
    }
    // add option to add new category
    var newItem = DropdownMenuItem(
      value: "Add new category",
      child: Text("Add new category"),
      onTap: () {
        // function to add new category
      },
    );

    return dropdownItems;
  }

// dropdown menu tags
  static List<DropdownMenuItem> getTagsDropdownItems() {
    List<DropdownMenuItem> dropdownItems = [];
    // map categories to dropdown items
    for (String tag in tags) {
      bool isChecked = false;
      onChanged(value) => isChecked = value!;
      var newItem = DropdownMenuItem(
        value: tag,
        child: Text(tag),
      );
      dropdownItems.add(newItem);
    }
    // add option to add new category
    var newItem = DropdownMenuItem(
      value: "Add new tag",
      child: Text("Add new tag"),
      onTap: () {
        // function to add new category
      },
    );

    return dropdownItems;
  }

  // dropdown menu currencies
  static List<DropdownMenuItem> getCurrencyDropdownItems() {
    return currencies.entries
        .map((e) => DropdownMenuItem(
              value: e.key,
              child: Text("(${e.value}) ${e.key}"),
              // child: Text(e.value),
            ))
        .toList();
  }

  static List<DropdownMenuItem> getCategoryDropdownItems() {
    return categories.map((category) {
      return DropdownMenuItem(
        value: category,
        child: Text(category),
      );
    }).toList();
  }
}
