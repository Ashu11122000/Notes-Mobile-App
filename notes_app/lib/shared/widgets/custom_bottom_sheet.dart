import 'package:flutter/material.dart';

/// ============================================================================
/// File: custom_bottom_sheet.dart
/// ============================================================================
///
/// Enterprise Material 3 modal bottom sheet helper.
///
/// Centralizes bottom sheet configuration to provide consistent styling,
/// accessibility, and behavior throughout the application.
///
/// Features:
///
/// - Material 3 compliant
/// - Theme-aware
/// - Keyboard friendly
/// - Responsive
/// - Accessible
/// - Reusable
///
/// Common usage:
///
/// - Sort options
/// - Filters
/// - Image selection
/// - Settings
/// - Confirmations
/// - Forms
abstract final class CustomBottomSheet {
  /// Standard top radius used by application bottom sheets.
  static const BorderRadius _borderRadius = BorderRadius.vertical(
    top: Radius.circular(28),
  );

  /// Maximum width on large screens.
  static const double _maxContentWidth = 640;

  /// Displays a Material 3 modal bottom sheet.
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    bool isDismissible = true,
    bool enableDrag = true,
    bool isScrollControlled = true,
    bool useSafeArea = true,
    bool useRootNavigator = false,
    bool showDragHandle = true,
    bool requestFocus = true,
    EdgeInsetsGeometry? padding,
    Color? backgroundColor,
    Color? barrierColor,
    ShapeBorder? shape,
    Clip clipBehavior = Clip.antiAlias,
  }) {
    final theme = Theme.of(context);

    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: isScrollControlled,
      useSafeArea: useSafeArea,
      useRootNavigator: useRootNavigator,
      showDragHandle: showDragHandle,
      requestFocus: requestFocus,
      barrierColor: barrierColor,
      backgroundColor: backgroundColor ?? theme.colorScheme.surfaceContainerLow,
      shape: shape ?? const RoundedRectangleBorder(borderRadius: _borderRadius),
      clipBehavior: clipBehavior,
      builder: (context) {
        final viewInsets = MediaQuery.viewInsetsOf(context);

        return AnimatedPadding(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(bottom: viewInsets.bottom),
          child: SafeArea(
            top: false,
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: _maxContentWidth),
                child: Padding(
                  padding: padding ?? EdgeInsets.zero,
                  child: child,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
