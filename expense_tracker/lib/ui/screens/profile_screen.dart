import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/helpers/color_helper.dart';
import '../../data/helpers/navigation_helper.dart';
import '../../providers/category_provider.dart';
import '../../providers/profile_provider.dart';
import '../widgets/category/category_list.dart';
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
      appBar: AppBar(
        leading: SafeArea(
            child: BackButton(
          onPressed: () => NavigationHelper.navigateBack(context),
        )),
        centerTitle: true,
        title: Text(title, textScaleFactor: 0.9),
        backgroundColor: ColorHelper.getAppBarColor(Theme.of(context)),
      ),
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
