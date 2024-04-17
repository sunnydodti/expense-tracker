import 'package:expense_tracker/models/expense_filters.dart';
import 'package:flutter/material.dart';

class FilterExpensesDialog extends StatefulWidget {
  final ExpenseFilters expenseFilters;

  const FilterExpensesDialog({
    super.key,
    required this.expenseFilters,
  });

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
      title: Text('Expense Filters'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CheckboxListTile(
            title: Text('Filter by Year'),
            value: _expenseFilters.filterByYear,
            onChanged: (val) {
              setState(() {
                _expenseFilters.filterByYear = val ?? false;
                _updateCanApplyFilter();
              });
            },
          ),
          CheckboxListTile(
            title: Text('Filter by Month'),
            value: _expenseFilters.filterByMonth,
            onChanged: (val) {
              setState(() {
                _expenseFilters.filterByMonth = val ?? false;
                _updateCanApplyFilter();
              });
            },
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
          child: Text('Apply Filter'),
        )
      ],
    );
  }

  void _updateCanApplyFilter() {
    _canApplyFilter =
        _expenseFilters.filterByYear || _expenseFilters.filterByMonth;
  }
}
