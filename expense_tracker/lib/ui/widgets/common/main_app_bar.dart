import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/helpers/color_helper.dart';
import '../../../data/helpers/debug_helper.dart';
import '../../../data/helpers/navigation_helper.dart';
import '../../../models/profile.dart';
import '../../../providers/expense_provider.dart';
import '../../../providers/profile_provider.dart';
import '../../../service/expense_service.dart';
import '../../screens/search_screen.dart';
import '../../screens/settings/settings_screen.dart';

class MainAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final bool centerTitle;

  static final Future<ExpenseService> _expenseService = ExpenseService.create();

  const MainAppBar({
    super.key,
    this.title = "Expense Tracker",
    this.centerTitle = true,
  });

  @override
  State<MainAppBar> createState() => _MainAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _MainAppBarState extends State<MainAppBar> {
  ProfileProvider get profileProvider =>
      Provider.of<ProfileProvider>(context, listen: false);

  ExpenseProvider get expenseProvider => Provider.of(context, listen: false);

  Color get titleColor => ColorHelper.getTileColor(Theme.of(context));

  Future refreshExpenses() async => expenseProvider.refreshExpenses();

  void populateExpense() async {
    ExpenseService service = await MainAppBar._expenseService;
    await service.populateExpense(count: 1);
    refreshExpenses();
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

  void handleProfile() async {
    Profile? profile = await showMenu(
        context: context,
        position: const RelativeRect.fromLTRB(1000.0, 80.0, 0.0, 0.0),
        items: await buildProfileDropdown(profileProvider, Theme.of(context)),
        color: titleColor);

    if (profile != null) {
      profileProvider.setCurrentProfile(profile);
      expenseProvider.refreshExpenses();
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ColorHelper.getAppBarColor(Theme.of(context)),
      centerTitle: widget.centerTitle,
      title: Text(
        widget.title,
        textScaler: const TextScaler.linear(.85),
        overflow: TextOverflow.fade,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: buildAppBarActions(),
    );
  }

  List<Widget> buildAppBarActions() {
    return [
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
          onPressed: () {
            // setState(() => isSearching = true);
            NavigationHelper.navigateToScreen(context, const SearchScreen());
          },
          icon: const Icon(Icons.search_outlined)),
      IconButton(
        icon: const Icon(
          Icons.person,
          size: 20,
        ),
        tooltip: "Profile",
        onPressed: () async {
          await profileProvider.refreshProfiles();
          handleProfile();
        },
      ),
    ];
  }
}
