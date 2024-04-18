import 'package:intl/intl.dart';

class ExpenseFilters {
  bool isApplied = true;
  bool filterByYear = false;
  bool filterByMonth = true;

  String selectedYear = DateFormat('MMM').format(DateTime.now());
  String selectedMonth = DateFormat('yyyy').format(DateTime.now());

  ExpenseFilters();
}
