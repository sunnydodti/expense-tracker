import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../dialogs/month_picker_dialog.dart';
import '../../dialogs/year_picker_dialog.dart';

enum FilterOption { monthly, yearly, all }

class FilterWidget extends StatefulWidget {
  const FilterWidget({super.key});

  @override
  FilterWidgetState createState() => FilterWidgetState();
}

class FilterWidgetState extends State<FilterWidget> {
  String _selectedMonth = '';
  String _selectedYear = '';

  FilterOption _selectedFilter = FilterOption.monthly;

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
        GestureDetector(
          onTap: () => _showYearPicker(context),
          onVerticalDragEnd: (details) {
            if (details.primaryVelocity! < 0) {
              _incrementYear();
            } else {
              _decrementYear();
            }
          },
          child: _buildYearDropdown(),
        ),
        GestureDetector(
          onTap: () => _showMonthPicker(context),
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity! < 0) {
              _incrementMonth();
            } else {
              _decrementMonth();
            }
          },
          child: _buildMonthDropdown(),
        ),
      ],
    );
  }

  Widget _buildMonthDropdown() {
    return SizedBox(
      width: 100,
      child: Text(
        _selectedMonth,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildYearDropdown() {
    return SizedBox(
      width: 60,
      child: Text(
        _selectedYear,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  IconButton _buildFilterButton() {
    return IconButton(
      icon: const Icon(Icons.filter_list),
      onPressed: () {},
      tooltip: "Filter",
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
}
