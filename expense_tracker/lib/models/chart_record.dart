import 'package:expense_tracker/models/enums/transaction_type.dart';

import 'expense.dart';

class ChartRecord {
  List<Expense> expenses = [];

  double expenseAmount = 0.0;
  double incomeAmount = 0.0;
  double reimbursementAmount = 0.0;

  double get totalAmount {
    double sum = 0;
    sum -= expenseAmount;
    sum += incomeAmount;
    sum += reimbursementAmount;
    return sum;
  }

  void add(Expense expense) {
    expenses.add(expense);

    if (expense.transactionType == TransactionType.expense.name) {
      expenseAmount += expense.amount;
    }
    if (expense.transactionType == TransactionType.income.name) {
      incomeAmount += expense.amount;
    }
    if (expense.transactionType == TransactionType.reimbursement.name) {
      reimbursementAmount += expense.amount;
    }
  }
}
