import '../data/constants/db_constants.dart';

class Tag {
  final int id;
  final String name;
  final DateTime createdAt;
  final DateTime modifiedAt;

  Tag(
      {required this.id,
      required this.name,
      required this.createdAt,
      required this.modifiedAt});

  Map<String, dynamic> toMap() {
    return {
      DBConstants.tag.id: id,
      DBConstants.tag.id: name,
      DBConstants.common.createdAt: createdAt,
      DBConstants.common.modifiedAt: modifiedAt
    };
  }

  factory Tag.fromMap(Map<String, dynamic> map) {
    return Tag(
        id: map[DBConstants.tag.id],
        name: map[DBConstants.tag.name],
        createdAt: DateTime.parse(map[DBConstants.common.createdAt]),
        modifiedAt: DateTime.parse(map[DBConstants.common.modifiedAt]));
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
