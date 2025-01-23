import '../data/constants/db_constants.dart';

class Search {
  final int id;
  final String? title;
  final double? amount;
  final DateTime createdAt;
  final DateTime modifiedAt;

  Search(
      {required this.id,
      required this.title,
      required this.amount,
      required this.createdAt,
      required this.modifiedAt});

  Map<String, dynamic> toMap() {
    return {
      DBConstants.search.id: id,
      DBConstants.search.id: title,
      DBConstants.search.id: amount,
      DBConstants.common.createdAt: createdAt,
      DBConstants.common.modifiedAt: modifiedAt
    };
  }

  factory Search.fromMap(Map<String, dynamic> map) {
    return Search(
        id: map[DBConstants.search.id],
        title: map[DBConstants.search.title],
        amount: map[DBConstants.search.amount],
        createdAt: DateTime.parse(map[DBConstants.common.createdAt]),
        modifiedAt: DateTime.parse(map[DBConstants.common.modifiedAt]));
  }
}

class SearchFormModel {
  int? id;
  String? title;
  double? amount;

  SearchFormModel({this.title, this.amount});

  Map<String, dynamic> toMap() {
    return {
      DBConstants.search.id: id,
      DBConstants.search.title: title,
      DBConstants.search.amount: amount
    };
  }

  factory SearchFormModel.fromMap(Map<String, dynamic> map) {
    return SearchFormModel(
        title: map[DBConstants.search.title],
        amount: map[DBConstants.search.amount]);
  }
}
