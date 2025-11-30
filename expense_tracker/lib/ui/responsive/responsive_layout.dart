import 'package:flutter/material.dart';

import '../../data/constants/ui_constants.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileScaffold;
  final Widget tabletScaffold;
  final Widget desktopScaffold;

  const ResponsiveLayout(
      {super.key,
      required this.mobileScaffold,
      required this.tabletScaffold,
      required this.desktopScaffold});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double width = constraints.maxWidth;
      if (width <= uiBreakpointTablet) return mobileScaffold; //500
      if (width <= uiBreakpointDesktop) return tabletScaffold;
      return desktopScaffold;
    });
  }
}
