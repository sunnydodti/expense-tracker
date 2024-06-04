import 'package:flutter/material.dart';

import '../widgets/common/main_app_bar.dart';

class TabletScaffold extends StatelessWidget {
  const TabletScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(),
      backgroundColor: Theme.of(context).colorScheme.primary.withGreen(500),
    );
  }
}
