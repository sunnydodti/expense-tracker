import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import '../models/profile.dart';
import '../service/profile_service.dart';

class ProfileProvider extends ChangeNotifier {
  late final Future<ProfileService> _profileService;
  static final Logger _logger =
  Logger(printer: SimplePrinter(), level: Level.info);

  ProfileProvider() {
    _init();
  }

  Future<void> _init() async {
    _profileService = ProfileService.create();
  }

  List<Profile> _profiles = [];
  Profile? _currentProfile;

  /// Get list of all profiles
  List<Profile> get profiles => _profiles;

  /// Get the current active profile
  Profile? get currentProfile => _currentProfile;

  /// Set the current active profile
  void setCurrentProfile(Profile profile) {
    _currentProfile = profile;
    notifyListeners();
  }

  /// Add a profile. This does not add it to the database
  void addProfile(Profile profile) {
    _profiles.add(profile);
    notifyListeners();
  }

  /// Insert a profile at a specific index. This does not insert it into the database
  void insertProfile(int index, Profile profile) {
    _profiles.insert(index, profile);
    notifyListeners();
  }

  /// Get profile by id. This does not fetch it from the database
  Profile? getProfile(int id) {
    try {
      return _profiles.firstWhere((profile) => profile.id == id);
    } catch (e, stackTrace) {
      _logger.e('Error getting profile ($id): $e - \n$stackTrace');
      return null;
    }
  }

  /// Edit a profile. This does not update it in the database
  void editProfile(Profile editedProfile) {
    final index = _profiles.indexWhere((profile) => profile.id == editedProfile.id);
    if (index != -1) {
      _profiles[index] = editedProfile;
      notifyListeners();
    }
  }

  /// Delete a profile by id. This does not delete it from the database
  void deleteProfile(int id) {
    _profiles.removeWhere((profile) => profile.id == id);
    notifyListeners();
  }

  /// Refresh profiles from the database
  Future<void> refreshProfiles({bool notify = true}) async {
    try {
      List<Profile> profiles = await _getProfiles();
      profiles.sort((a, b) => b.createdAt.compareTo(a.modifiedAt));
      _profiles = profiles;
      if (notify) notifyListeners();
    } catch (e, stackTrace) {
      _logger.e('Error refreshing profiles: $e - \n$stackTrace');
    }
  }

  /// Fetch updated profiles from the database
  Future<List<Profile>> _getProfiles() async {
    ProfileService profileService = await _profileService;
    return await profileService.getProfiles();
  }
}
