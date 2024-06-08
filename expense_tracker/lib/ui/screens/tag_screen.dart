import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/helpers/color_helper.dart';
import '../../data/helpers/navigation_helper.dart';
import '../../providers/tag_provider.dart';
import '../widgets/tag/tag_list.dart';

class TagScreen extends StatelessWidget {
  const TagScreen({super.key});

  final String title = "Tags";

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
              future: _refreshTags(context),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return const TagList();
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Future<void> _refreshTags(BuildContext context) async {
    final provider = Provider.of<TagProvider>(context, listen: false);
    provider.refreshTags();
  }
}
