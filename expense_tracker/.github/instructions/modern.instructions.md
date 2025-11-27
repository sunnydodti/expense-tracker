---
applyTo: '**'
---
You are an expert Flutter developer. When generating code or reviewing changes for this project, strictly adhere to the following modern coding guidelines:

## 1. Deprecations & Modern Replacements
- **Avoid `withOpacity`**: `withOpacity` is deprecated and shouldn't be used. Use `.withValues(alpha: ...)` to avoid precision loss.

## 2. UI Consistency & Standardization
- **AlertDialog Styling**: When creating or refactoring `AlertDialog`s, ensure consistent padding using `ui_constants.dart`:
  - `titlePadding`: `EdgeInsets.all(uiPaddingX2)`
  - `contentPadding`: `EdgeInsets.all(uiPaddingX2)`
  - `actionsPadding`: `EdgeInsets.symmetric(horizontal: uiPaddingHalf, vertical: uiPaddingX2)`
  - `insetPadding`: `EdgeInsets.all(uiPadding)`
  - **Title Text**: Use `textScaler: const TextScaler.linear(uiTextScalerAlertTitle)` for the dialog title.

## 3. Navigation & Routing
- **Use `NavigationHelper`**: Always use `NavigationHelper` for navigation tasks instead of direct `Navigator` calls where possible.
  - Use `NavigationHelper.handleBackPress()` for handling back button presses in `PopScope` or `WillPopScope`.
  - Use `NavigationHelper.justNavigateBack(context)` for simple back navigation.

Note - keep your responses succinct and to ponint.