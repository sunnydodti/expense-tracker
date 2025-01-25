import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../models/profile.dart';
import '../../providers/profile_provider.dart';
import '../../service/profile_service.dart';

class ProfileForm extends StatefulWidget {
  final List<Profile> profiles;

  const ProfileForm({Key? key, required this.profiles}) : super(key: key);

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final _formKey = GlobalKey<FormState>();

  static final Logger _logger =
  Logger(printer: SimplePrinter(), level: Level.info);

  final _profileController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _profileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: const VisualDensity(vertical: 4),
        title: Form(
          key: _formKey,
          child: TextFormField(
            controller: _profileController,
            decoration: InputDecoration(
                hintText: "Add Profile Name",
                labelStyle: TextStyle(
                  color: getColor(context),
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: getColor(context),
                    )),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: getColor(context),
                    )),
                label: const Text("New Profile", textScaleFactor: .9)),
            validator: _validateNewProfile,
            onSaved: submitProfile,
            onChanged: (value) {
              _logger.i("profile: $value");
            },
          ),
        ),
        trailing: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.add, color: getColor(context)),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                }
              },
              tooltip: "Save Profile",
            ),
            const Expanded(child: Text("Add"))
          ],
        ));
  }

  Color getColor(BuildContext context) {
    Brightness brightness = Theme.of(context).brightness;
    return (brightness == Brightness.dark
        ? Colors.green.shade300
        : Colors.green.shade700);
  }

  void submitProfile(newValue) async {
    if (_formKey.currentState?.validate() ?? false) {
      ProfileFormModel profile =
      ProfileFormModel(name: _profileController.text.trim());
      _addProfile(profile).then((value) {
        if (value > 0) {
          _profileController.clear();
          _refreshProfiles();
        }
      });
    }
  }

  Future<int> _addProfile(ProfileFormModel profile) async {
    ProfileService profileService = await ProfileService.create();
    return profileService.addProfile(profile);
  }

  void _refreshProfiles() {
    final profileProvider =
    Provider.of<ProfileProvider>(context, listen: false);
    profileProvider.refreshProfiles();
  }

  String? _validateNewProfile(value) {
    if (_profileController.text.isEmpty) {
      return 'Please enter a profile name.';
    }
    if (isDuplicateProfile()) return "Profile must be unique";
    return null;
  }

  bool isDuplicateProfile() {
    for (Profile profile in widget.profiles) {
      if (profile.name == _profileController.text) return true;
    }
    return false;
  }
}
