import 'package:expense_tracker/data/constants/db_constants.dart';

class Tag {
  final int id;
  final String name;

  Tag({required this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {DBConstants.tag.id: id, DBConstants.tag.id: name};
  }

  factory Tag.fromMap(Map<String, dynamic> map) {
    return Tag(
        id: map[DBConstants.tag.id], name: map[DBConstants.tag.name]);
  }
}

class TagFormModel {
  int? id;
  String name;

  TagFormModel({required this.name});

  Map<String, dynamic> toMap() {
    return {DBConstants.tag.id: id, DBConstants.tag.name: name};
  }

  factory TagFormModel.fromMap(Map<String, dynamic> map) {
    return TagFormModel(name: map[DBConstants.tag.name]);
  }
}
