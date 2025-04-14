import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/helpers/color_helper.dart';
import '../../providers/profile_provider.dart';
import '../widgets/common/screen_app_bar.dart';
import '../widgets/profile/profile_list.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  final String title = "Profiles";

  Future<void> _refreshProfiles(BuildContext context) async {
    final provider = Provider.of<ProfileProvider>(context, listen: false);
    provider.refreshProfiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorHelper.getBackgroundColor(Theme.of(context)),
      appBar: const ScreenAppBar(title: 'Profile'),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<void>(
              future: _refreshProfiles(context),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return const ProfileList();
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
