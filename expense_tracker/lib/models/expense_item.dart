import '../data/constants/db_constants.dart';

class ExpenseItem {
  final int id;
  final int expenseId;
  final String name;
  final double amount;
  final int quantity;
  final DateTime createdAt;
  final DateTime modifiedAt;

  ExpenseItem(
      {required this.id,
      required this.expenseId,
      required this.name,
      required this.amount,
      required this.quantity,
      required this.createdAt,
      required this.modifiedAt});

  Map<String, dynamic> toMap() {
    return {
      DBConstants.expenseItem.id: id,
      DBConstants.expenseItem.expenseId: expenseId,
      DBConstants.expenseItem.name: name,
      DBConstants.expenseItem.amount: amount,
      DBConstants.expenseItem.quantity: quantity,
      DBConstants.common.createdAt: createdAt,
      DBConstants.common.modifiedAt: modifiedAt
    };
  }

  factory ExpenseItem.fromMap(Map<String, dynamic> map) {
    return ExpenseItem(
      id: map[DBConstants.expenseItem.id],
      expenseId: map[DBConstants.expenseItem.expenseId],
      name: map[DBConstants.expenseItem.name],
      amount: map[DBConstants.expenseItem.amount],
      quantity: map[DBConstants.expenseItem.quantity],
      createdAt: DateTime.parse(map[DBConstants.common.createdAt]),
      modifiedAt: DateTime.parse(map[DBConstants.common.modifiedAt]),
    );
  }
}

class ExpenseItemFormModel {
  int? id;
  int? expenseId;
  String name;
  double amount;
  int quantity;
  DateTime? createdAt;
  DateTime? modifiedAt;

  final String uuid;

  ExpenseItemFormModel({
    required this.name,
    required this.amount,
    required this.quantity,
    this.id,
    this.expenseId,
    this.createdAt,
    this.modifiedAt,
  }) : uuid = DateTime.now().toString();

  factory ExpenseItemFormModel.forMigration({
    required name,
    required amount,
    required quantity,
    required expenseId,
  }) {
    return ExpenseItemFormModel(
      name: name,
      amount: amount,
      quantity: quantity,
      expenseId: expenseId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) DBConstants.expenseItem.id: id,
      DBConstants.expenseItem.expenseId: expenseId,
      DBConstants.expenseItem.name: name,
      DBConstants.expenseItem.amount: amount,
      DBConstants.expenseItem.quantity: quantity,
    };
  }

  factory ExpenseItemFormModel.fromMap(Map<String, dynamic> map) {
    return ExpenseItemFormModel(
        id: map[DBConstants.expenseItem.id],
        expenseId: map[DBConstants.expenseItem.expenseId],
        name: map[DBConstants.expenseItem.name],
        amount: map[DBConstants.expenseItem.amount],
        quantity: map[DBConstants.expenseItem.quantity],
        createdAt: DateTime.parse(map[DBConstants.common.createdAt]),
        modifiedAt: DateTime.parse(map[DBConstants.common.modifiedAt]));
  }
}
