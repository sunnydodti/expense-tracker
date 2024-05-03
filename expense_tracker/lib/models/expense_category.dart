import '../data/constants/db_constants.dart';

class ExpenseCategory {
  final int id;
  final String name;
  final DateTime createdAt;
  final DateTime modifiedAt;

  ExpenseCategory({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.modifiedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      DBConstants.category.id: id,
      DBConstants.category.id: name,
      DBConstants.common.createdAt: createdAt,
      DBConstants.common.modifiedAt: modifiedAt
    };
  }

  factory ExpenseCategory.fromMap(Map<String, dynamic> map) {
    return ExpenseCategory(
        id: map[DBConstants.category.id],
        name: map[DBConstants.category.name],
        createdAt: DateTime.parse(map[DBConstants.common.createdAt]),
        modifiedAt: DateTime.parse(map[DBConstants.common.modifiedAt]));
  }
}

class CategoryFormModel {
  int? id;
  String name;

  CategoryFormModel({required this.name});

  Map<String, dynamic> toMap() {
    return {DBConstants.category.id: id, DBConstants.category.name: name};
  }

  factory CategoryFormModel.fromMap(Map<String, dynamic> map) {
    return CategoryFormModel(name: map[DBConstants.category.name]);
  }
}
