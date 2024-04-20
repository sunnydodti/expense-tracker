import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    return AlertDialog(
      title: const Text('Expense Filters'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildYearCheckbox(),
              if (_expenseFilters.filterByYear) _buildYearDropdown(),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMonthCheckbox(),
              if (_expenseFilters.filterByMonth) _buildMonthDropdown(),
            ],
          ),
        ],
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [_buildClearFiltersButton(), _buildApplyFiltersButton()],
        )
      ],
    );
  }

  ElevatedButton _buildClearFiltersButton() {
    return ElevatedButton(
      onPressed: () {
        _clearAllFilters();
        Navigator.pop(context, _expenseFilters);
      },
      child: const Text('Clear Filter'),
    );
  }

  ElevatedButton _buildApplyFiltersButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.pop(context, _expenseFilters);
      },
      child: const Text('Apply Filter'),
    );
  }

  Expanded _buildMonthDropdown() {
    return Expanded(
      flex: 2,
      child: DropdownButton<String>(
        underline: const SizedBox(),
        dropdownColor: Colors.grey.shade800,
        isExpanded: true,
        isDense: true,
        menuMaxHeight: 300,
        style: const TextStyle(fontSize: 14),
        value: _expenseFilters.selectedMonth,
        onChanged: (newValue) {
          setState(() {
            _expenseFilters.selectedMonth = newValue!;
          });
          _expenseFilters.isChanged = true;
        },
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

  Expanded _buildYearDropdown() {
    return Expanded(
      flex: 1,
      child: DropdownButton<String>(
        underline: const SizedBox(),
        dropdownColor: Colors.grey.shade800,
        isExpanded: true,
        isDense: true,
        menuMaxHeight: 300,
        style: const TextStyle(fontSize: 14),
        value: _expenseFilters.selectedYear,
        onChanged: (newValue) {
          setState(() {
            _expenseFilters.selectedYear = newValue!;
          });
          _expenseFilters.isChanged = true;
        },
        items: [
          for (int year = 2000; year <= DateTime.now().year; year++)
            DropdownMenuItem(
              alignment: AlignmentDirectional.centerEnd,
              value: year.toString(),
              child: Text(year.toString()),
            ),
        ],
      ),
    );
  }

  Expanded _buildMonthCheckbox() {
    return Expanded(
      flex: 2,
      child: CheckboxListTile(
        contentPadding: EdgeInsets.zero,
        visualDensity: const VisualDensity(horizontal: -4, vertical: -1),
        activeColor: Colors.blue,
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

  Expanded _buildYearCheckbox() {
    return Expanded(
      flex: 2,
      child: CheckboxListTile(
        contentPadding: EdgeInsets.zero,
        visualDensity: const VisualDensity(horizontal: -4, vertical: -1),
        activeColor: Colors.blue,
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