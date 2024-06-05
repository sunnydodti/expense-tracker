import 'package:flutter/material.dart';

import '../drawer/home_drawer.dart';
import '../widgets/common/main_app_bar.dart';

class MobileScaffold extends StatelessWidget {
  const MobileScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SafeArea(child: HomeDrawer()),
      appBar: const MainAppBar(),
      backgroundColor: Theme.of(context).colorScheme.primary.withBlue(500),
    );
  }
}
