import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/helpers/color_helper.dart';
import '../../../data/helpers/debug_helper.dart';
import '../../../data/helpers/navigation_helper.dart';
import '../../../models/profile.dart';
import '../../../providers/expense_provider.dart';
import '../../../providers/profile_provider.dart';
import '../../../service/expense_service.dart';
import '../../screens/settings/settings_screen.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool centerTitle;

  static final Future<ExpenseService> _expenseService = ExpenseService.create();

  const MainAppBar({
    super.key,
    this.title = "Expense Tracker",
    this.centerTitle = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    ProfileProvider getProfileProvider() =>
        Provider.of<ProfileProvider>(context, listen: false);

    Future refreshExpenses(BuildContext context) async {
      Provider.of<ExpenseProvider>(context, listen: false).refreshExpenses();
    }

    void populateExpense() async {
      ExpenseService service = await _expenseService;
      service
          .populateExpense(count: 1)
          .then((value) => refreshExpenses(context));
    }

    navigateToScreen() {
      NavigationHelper.navigateToScreen(context, const SettingsScreen());
    }

    Future<List<PopupMenuItem<Profile>>> buildProfileDropdown(
        ProfileProvider provider, ThemeData theme) async {
      Profile? selectedProfile = await provider.currentProfile;
      return provider.profiles.map((profile) {
        return PopupMenuItem<Profile>(
          value: profile,
          enabled: selectedProfile!.id != profile.id,
          child: Text(
            profile.name,
            style: (selectedProfile.id != profile.id)
                ? null
                : const TextStyle(
                    fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
          ),
        );
      }).toList();
    }

    void handleProfile(BuildContext context, ProfileProvider provider) async {
      showMenu(
              context: context,
              position: const RelativeRect.fromLTRB(1000.0, 80.0, 0.0, 0.0),
              items: await buildProfileDropdown(provider, Theme.of(context)),
              color: ColorHelper.getTileColor(Theme.of(context)))
          .then((Profile? profile) {
        if (profile != null) {
          provider.setCurrentProfile(profile);
          Provider.of<ExpenseProvider>(context, listen: false)
              .refreshExpenses();
        }
      });
    }

    return AppBar(
      backgroundColor: ColorHelper.getAppBarColor(Theme.of(context)),
      centerTitle: centerTitle,
      title: Text(
        title,
        textScaleFactor: .85,
        overflow: TextOverflow.fade,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        if (DebugHelper.isDebugMode)
          IconButton(
            icon: const Icon(
              Icons.add,
              size: 20,
            ),
            tooltip: "Add random expense",
            onPressed: populateExpense,
          ),
        if (DebugHelper.isDebugMode)
          IconButton(
            icon: const Icon(
              Icons.add_to_home_screen_outlined,
              size: 20,
            ),
            tooltip: "Navigate to screen",
            onPressed: navigateToScreen,
          ),
        IconButton(
          icon: const Icon(
            Icons.person,
            size: 20,
          ),
          tooltip: "Profile",
          onPressed: () async {
            ProfileProvider provider = getProfileProvider();
            provider
                .refreshProfiles()
                .then((value) => handleProfile(context, provider));
          },
        ),
      ],
    );
  }
}
