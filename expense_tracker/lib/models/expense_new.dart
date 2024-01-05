import 'package:expense_tracker/models/transaction_type.dart';

class Expense {
  String? _id; // required
  String _title; // required
  String _currency; // required
  double _amount; // required
  String _transactionType; // required
  DateTime _date; // required
  String _category; // required
  // List<String>? _tags;
  String? _tags;
  String? _note;
  bool? _containsNestedExpenses; // required
  List<Expense>? _expenses;

  Expense(
    this._title,
    this._currency,
    this._amount,
    this._transactionType,
    this._date,
    this._category,
    [this._tags, this._note, this._containsNestedExpenses, this._expenses]
  );

  Expense.withId(
      this._id,
      this._title,
      this._currency,
      this._amount,
      this._transactionType,
      this._date,
      this._category,
      [this._containsNestedExpenses, this._tags, this._note, this._expenses]
  );

  // Getters
  String? get id => _id;
  String get title => _title;
  String get currency => _currency;
  double get amount => _amount;
  String get transactionType => _transactionType;
  DateTime get date => _date;
  String get category => _category;
  // List<String>? get tags => _tags;
  String? get tags => _tags;
  String? get note => _note;
  bool? get containsNestedExpenses => _containsNestedExpenses;
  List<Expense>? get expenses => _expenses;

  //Setters
  set title(String title) {
    _title = title;
  }

  set currency(String currency) {
    _currency = currency;
  }

  set amount(double amount) {
    if (amount < 0) {
      throw ArgumentError('Amount must be non-negative');
    }
    _amount = amount;
  }

  set transactionType(String transactionType) {
    _transactionType = transactionType;
  }

  set date(DateTime date) {
    _date = date;
  }

  set category(String category) {
    _category = category;
  }

  // set tags(List<String>? tags) {
  set tags(String? tags) {
    _tags = tags;
  }

  set note(String? note) {
    _note = note;
  }

  set containsNestedExpenses(bool? containsNestedExpenses) {
    _containsNestedExpenses = containsNestedExpenses;
  }

  set expenses(List<Expense>? expenses) {
    _expenses = expenses;
  }

  // Methods
  //  // Expense Object to map
  // Getter for the Map representation
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};
    if (id != null) map['id'] = _id;
    map['title'] = _title;
    map['currency'] = _currency;
    map['amount'] = _amount;
    map['transactionType'] = _transactionType;
    map['date'] = _date.toIso8601String();
    map['category'] = _category;
    map['tags'] = _tags;
    map['note'] = _note;
    map['containsNestedExpenses'] = _containsNestedExpenses;
    map['expenses'] = _expenses?.map((expense) => expense.toMap()).toList();
    return map;
  }

  //  // map to Expense Object
  Expense.fromMap(Map<String, dynamic> map)
      : _id = map['id'],
        _title = map['title'],
        _currency = map['currency'],
        _amount = map['amount'],
        _transactionType = map['transactionType'],
        _date = DateTime.parse(map['date']),
        _category = map['category'],
        // _tags = map['tags']?.cast<String>(),
        _tags = map['tags'],
        _note = map['note'],
        _containsNestedExpenses = map['containsNestedExpenses'],
        _expenses = (map['expenses'] as List<Map<String, dynamic>>?)
            ?.map((expenseMap) => Expense.fromMap(expenseMap))
            .toList();
}
