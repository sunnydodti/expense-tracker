import 'package:flutter/material.dart';

import '../drawer/home_drawer.dart';
import '../widgets/common/main_app_bar.dart';

class DesktopScaffold extends StatelessWidget {
  const DesktopScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: HomeDrawer(),
      appBar: const MainAppBar(centerTitle: false),
      backgroundColor: Colors.blue,
      body: Row(
        children: const [
          HomeDrawer(),
        ],
      ),
    );
  }
}
