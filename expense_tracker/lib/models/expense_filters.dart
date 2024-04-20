import 'package:intl/intl.dart';

class ExpenseFilters {
  bool isChanged = false;

  bool isApplied = true;
  bool filterByYear = true;
  bool filterByMonth = true;

  String selectedYear = DateFormat('MMM').format(DateTime.now());
  String selectedMonth = DateFormat('yyyy').format(DateTime.now());

  ExpenseFilters();
}
