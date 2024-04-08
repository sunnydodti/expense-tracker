import 'package:expense_tracker/models/category.dart';
import 'package:flutter/material.dart';

import '../models/enums/transaction_type.dart';
import '../models/tag.dart';

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
        child: Text(transactionType, maxLines: 1),
      );
      dropdownItems.add(newItem);
    }
    return dropdownItems;
  }

  static List<DropdownMenuItem> getCategoryDropdownItemsWithNew() {
    List<DropdownMenuItem> dropdownItems = [];
    for (String category in categories) {
      var newItem = DropdownMenuItem(
        value: category,
        child: Text(category),
      );
      dropdownItems.add(newItem);
    }
    return dropdownItems;
  }

// dropdown menu tags
  static List<DropdownMenuItem> getTagsDropdownItems() {
    List<DropdownMenuItem> dropdownItems = [];
    for (String tag in tags) {
      var newItem = DropdownMenuItem(
        value: tag,
        child: Text(tag),
      );
      dropdownItems.add(newItem);
    }
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

  static List<DropdownMenuItem<Category>> getCategoryDropdownItemsV2(
      List<Category> categories) {
    return categories.map((category) {
      return DropdownMenuItem<Category>(
        value: category,
        child: Text(category.name),
      );
    }).toList();
  }

  static List<DropdownMenuItem<Tag>> getTagsDropdownItemsV2(List<Tag> tags) {
    return tags.map((tag) {
      return DropdownMenuItem<Tag>(
        value: tag,
        child: Text(tag.name),
      );
    }).toList();
  }
}
