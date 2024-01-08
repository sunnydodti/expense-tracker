import 'package:expense_tracker/data/db_constants/DBExpenseTableConstants.dart';

class Expense {
  int? _id; // required
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
  DateTime? _createdAt; // New field
  DateTime? _modifiedAt; // New field

  Expense(
    // this._id,
    this._title,
    this._currency,
    this._amount,
    this._transactionType,
    this._date,
    this._category,
    [this._tags, this._note, this._containsNestedExpenses, this._expenses]
  );

  // Expense.empty();

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
  int? get id => _id;
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
  DateTime? get createdAt => _createdAt;
  DateTime? get modifiedAt => _createdAt;

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

  set createdAt(DateTime? createdAt) {
    _createdAt = createdAt;
  }

  set modifiedAt(DateTime? modifiedAt) {
    _modifiedAt = modifiedAt;
  }

  // Methods
  //  // Expense Object to map
  // Getter for the Map representation
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};
    if (id != null) map[DBExpenseTableConstants.expenseColId] = _id;
    map[DBExpenseTableConstants.expenseColTitle] = _title;
    map[DBExpenseTableConstants.expenseColCurrency] = _currency;
    map[DBExpenseTableConstants.expenseColAmount] = _amount;
    map[DBExpenseTableConstants.expenseColTransactionType] = _transactionType;
    map[DBExpenseTableConstants.expenseColDate] = _date.toIso8601String();
    map[DBExpenseTableConstants.expenseColCategory] = _category;
    map[DBExpenseTableConstants.expenseColTags] = _tags;
    map[DBExpenseTableConstants.expenseColNote] = _note;
    map[DBExpenseTableConstants.expenseColContainsNestedExpenses] = _containsNestedExpenses;
    map[DBExpenseTableConstants.expenseColExpenses] = _expenses?.map((expense) => expense.toMap()).toList();
    if (_createdAt != null) map[DBExpenseTableConstants.createdAt] = _createdAt;
    if (_modifiedAt != null) map[DBExpenseTableConstants.modifiedAt] = _modifiedAt;
    return map;
  }

  //  // map to Expense Object
  Expense.fromMap(Map<String, dynamic> map)
      : _id = map[DBExpenseTableConstants.expenseColId],
        _title = map[DBExpenseTableConstants.expenseColTitle],
        _currency = map[DBExpenseTableConstants.expenseColCurrency],
        _amount = map[DBExpenseTableConstants.expenseColAmount],
        _transactionType = map[DBExpenseTableConstants.expenseColTransactionType],
        _date = DateTime.parse(map[DBExpenseTableConstants.expenseColDate]),
        _category = map[DBExpenseTableConstants.expenseColCategory],
        // _tags = map[DBExpenseTableConstants.expenseColTags]?.cast<String>(),
        _tags = map[DBExpenseTableConstants.expenseColTags],
        _note = map[DBExpenseTableConstants.expenseColNote],
        _containsNestedExpenses = map[DBExpenseTableConstants.expenseColContainsNestedExpenses],
        _createdAt = map[DBExpenseTableConstants.createdAt],
        _modifiedAt = map[DBExpenseTableConstants.modifiedAt],
        _expenses = (map[DBExpenseTableConstants.expenseColExpenses] as List<Map<String, dynamic>>?)
            ?.map((expenseMap) => Expense.fromMap(expenseMap))
            .toList();
}
