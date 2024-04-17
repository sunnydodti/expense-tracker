import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    final selectedMonth = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Month'),
          content: SizedBox(
            height: 200.0,
            width: 200.0,
            child: ListView.builder(
              itemCount: 12,
              itemBuilder: (context, index) {
                final fullMonth = DateFormat('MMMM').format(DateTime(2000, index + 1));
                final shortMonth = DateFormat('MMM').format(DateTime(2000, index + 1));
                return ListTile(
                  title: Text(fullMonth),
                  onTap: () {
                    Navigator.pop(context, shortMonth);
                  },
                );
              },
            ),
          ),
        );
      },
    );
    if (selectedMonth != null) {
      setState(() {
        _selectedMonth = selectedMonth;
      });
    }
  }

  void _showYearPicker(BuildContext context) async {
    final selectedYear = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Year'),
          content: SizedBox(
            height: 200.0,
            width: 200.0,
            child: ListView.builder(
              itemCount: DateTime.now().year - 1999,
              itemBuilder: (context, index) {
                final year = DateTime.now().year - index;
                return ListTile(
                  title: Text(year.toString()),
                  onTap: () {
                    Navigator.pop(context, year);
                  },
                );
              },
            ),
          ),
        );
      },
    );
    if (selectedYear != null) {
      setState(() {
        _selectedYear = selectedYear.toString();
      });
    }
  }
}
