import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../../models/expense_filters.dart';
import '../../../providers/expense_provider.dart';
import '../../../providers/sort_filter_provider.dart';
import '../../dialogs/common/month_picker_dialog.dart';
import '../../dialogs/common/year_picker_dialog.dart';
import '../../dialogs/filter_expenses_dialog.dart';

class FilterWidget extends StatefulWidget {
  const FilterWidget({super.key});

  @override
  FilterWidgetState createState() => FilterWidgetState();
}

class FilterWidgetState extends State<FilterWidget> {
  static final Logger _logger =
      Logger(printer: SimplePrinter(), level: Level.info);

  _refreshExpenses() {
    final expenseProvider =
        Provider.of<ExpenseProvider>(context, listen: false);
    expenseProvider.refreshExpenses();
  }

  void _incrementMonth(SortFilterProvider sortFilterProvider) {
    final currentMonthIndex =
        DateFormat('MMMM').parse(sortFilterProvider.filterMonth).month;
    if (currentMonthIndex < 12) {
      sortFilterProvider.setFilterMonth(
          DateFormat('MMMM').format(DateTime(2000, currentMonthIndex + 1)));
    } else {
      sortFilterProvider.setFilterMonth(
          DateFormat('MMMM').format(DateTime(2000, currentMonthIndex - 11)));
    }
    _refreshExpenses();
  }

  void _decrementMonth(SortFilterProvider sortFilterProvider) {
    final currentMonthIndex =
        DateFormat('MMMM').parse(sortFilterProvider.filterMonth).month;
    if (currentMonthIndex > 1) {
      sortFilterProvider.setFilterMonth(
          DateFormat('MMMM').format(DateTime(2000, currentMonthIndex - 1)));
    } else {
      sortFilterProvider.setFilterMonth(
          DateFormat('MMMM').format(DateTime(2000, currentMonthIndex + 11)));
    }
    _refreshExpenses();
  }

  void _incrementYear(SortFilterProvider sortFilterProvider) {
    final currentYear = int.parse(sortFilterProvider.filterYear);
    sortFilterProvider.setFilterYear((currentYear + 1).toString());
    _refreshExpenses();
  }

  void _decrementYear(SortFilterProvider sortFilterProvider) {
    final currentYear = int.parse(sortFilterProvider.filterYear);
    sortFilterProvider.setFilterYear((currentYear - 1).toString());
    _refreshExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SortFilterProvider>(
        builder: (context, sortFilterProvider, _) {
      return Row(
        children: [
          _buildFilterButton(sortFilterProvider),
          _buildExpenseCount(),
          if (sortFilterProvider.isFilterApplied) const Text("   in"),
          if (sortFilterProvider.isFilterByMonth)
            _buildMonthGestureWidget(sortFilterProvider),
          if (sortFilterProvider.isFilterByYear)
            _buildYearGestureWidget(sortFilterProvider),
        ],
      );
    });
  }

  GestureDetector _buildMonthGestureWidget(
      SortFilterProvider sortFilterProvider) {
    return GestureDetector(
      onTap: () => _showMonthPicker(sortFilterProvider),
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! < 0) {
          _decrementMonth(sortFilterProvider);
        } else {
          _incrementMonth(sortFilterProvider);
        }
      },
      child: _buildMonthText(sortFilterProvider),
    );
  }

  GestureDetector _buildYearGestureWidget(
      SortFilterProvider sortFilterProvider) {
    return GestureDetector(
      onTap: () => _showYearPicker(sortFilterProvider),
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity! < 0) {
          _incrementYear(sortFilterProvider);
        } else {
          _decrementYear(sortFilterProvider);
        }
      },
      child: _buildYearText(sortFilterProvider),
    );
  }

  Widget _buildMonthText(SortFilterProvider sortFilterProvider) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Text(
        sortFilterProvider.filterMonth,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildYearText(SortFilterProvider sortFilterProvider) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Text(
        sortFilterProvider.filterYear,
        textAlign: TextAlign.center,
      ),
    );
  }

  void _showMonthPicker(SortFilterProvider sortFilterProvider) async {
    final selectedMonth = await MonthPickerDialog.show(context);
    if (selectedMonth != null &&
        selectedMonth != sortFilterProvider.filterMonth) {
      sortFilterProvider.setFilterMonth(selectedMonth);
      _refreshExpenses();
    }
  }

  void _showYearPicker(SortFilterProvider sortFilterProvider) async {
    final selectedYear = await YearPickerDialog.show(context);
    if (selectedYear != null &&
        selectedYear.toString() != sortFilterProvider.filterYear) {
      sortFilterProvider.setFilterYear(selectedYear.toString());
      _refreshExpenses();
    }
  }

  IconButton _buildFilterButton(SortFilterProvider sortFilterProvider) {
    return IconButton(
      icon: const Icon(Icons.filter_list),
      onPressed: () => _showFilterDialog(sortFilterProvider),
      tooltip: "Filter",
    );
  }

  void _showFilterDialog(SortFilterProvider sortFilterProvider) async {
    final newFilters = await showDialog<ExpenseFilters>(
      context: context,
      builder: (context) => FilterExpensesDialog(
        expenseFilters: _getFilters(sortFilterProvider),
      ),
    );

    if (newFilters != null && newFilters.isChanged) {
      _setFilters(newFilters, sortFilterProvider);
    }
  }

  _setFilters(ExpenseFilters filters, SortFilterProvider sortFilterProvider) {
    _logger.i('is applied: ${filters.isApplied}');

    _logger.i('filter by year: ${filters.filterByYear}');
    _logger.i('filter by month: ${filters.filterByMonth}');

    _logger.i('selected year: ${filters.selectedYear}');
    _logger.i('selected month: ${filters.selectedMonth}');

    sortFilterProvider.setIsFilterApplied(filters.isApplied);

    sortFilterProvider.setIsFilterByYear(filters.filterByYear);
    sortFilterProvider.setIsFilterByMonth(filters.filterByMonth);

    sortFilterProvider.setFilterMonth(filters.selectedMonth);
    sortFilterProvider.setFilterYear(filters.selectedYear);

    _refreshExpenses();
  }

  _getFilters(SortFilterProvider sortFilterProvider) {
    ExpenseFilters filters = ExpenseFilters();

    filters.isApplied = sortFilterProvider.isFilterApplied;

    filters.filterByYear = sortFilterProvider.isFilterByYear;
    filters.filterByMonth = sortFilterProvider.isFilterByMonth;

    filters.selectedYear = sortFilterProvider.filterYear;
    filters.selectedMonth = sortFilterProvider.filterMonth;

    return filters;
  }

  Consumer<ExpenseProvider> _buildExpenseCount() {
    return Consumer<ExpenseProvider>(
      builder: (context, provider, _) {
        int count = provider.expenses.length;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Text(
            '$count',
          ),
        );
      },
    );
  }
}
