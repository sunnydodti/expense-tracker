import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/helpers/color_helper.dart';
import '../../models/expense_filters.dart';

class FilterExpensesDialog extends StatefulWidget {
  final ExpenseFilters expenseFilters;

  const FilterExpensesDialog({
    Key? key,
    required this.expenseFilters,
  }) : super(key: key);

  @override
  FilterExpensesDialogState createState() => FilterExpensesDialogState();
}

class FilterExpensesDialogState extends State<FilterExpensesDialog> {
  late ExpenseFilters _expenseFilters;

  @override
  void initState() {
    super.initState();
    _expenseFilters = widget.expenseFilters;
    _expenseFilters.isChanged = false;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return AlertDialog(
      backgroundColor: ColorHelper.getTileColor(theme),
      title: buildDialogTitle(),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMonthCheckbox(theme),
              if (_expenseFilters.filterByMonth) _buildMonthDropdown(theme),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildYearCheckbox(theme),
              if (_expenseFilters.filterByYear) _buildYearDropdown(theme),
            ],
          ),
        ],
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildClearFiltersButton(theme),
            _buildApplyFiltersButton(theme)
          ],
        )
      ],
    );
  }

  Row buildDialogTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Expense Filters'),
        const SizedBox(width: 70),
        Expanded(
          child: IconButton(
            onPressed: _closeFilterDialog,
            icon: const Icon(Icons.clear),
          ),
        )
      ],
    );
  }

  ElevatedButton _buildClearFiltersButton(ThemeData theme) {
    return ElevatedButton(
      onPressed: () {
        _clearAllFilters();
        _closeFilterDialog();
      },
      child: Text(
        'Clear Filter',
        style: TextStyle(color: ColorHelper.getButtonTextColor(theme)),
      ),
    );
  }

  ElevatedButton _buildApplyFiltersButton(ThemeData theme) {
    return ElevatedButton(
      onPressed: () {
        _closeFilterDialog();
      },
      child: Text(
        'Apply Filter',
        style: TextStyle(color: ColorHelper.getButtonTextColor(theme)),
      ),
    );
  }

  void _closeFilterDialog() {
    Navigator.pop(context, _expenseFilters);
  }

  Expanded _buildMonthDropdown(ThemeData theme) {
    return Expanded(
      flex: 2,
      child: DropdownButton<String>(
        underline: const SizedBox(),
        dropdownColor: ColorHelper.getTileColor(Theme.of(context)),
        isExpanded: true,
        isDense: true,
        menuMaxHeight: 300,
        style: TextStyle(
            fontSize: 14, color: ColorHelper.getDropdownTextColor(theme)),
        value: _expenseFilters.selectedMonth,
        onChanged: (newValue) {
          setState(() {
            _expenseFilters.selectedMonth = newValue!;
          });
          _expenseFilters.isChanged = true;
        },
        focusColor: Colors.transparent,
        items: [
          for (int i = 1; i <= 12; i++)
            DropdownMenuItem(
              alignment: AlignmentDirectional.centerEnd,
              value: DateFormat('MMMM').format(DateTime(2000, i)),
              child: Text(DateFormat('MMMM').format(DateTime(2000, i))),
            ),
        ],
      ),
    );
  }

  Expanded _buildYearDropdown(ThemeData theme) {
    return Expanded(
      flex: 1,
      child: DropdownButton<String>(
        underline: const SizedBox(),
        dropdownColor: ColorHelper.getTileColor(Theme.of(context)),
        isExpanded: true,
        isDense: true,
        menuMaxHeight: 300,
        style: TextStyle(
            fontSize: 14, color: ColorHelper.getDropdownTextColor(theme)),
        value: _expenseFilters.selectedYear,
        onChanged: (newValue) {
          setState(() {
            _expenseFilters.selectedYear = newValue!;
          });
          _expenseFilters.isChanged = true;
        },
        focusColor: Colors.transparent,
        items: [
          for (int year = 2000; year <= DateTime.now().year; year++)
            DropdownMenuItem(
              alignment: AlignmentDirectional.centerEnd,
              value: year.toString(),
              child: Text(
                year.toString(),
              ),
            ),
        ],
      ),
    );
  }

  Expanded _buildMonthCheckbox(ThemeData theme) {
    return Expanded(
      flex: 2,
      child: CheckboxListTile(
        contentPadding: EdgeInsets.zero,
        visualDensity: const VisualDensity(horizontal: -4, vertical: -1),
        activeColor: ColorHelper.getToggleColor(theme),
        controlAffinity: ListTileControlAffinity.leading,
        title: const Text(
          'Month Filter',
          textScaleFactor: 0.9,
        ),
        value: _expenseFilters.filterByMonth,
        onChanged: (val) {
          setState(() {
            _expenseFilters.filterByMonth =
                val ?? _expenseFilters.filterByMonth;
          });
          _expenseFilters.isChanged = true;
          _updateIsFilterApplied();
        },
      ),
    );
  }

  Expanded _buildYearCheckbox(ThemeData theme) {
    return Expanded(
      flex: 2,
      child: CheckboxListTile(
        contentPadding: EdgeInsets.zero,
        visualDensity: const VisualDensity(horizontal: -4, vertical: -1),
        activeColor: ColorHelper.getToggleColor(theme),
        controlAffinity: ListTileControlAffinity.leading,
        title: const Text(
          'Year Filter',
          textScaleFactor: 0.9,
        ),
        value: _expenseFilters.filterByYear,
        onChanged: (val) {
          setState(() {
            _expenseFilters.filterByYear = val ?? _expenseFilters.filterByYear;
          });
          _expenseFilters.isChanged = true;
          _updateIsFilterApplied();
        },
      ),
    );
  }

  void _updateIsFilterApplied() {
    _expenseFilters.isApplied =
        _expenseFilters.filterByYear || _expenseFilters.filterByMonth;
  }

  void _clearAllFilters() {
    if (_expenseFilters.isApplied) _expenseFilters.isChanged = true;
    _expenseFilters.isApplied = false;
    _expenseFilters.filterByYear = false;
    _expenseFilters.filterByMonth = false;
  }
}
