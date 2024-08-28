import '../data/constants/db_constants.dart';

class User {
  final int id;
  final String userName;
  final String email;
  final DateTime createdAt;
  final DateTime modifiedAt;

  User({
    required this.id,
    required this.userName,
    required this.email,
    required this.createdAt,
    required this.modifiedAt,
  });

  Map<String, dynamic> toMap() => {
    DBConstants.user.id: id,
    DBConstants.user.userName: userName,
    DBConstants.user.email: email,
    DBConstants.common.createdAt: createdAt,
    DBConstants.common.modifiedAt: modifiedAt,
  };

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map[DBConstants.user.id],
      userName: map[DBConstants.user.userName],
      email: map[DBConstants.user.email],
      createdAt: DateTime.parse(map[DBConstants.common.createdAt]),
      modifiedAt: DateTime.parse(map[DBConstants.common.modifiedAt]),
    );
  }
}

class UserFormModel {
  int? id;
  String userName;
  String email;

  UserFormModel({required this.userName, required this.email});

  Map<String, dynamic> toMap() {
    return {
      DBConstants.user.id: id,
      DBConstants.user.userName: userName,
      DBConstants.user.email: email,
    };
  }

  factory UserFormModel.fromMap(Map<String, dynamic> map) {
    return UserFormModel(
      userName: map[DBConstants.user.userName],
      email: map[DBConstants.user.email],
    );
  }
}