import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/tag_provider.dart';
import '../widgets/tag_list.dart';

class TagScreen extends StatelessWidget {
  const TagScreen({super.key});

  final String title = "Tags";

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _refreshTags(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Scaffold(
            appBar: AppBar(
              leading: SafeArea(
                  child: BackButton(
                onPressed: () => navigateBack(context, false),
              )),
              centerTitle: true,
              title: Text(title, textScaleFactor: 0.9),
              backgroundColor: Colors.black,
            ),
            body: Column(
              children: const [
                Expanded(
                  child: TagList(),
                )
              ],
            ),
          );
        }
      },
    );
  }

  Future<void> _refreshTags(BuildContext context) async {
    final provider = Provider.of<TagProvider>(context, listen: false);
    provider.refreshTags();
  }

  navigateBack(BuildContext context, bool result) =>
      Navigator.pop(context, result);
}
