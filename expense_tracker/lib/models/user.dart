import 'package:expense_tracker/models/expense_new.dart';

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
