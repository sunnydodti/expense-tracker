import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';

import '../data/constants/db_constants.dart';
import '../data/helpers/database/database_helper.dart';
import '../data/helpers/database/profile_helper.dart';
import '../models/profile.dart';

class ProfileService {
  late final ProfileHelper _profileHelper;
  static final Logger _logger =
  Logger(printer: SimplePrinter(), level: Level.info);

  ProfileService._(this._profileHelper);

  static Future<ProfileService> create() async {
    final databaseHelper = DatabaseHelper();
    await databaseHelper.initializeDatabase();
    final profileHelper = await databaseHelper.profileHelper;
    return ProfileService._(profileHelper);
  }

  Future<List<Profile>> getProfiles() async {
    try {
      final List<Map<String, dynamic>> profiles = await _profileHelper.getProfiles();
      List<Profile> tgs = profiles.map((profileMap) => Profile.fromMap(profileMap)).toList();
      return tgs;
    } catch (e, stackTrace) {
      _logger.e("Error getting profiles: $e - \n$stackTrace");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getProfileMaps() async {
    try {
      return await _profileHelper.getProfiles();
    } on Exception catch (e, stackTrace) {
      _logger.e("Error getting profiles: $e - \n$stackTrace");
      return [];
    }
  }

  Future<Profile?> getProfileByName(String profileName) async {
    try {
      final List<Map<String, dynamic>> profile =
      await _profileHelper.getProfileByName(profileName);
      return Profile.fromMap(profile.first);
    } catch (e, stackTrace) {
      _logger.e("Error getting profile ($profileName): $e - \n$stackTrace");
      return null;
    }
  }

  Future<int> addProfile(ProfileFormModel profile) async {
    try {
      final result = await _profileHelper.addProfile(profile.toMap());
      return result;
    } catch (e, stackTrace) {
      _logger.e("Error adding profile: $e - \n$stackTrace");
      return -1;
    }
  }

  Future<int> updateProfile(ProfileFormModel profile) async {
    try {
      final result = await _profileHelper.updateProfile(profile);
      return result;
    } catch (e, stackTrace) {
      _logger.e("Error updating profile: $e - \n$stackTrace");
      return -1;
    }
  }

  Future<int> deleteProfile(int id) async {
    try {
      final result = await _profileHelper.deleteProfile(id);
      return result;
    } catch (e, stackTrace) {
      _logger.e("Error deleting profile: $e - \n$stackTrace");
      return -1;
    }
  }

  Future<int> deleteAllProfiles() async {
    try {
      final result = await _profileHelper.deleteAllProfiles();
      return result;
    } catch (e, stackTrace) {
      _logger.e("Error deleting profiles - $e - \n$stackTrace");
      return -1;
    }
  }

  Profile? getMatchingProfile(String name, List<Profile> profiles) {
    try {
      if (name.isEmpty) return null;
      final matchingProfiles = profiles.where((profile) => profile.name == name);
      return matchingProfiles.isNotEmpty ? matchingProfiles.first : null;
    } on Exception catch (e, stackTrace) {
      _logger.e("Error getting profile ($name): $e - \n$stackTrace");
      return null;
    }
  }

  Future<bool> importProfile(Map<String, dynamic> profile, {safeImport = true}) async {
    _logger.i(
        "importing profile ${profile[DBConstants.profile.id]} - ${profile[DBConstants.profile.name]}");
    try {
      if (await isDuplicateProfile(profile[DBConstants.profile.name])) {
        _logger.i("found duplicate profile: ${profile[DBConstants.profile.name]}");
        if (safeImport) return false;
        _logger.i("safeImport: $safeImport - discarding existing profile");
        await _profileHelper.deleteProfileByName(profile[DBConstants.profile.name]);
      }
      if (await _profileHelper.addProfile(profile) > 0) {
        _logger.i("imported profile ${profile[DBConstants.profile.name]}");
        return true;
      }
    } on Exception catch (e, stackTrace) {
      _logger.e(
          "Error importing profile (${profile[DBConstants.profile.name]}): $e - \n$stackTrace");
    }
    return false;
  }

  Future<bool> isDuplicateProfile(String profileName) async {
    int count = await getProfileCount(profileName);
    if (count > 0) return true;
    return false;
  }

  Future<int> getProfileCount(String profileName) async {
    _logger.i("checking if profile exists $profileName");
    final List<Map<String, dynamic>> result =
    await _profileHelper.getProfileCountByName(profileName);
    int? count = Sqflite.firstIntValue(result);
    if (count == null) return 0;
    return count;
  }
}
