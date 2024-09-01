import '../data/constants/db_constants.dart';

class Profile {
  final int id;
  final String name;
  final DateTime createdAt;
  final DateTime modifiedAt;

  Profile(
      {required this.id,
      required this.name,
      required this.createdAt,
      required this.modifiedAt});

  Map<String, dynamic> toMap() => {
        DBConstants.profile.id: id,
        DBConstants.profile.id: name,
        DBConstants.common.createdAt: createdAt,
        DBConstants.common.modifiedAt: modifiedAt
      };

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
        id: map[DBConstants.profile.id],
        name: map[DBConstants.profile.name],
        createdAt: DateTime.parse(map[DBConstants.common.createdAt]),
        modifiedAt: DateTime.parse(map[DBConstants.common.modifiedAt]));
  }
}

class ProfileFormModel {
  int? id;
  String name;

  ProfileFormModel({required this.name});

  Map<String, dynamic> toMap() {
    return {DBConstants.profile.id: id, DBConstants.profile.name: name};
  }

  factory ProfileFormModel.fromMap(Map<String, dynamic> map) {
    return ProfileFormModel(name: map[DBConstants.profile.name]);
  }
}
