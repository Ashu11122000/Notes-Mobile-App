import 'package:flutter/material.dart';

/// ============================================================================
/// File: custom_bottom_sheet.dart
/// ============================================================================
///
/// Enterprise Material 3 modal bottom sheet helper.
///
/// This utility centralizes the application's bottom sheet configuration to
/// ensure a consistent appearance and behavior across all features.
///
/// Benefits:
///
/// - Material 3 compliant
/// - Theme-aware
/// - Keyboard friendly
/// - Responsive
/// - Accessible
/// - Reusable
///
/// Typical use cases:
///
/// - Sort options
/// - Filter dialogs
/// - Image source selection
/// - Settings
/// - Confirmation actions
/// - Custom forms
///
/// Example:
///
/// ```dart
/// await CustomBottomSheet.show(
///   context: context,
///   child: const SortBottomSheet(),
/// );
/// ```
abstract final class CustomBottomSheet {
  /// Standard top corner radius used by all application bottom sheets.
  static const BorderRadius _borderRadius = BorderRadius.vertical(
    top: Radius.circular(28),
  );

  /// Maximum content width for large screens.
  ///
  /// This keeps bottom sheets visually comfortable on tablets and desktop
  /// while remaining full-width on phones.
  static const double _maxContentWidth = 640;

  /// Displays a Material 3 modal bottom sheet.
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    bool isDismissible = true,
    bool enableDrag = true,
    bool isScrollControlled = false,
    bool useSafeArea = true,
    bool useRootNavigator = false,
    bool showDragHandle = true,
    EdgeInsetsGeometry? padding,
    Color? backgroundColor,
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
      backgroundColor: backgroundColor ?? theme.colorScheme.surfaceContainerLow,
      clipBehavior: clipBehavior,
      shape: shape ?? const RoundedRectangleBorder(borderRadius: _borderRadius),
      builder: (context) {
        final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

        return SafeArea(
          top: false,
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: _maxContentWidth),
              child: Padding(
                padding: (padding ?? EdgeInsets.zero).add(
                  EdgeInsets.only(bottom: bottomInset),
                ),
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }
}
