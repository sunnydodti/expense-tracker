import 'package:expense_tracker/model/expense.dart';

class User {
  String? userName;
  String? email;
  String? name;
  String? profilePictureUrl;
  DateTime? creationDate;
  List<String>? expenseCategories;
  List<String>? expenseLabels;
  List<Expense>? expenses;
}
