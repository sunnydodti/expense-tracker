import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import '../../../models/expense_filters.dart';
import '../../dialogs/filter_expenses_dialog.dart';
import '../../dialogs/month_picker_dialog.dart';
import '../../dialogs/year_picker_dialog.dart';

class FilterWidget extends StatefulWidget {
  const FilterWidget({super.key});

  @override
  FilterWidgetState createState() => FilterWidgetState();
}

class FilterWidgetState extends State<FilterWidget> {
  static final Logger _logger =
  Logger(printer: SimplePrinter(), level: Level.info);

  String _selectedMonth = '';
  String _selectedYear = '';

  bool _filterByYear = false;
  bool _filterByMonth = true;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedMonth = DateFormat('MMM').format(now);
    _selectedYear = DateFormat('yyyy').format(now);
  }

  void _decrementMonth() {
    final currentMonthIndex = DateFormat('MMM').parse(_selectedMonth).month;
    if (currentMonthIndex < 12) {
      final nextMonthIndex = currentMonthIndex + 1;
      _selectedMonth = DateFormat('MMM').format(DateTime(2000, nextMonthIndex));
    }
    setState(() {});
  }

  void _incrementMonth() {
    final currentMonthIndex = DateFormat('MMM').parse(_selectedMonth).month;
    if (currentMonthIndex > 1) {
      final prevMonthIndex = currentMonthIndex - 1;
      _selectedMonth = DateFormat('MMM').format(DateTime(2000, prevMonthIndex));
    }
    setState(() {});
  }

  void _incrementYear() {
    final currentYear = int.parse(_selectedYear);
    _selectedYear = (currentYear + 1).toString();
    setState(() {});
  }

  void _decrementYear() {
    final currentYear = int.parse(_selectedYear);
    _selectedYear = (currentYear - 1).toString();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildFilterButton(),
        if (_filterByYear) _buildYearDisplay(context),
        if (_filterByMonth) _buildMonthDisplay(context),
      ],
    );
  }

  GestureDetector _buildMonthDisplay(BuildContext context) {
    return GestureDetector(
      onTap: () => _showMonthPicker(context),
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! < 0) {
          _incrementMonth();
        } else {
          _decrementMonth();
        }
      },
      child: _buildMonthDropdown(),
    );
  }

  GestureDetector _buildYearDisplay(BuildContext context) {
    return GestureDetector(
      onTap: () => _showYearPicker(context),
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity! < 0) {
          _incrementYear();
        } else {
          _decrementYear();
        }
      },
      child: _buildYearDropdown(),
    );
  }

  Widget _buildMonthDropdown() {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Text(
        _selectedMonth,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildYearDropdown() {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Text(
        _selectedYear,
        textAlign: TextAlign.center,
      ),
    );
  }

  void _showMonthPicker(BuildContext context) async {
    final selectedMonth = await MonthPickerDialog.show(context);
    if (selectedMonth != null) {
      setState(() {
        _selectedMonth = selectedMonth;
      });
    }
  }

  void _showYearPicker(BuildContext context) async {
    final selectedYear = await YearPickerDialog.show(context);
    if (selectedYear != null) {
      setState(() {
        _selectedYear = selectedYear.toString();
      });
    }
  }

  IconButton _buildFilterButton() {
    return IconButton(
      icon: const Icon(Icons.filter_list),
      onPressed: () => _showFilterDialog(),
      tooltip: "Filter",
    );
  }

  void _showFilterDialog() async {
    final newFilters = await showDialog<ExpenseFilters>(
      context: context,
      builder: (context) => FilterExpensesDialog(
        expenseFilters: _getFilters(),
      ),
    );

    if (newFilters != null) {
      _setFilters(newFilters);
    }
  }

  _setFilters(ExpenseFilters filters) {
    _logger.i('filter by year: ${filters.filterByYear}');
    _logger.i('filter by month: ${filters.filterByMonth}');

    _logger.i('selected year: ${filters.selectedYear}');
    _logger.i('selected month: ${filters.selectedMonth}');

    setState(() {
      _filterByYear = filters.filterByYear;
      _filterByMonth = filters.filterByMonth;

      _selectedMonth = filters.selectedMonth;
      _selectedYear = filters.selectedYear;
    });
  }

  _getFilters() {
    ExpenseFilters filters = ExpenseFilters();

    filters.filterByYear = _filterByYear;
    filters.filterByMonth = _filterByMonth;

    filters.selectedYear = _selectedYear;
    filters.selectedMonth = _selectedMonth;

    return filters;
  }
}
