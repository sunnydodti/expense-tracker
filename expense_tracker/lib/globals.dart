import 'package:flutter/material.dart';

import 'ui/widgets/content_area_navigation.dart';

final GlobalKey<ScaffoldMessengerState> snackbarKey =
    GlobalKey<ScaffoldMessengerState>();

final GlobalKey<ContentAreaNavigationState> desktopContentAreaKey =
    GlobalKey<ContentAreaNavigationState>();

final GlobalKey<ContentAreaNavigationState> tabletContentAreaKey =
    GlobalKey<ContentAreaNavigationState>();

// Helper function to get the appropriate content area key based on layout
GlobalKey<ContentAreaNavigationState> getContentAreaKey(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  if (width >= 1100) return desktopContentAreaKey;
  if (width >= 720) return tabletContentAreaKey;
  return GlobalKey<ContentAreaNavigationState>(); // Fallback, won't be used
}
