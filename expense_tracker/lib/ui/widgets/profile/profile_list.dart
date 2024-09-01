import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/helpers/color_helper.dart';
import '../../../models/profile.dart';
import '../../../providers/expense_provider.dart';
import '../../../providers/profile_provider.dart';
import '../../../service/profile_service.dart';
import '../../dialogs/common/confirmation_dialog.dart';
import '../../dialogs/common/message_dialog.dart';
import '../../forms/profile_form.dart';
import '../empty_list_widget.dart';
import 'profile_tile.dart';

class ProfileList extends StatelessWidget {
  const ProfileList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) => RefreshIndicator(
              onRefresh: () => profileProvider.refreshProfiles(),
              color: Colors.blue.shade500,
              child: Column(
                children: [
                  getProfileForm(profileProvider.profiles, context),
                  Expanded(
                    child: profileProvider.profiles.isEmpty
                        ? const EmptyListWidget(listName: 'Profile')
                        : Scrollbar(
                            interactive: true,
                            radius: const Radius.circular(5),
                            child: ListView.builder(
                              itemCount: profileProvider.profiles.length,
                              itemBuilder: (context, index) {
                                final profile =
                                    profileProvider.profiles[index];
                                return ProfileTile(
                                  profileName: profile.name,
                                  onDelete: () =>
                                      _handelDelete(context, profile),
                                );
                              },
                            ),
                          ),
                  )
                ],
              ),
            ));
  }

  _handelDelete(BuildContext context, Profile profile) {
    if (profile.id == 1) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return MessageDialog(
                title: "Action Not allowed",
                message: "Profile '${profile.name}' can't be deleted");
          });
      return;
    }
    _deleteProfileDialog(context, profile);
  }

  _deleteProfile(BuildContext context, Profile profile) async {
    Provider.of<ProfileProvider>(context, listen: false)
        .currentProfile
        .then((Profile? selectedProfile) async {
      if (selectedProfile?.id == profile.id) {
        Provider.of<ProfileProvider>(context, listen: false)
            .setDefaultProfile();
      }
      ProfileService profileService = await ProfileService.create();

      profileService.deleteProfile(profile.id).then((value) async {
        if (value > 0) {
          Provider.of<ExpenseProvider>(context, listen: false)
              .refreshExpenses();
          _refreshProfile(context);
        }
      });
    });
  }

  _deleteProfileDialog(BuildContext context, Profile profile) async {
    showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        Text content = const Text(
            "Warning\nYou will loose all the expenses in this profile");
        return ConfirmationDialog(
          title: "Delete Profile ${profile.name}",
          content: content,
          onConfirm: () => _deleteProfile(context, profile),
        );
      },
    );
  }

  _refreshProfile(BuildContext context) {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    profileProvider.refreshProfiles();
  }

  Container getProfileForm(
      List<Profile> profiles, BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: ColorHelper.getTileColor(Theme.of(context)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
        margin: const EdgeInsets.only(top: 5, bottom: 2.5),
        child: ProfileForm(profiles: profiles));
  }
}
