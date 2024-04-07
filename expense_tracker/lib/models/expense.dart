import 'package:expense_tracker/data/constants/db_constants.dart';

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

  // bool? _containsNestedExpenses; // required
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
      // [this._tags, this._note, this._containsNestedExpenses, this._expenses]
      [this._tags,
      this._note,
      this._expenses]);

  // Expense.empty();

  Expense.withId(this._id, this._title, this._currency, this._amount,
      this._transactionType, this._date, this._category,
      // [this._containsNestedExpenses, this._tags, this._note, this._expenses]
      [this._tags,
      this._note,
      this._expenses]);

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

  // bool? get containsNestedExpenses => _containsNestedExpenses;
  List<Expense>? get expenses => _expenses;

  DateTime? get createdAt => _createdAt;

  DateTime? get modifiedAt => _createdAt;

  //Setters
  set id(int? id) {
    _id = id;
  }

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

  set tag(String? tag) {
    _tags = tag;
  }

  set note(String? note) {
    _note = note;
  }

  // set containsNestedExpenses(bool? containsNestedExpenses) {
  //   _containsNestedExpenses = containsNestedExpenses;
  // }

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
    if (id != null) map[DBConstants.expense.id] = _id;
    map[DBConstants.expense.title] = _title;
    map[DBConstants.expense.currency] = _currency;
    map[DBConstants.expense.amount] = _amount;
    map[DBConstants.expense.transactionType] = _transactionType;
    map[DBConstants.expense.date] = _date.toIso8601String();
    map[DBConstants.expense.category] = _category;
    map[DBConstants.expense.tags] = _tags;
    map[DBConstants.expense.note] = _note;
    // map[DBExpenseTableConstants.containsNestedExpenses] = _containsNestedExpenses;
    map[DBConstants.expense.expenses] =
        _expenses?.map((expense) => expense.toMap()).toList();
    if (_createdAt != null) map[DBConstants.expense.createdAt] = _createdAt;
    if (_modifiedAt != null) map[DBConstants.expense.modifiedAt] = _modifiedAt;
    return map;
  }

  static List<Expense> fromMapList(List<Map<String, dynamic>> expenseMapList) {
    return expenseMapList.isEmpty
        ? []
        : expenseMapList
            .map((expenseMap) => Expense.fromMap(expenseMap))
            .toList();
    // return <Expense>[];
  }

  //  // map to Expense Object
  static Expense fromMap(Map<String, dynamic> map) {
    Expense expense = Expense(
      map[DBConstants.expense.title],
      map[DBConstants.expense.currency],
      map[DBConstants.expense.amount],
      map[DBConstants.expense.transactionType],
      DateTime.parse(map[DBConstants.expense.date]),
      map[DBConstants.expense.category],
    );

    expense.id = map[DBConstants.expense.id];
    expense.tags = map[DBConstants.expense.tags];
    // expense.tag = map[DBExpenseTableConstants.tag];
    expense.note = map[DBConstants.expense.note];
    // expense.containsNestedExpenses = _parseIntAsBool(map[DBExpenseTableConstants.containsNestedExpenses]!);
    expense.createdAt = DateTime.parse(map[DBConstants.expense.createdAt]);
    expense.modifiedAt = DateTime.parse(map[DBConstants.expense.modifiedAt]);
    return expense;
  }

  static bool _parseIntAsBool(int value) {
    return value != 0;
  }
}

class ExpenseFormModel {
  int? id;
  String title;
  String currency;
  double amount;
  String transactionType;
  DateTime date;
  String category;
  bool containsNestedExpenses;
  String? tags;
  String? note;
  List<ExpenseFormModel>? expenses;
  DateTime? createdAt;
  DateTime? modifiedAt;

  ExpenseFormModel(this.title, this.currency, this.amount, this.transactionType,
      this.date, this.category, this.containsNestedExpenses,
      [this.tags, this.note, this.expenses]);

  // Expense.empty();

  ExpenseFormModel.withId(
      this.id,
      this.title,
      this.currency,
      this.amount,
      this.transactionType,
      this.date,
      this.category,
      this.containsNestedExpenses,
      [this.tags,
      this.note,
      this.expenses]);

  // Methods
  //  // Expense Object to map
  // Getter for the Map representation
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};
    if (id != null) map[DBConstants.expense.id] = id;
    map[DBConstants.expense.title] = title;
    map[DBConstants.expense.currency] = currency;
    map[DBConstants.expense.amount] = amount;
    map[DBConstants.expense.transactionType] = transactionType;
    map[DBConstants.expense.date] = date.toIso8601String();
    map[DBConstants.expense.category] = category;
    map[DBConstants.expense.tags] = tags;
    map[DBConstants.expense.note] = note;
    map[DBConstants.expense.containsNestedExpenses] = containsNestedExpenses;
    map[DBConstants.expense.expenses] =
        expenses?.map((expense) => expense.toMap()).toList();
    map[DBConstants.expense.createdAt] = createdAt!.toIso8601String();
    map[DBConstants.expense.modifiedAt] = modifiedAt!.toIso8601String();
    return map;
  }

  //  // map to Expense Object
  ExpenseFormModel.fromMap(Map<String, dynamic> map)
      : id = map[DBConstants.expense.id],
        title = map[DBConstants.expense.title],
        currency = map[DBConstants.expense.currency],
        amount = map[DBConstants.expense.amount],
        transactionType = map[DBConstants.expense.transactionType],
        date = DateTime.parse(map[DBConstants.expense.date]),
        category = map[DBConstants.expense.category],
        // tags = map[DBExpenseTableConstants.Tags]?.cast<String>(),
        tags = map[DBConstants.expense.tags],
        note = map[DBConstants.expense.note],
        containsNestedExpenses =
            map[DBConstants.expense.containsNestedExpenses],
        createdAt = map[DBConstants.expense.createdAt],
        modifiedAt = map[DBConstants.expense.modifiedAt],
        expenses =
            (map[DBConstants.expense.expenses] as List<Map<String, dynamic>>?)
                ?.map((expenseMap) => ExpenseFormModel.fromMap(expenseMap))
                .toList();
}
