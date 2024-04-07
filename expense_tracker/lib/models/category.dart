import 'package:expense_tracker/data/constants/db_constants.dart';

class Category {
  final int id;
  final String name;

  Category({required this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {DBConstants.category.id: id, DBConstants.category.id: name};
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
        id: map[DBConstants.category.id], name: map[DBConstants.category.name]);
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
