import '../../models/enums/transaction_type.dart';

class FormConstants {
  static ExpenseFormConstants expense = ExpenseFormConstants();
}

class ExpenseFormConstants {
  static const Map<String, String> _currencies = {
    'INR': '\u20B9',
    'USD': '\$',
    'EUR': '\u20AC',
    'GBP': '\u00A3',
    'JPY': '\u00A5',
    'CAD': '\$',
    'AUD': '\$',
    'NZD': '\$',
  };

  Map<String, String> get currencies => _currencies;

  List<String> get transactionTypes => getTransactionTypes();
}
