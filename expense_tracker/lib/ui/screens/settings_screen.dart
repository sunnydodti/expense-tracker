import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  final String title = "Settings";

  Future<void> _refreshSettings(BuildContext context) async {
    // final provider = Provider.of<CategoryProvider>(context, listen: false);
    // provider.refreshCategories();
  }

  navigateBack(BuildContext context, bool result) =>
      Navigator.pop(context, result);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _refreshSettings(context),
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
                  child: Placeholder(),
                )
              ],
            ),
          );
        }
      },
    );
  }
}
