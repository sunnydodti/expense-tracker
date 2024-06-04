import 'package:flutter/material.dart';

import '../widgets/common/main_app_bar.dart';

class DesktopScaffold extends StatelessWidget {
  const DesktopScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.blue,
      appBar: MainAppBar(centerTitle: false),
    );
  }
}
