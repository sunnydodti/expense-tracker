import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/helpers/color_helper.dart';
import '../../providers/profile_provider.dart';
import '../widgets/common/screen_app_bar.dart';
import '../widgets/profile/profile_list.dart';
import 'widget_constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<void> _profilesFuture;

  @override
  void initState() {
    super.initState();
    _profilesFuture = _refreshProfiles();
  }

  Future<void> _refreshProfiles() async {
    final provider = Provider.of<ProfileProvider>(context, listen: false);
    await provider.refreshProfiles();
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
              future: _profilesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return wcSpinnerDefault;
                }
                if (snapshot.hasError) {
                  return Center(child: wcSnapshotErrorText(snapshot.error));
                }
                return const ProfileList();
              },
            ),
          )
        ],
      ),
    );
  }
}
