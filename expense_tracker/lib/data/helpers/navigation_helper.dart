import 'package:flutter/material.dart';
import '../../globals.dart';

class NavigationHelper {
  // Smart "back" navigation that checks if we're in content area mode first
  static void navigateBack(BuildContext context) {
    if (isLargeScreen(context)) {
      // Try content area navigation first
      final bool didPop = navigateBackFromContentArea(context);
      // If there was nothing to pop in content area, use regular back
      if (!didPop) {
        Navigator.pop(context);
      }
    } else {
      // Regular navigation for mobile layout
      Navigator.pop(context);
    }
  }

  // Smart "back with result" that handles both navigation modes
  static void navigateBackWithBool(BuildContext context, bool result) {
    if (isLargeScreen(context)) {
      // For large screens, we'll use content area navigation if there's content to pop
      final bool didPop = navigateBackFromContentArea(context);
      // If no content was popped, use regular back navigation
      if (!didPop) {
        Navigator.pop(context, result);
      }
    } else {
      // Regular navigation for mobile layout
      Navigator.pop(context, result);
    }
  }

  // Regular forward navigation (only used when content area isn't appropriate)
  static void navigateToScreen(BuildContext context, Widget screenWidget) {
    // Use smart navigation to automatically pick the right approach
    smartNavigate(context, screenWidget);
  }

  static void navigateToRoute(BuildContext context, Widget widget) {
    // For special routes like dialogs, we'll continue to use normal navigation
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) => widget,
      ),
    );
  }

  // PRIVATE: Content area navigation helpers
  static void _navigateToContentArea(BuildContext context, Widget content) {
    final key = getContentAreaKey(context);
    key.currentState?.pushContent(content);
  }

  static bool navigateBackFromContentArea(BuildContext context) {
    final key = getContentAreaKey(context);
    return key.currentState?.popContent() ?? false;
  }

  // Helpers to determine screen sizes
  static bool isLargeScreen(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 720; // Tablet/desktop threshold
  }

  static bool isDesktopScreen(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 1100;
  }

  // Smart navigation that uses content area on large screens
  // and full screen navigation on small screens
  static void smartNavigate(BuildContext context, Widget content) {
    if (isLargeScreen(context)) {
      _navigateToContentArea(context, content);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => content,
        ),
      );
    }
  }

  // Handle system back button press
  static Future<bool> handleBackPress() async {
    if (desktopContentAreaKey.currentState?.canPop() ?? false) {
      desktopContentAreaKey.currentState?.popContent();
      return false; // Prevent app from exiting
    }

    if (tabletContentAreaKey.currentState?.canPop() ?? false) {
      tabletContentAreaKey.currentState?.popContent();
      return false; // Prevent app from exiting
    }

    return true; // Allow normal back behavior
  }
}