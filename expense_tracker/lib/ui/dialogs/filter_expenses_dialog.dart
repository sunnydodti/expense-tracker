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
  late bool _canApplyFilter;

  @override
  void initState() {
    super.initState();
    _expenseFilters = widget.expenseFilters;
    _canApplyFilter =
        _expenseFilters.filterByYear || _expenseFilters.filterByMonth;
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
              const SizedBox(width: 10),
              if (_expenseFilters.filterByYear) _buildYearDropdown(),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMonthCheckbox(),
              const SizedBox(width: 10),
              if (_expenseFilters.filterByMonth) _buildMonthDropdown(),
            ],
          ),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: _canApplyFilter
              ? () {
                  Navigator.pop(context, _expenseFilters);
                }
              : null,
          child: const Text('Apply Filter'),
        )
      ],
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
            _updateCanApplyFilter();
          });
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
            _updateCanApplyFilter();
          });
        },
      ),
    );
  }

  void _updateCanApplyFilter() {
    _canApplyFilter =
        _expenseFilters.filterByYear || _expenseFilters.filterByMonth;
  }
}