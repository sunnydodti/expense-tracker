import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/helpers/color_helper.dart';
import '../../providers/tag_provider.dart';
import '../widgets/common/screen_app_bar.dart';
import '../widgets/tag/tag_list.dart';
import 'widget_constants.dart';

class TagScreen extends StatefulWidget {
  const TagScreen({super.key});

  @override
  State<TagScreen> createState() => _TagScreenState();
}

class _TagScreenState extends State<TagScreen> {
  late Future<void> _tagsFuture;

  @override
  void initState() {
    super.initState();
    _tagsFuture = _refreshTags();
  }

  Future<void> _refreshTags() async {
    final provider = Provider.of<TagProvider>(context, listen: false);
    await provider.refreshTags();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorHelper.getBackgroundColor(Theme.of(context)),
      appBar: const ScreenAppBar(title: 'Tags'),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<void>(
              future: _tagsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return wcSpinnerDefault;
                }
                if (snapshot.hasError) {
                  return Center(child: wcSnapshotErrorText(snapshot.error));
                }
                return const TagList();
              },
            ),
          )
        ],
      ),
    );
  }
}
