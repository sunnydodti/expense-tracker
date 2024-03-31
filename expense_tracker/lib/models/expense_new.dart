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
    [this._tags, this._note, this._expenses]
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
      // [this._containsNestedExpenses, this._tags, this._note, this._expenses]
      [this._tags, this._note, this._expenses]
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
    if (id != null) map[DBExpenseTableConstants.id] = _id;
    map[DBExpenseTableConstants.title] = _title;
    map[DBExpenseTableConstants.currency] = _currency;
    map[DBExpenseTableConstants.amount] = _amount;
    map[DBExpenseTableConstants.transactionType] = _transactionType;
    map[DBExpenseTableConstants.date] = _date.toIso8601String();
    map[DBExpenseTableConstants.category] = _category;
    map[DBExpenseTableConstants.tags] = _tags;
    map[DBExpenseTableConstants.note] = _note;
    // map[DBExpenseTableConstants.containsNestedExpenses] = _containsNestedExpenses;
    map[DBExpenseTableConstants.expenses] = _expenses?.map((expense) => expense.toMap()).toList();
    if (_createdAt != null) map[DBExpenseTableConstants.createdAt] = _createdAt;
    if (_modifiedAt != null) map[DBExpenseTableConstants.modifiedAt] = _modifiedAt;
    return map;
  }
  static List<Expense> fromMapList(List<Map<String, dynamic>> expenseMapList) {
    return expenseMapList.isEmpty
        ? []
        : expenseMapList.map((expenseMap) => Expense.fromMap(expenseMap)).toList();
    // return <Expense>[];
  }
  //  // map to Expense Object
  static Expense fromMap(Map<String, dynamic> map){
    Expense expense = Expense(
        map[DBExpenseTableConstants.title],
        map[DBExpenseTableConstants.currency],
        map[DBExpenseTableConstants.amount],
        map[DBExpenseTableConstants.transactionType],
        DateTime.parse(map[DBExpenseTableConstants.date]),
        map[DBExpenseTableConstants.category],);

        expense.id = map[DBExpenseTableConstants.id];
        expense.tags = map[DBExpenseTableConstants.tags];
        // expense.tag = map[DBExpenseTableConstants.tag];
        expense.note = map[DBExpenseTableConstants.note];
        // expense.containsNestedExpenses = _parseIntAsBool(map[DBExpenseTableConstants.containsNestedExpenses]!);
        expense.createdAt = DateTime.parse(map[DBExpenseTableConstants.createdAt]);
        expense.modifiedAt = DateTime.parse(map[DBExpenseTableConstants.modifiedAt]);
    return expense;
  }

  // _expenses = (map[DBExpenseTableConstants.expenses]! as List<Map<String, dynamic>>?)
        //     ?.map((expenseMap) => Expense.fromMap(expenseMap))
        //     .toList();
  static bool _parseIntAsBool(int value) {
    return value != 0;
  }

}
