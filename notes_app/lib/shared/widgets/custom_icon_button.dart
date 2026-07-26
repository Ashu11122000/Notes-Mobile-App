import 'package:flutter/material.dart';

/// ============================================================================
/// File: custom_icon_button.dart
/// ============================================================================
///
/// Enterprise Material 3 reusable icon button.
///
/// This widget standardizes icon button behavior throughout the application,
/// providing a consistent API while supporting all Material 3 icon button
/// variants.
///
/// Features:
/// - Material 3 compliant
/// - Theme-aware
/// - Accessible
/// - Loading state
/// - Desktop/Web friendly
/// - Highly reusable
///
/// Typical use cases:
/// - Refresh
/// - Edit
/// - Delete
/// - Search
/// - Settings
/// - Profile
/// - Navigation
/// ============================================================================
enum CustomIconButtonVariant { standard, filled, filledTonal, outlined }

/// Enterprise reusable Material 3 icon button.
@immutable
final class CustomIconButton extends StatelessWidget {
  /// Creates a reusable icon button.
  const CustomIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.variant = CustomIconButtonVariant.standard,
    this.isLoading = false,
    this.iconSize,
    this.iconColor,
    this.style,
    this.visualDensity,
    this.mouseCursor,
    this.focusNode,
    this.autofocus = false,
    this.constraints,
    this.splashRadius,
  });

  /// Icon displayed by the button.
  final IconData icon;

  /// Invoked when the button is pressed.
  final VoidCallback? onPressed;

  /// Optional tooltip shown on long press or hover.
  final String? tooltip;

  /// Material 3 icon button style.
  final CustomIconButtonVariant variant;

  /// Whether the button should display a loading indicator.
  final bool isLoading;

  /// Icon size.
  final double? iconSize;

  /// Optional icon color.
  final Color? iconColor;

  /// Optional button style.
  final ButtonStyle? style;

  /// Visual density.
  final VisualDensity? visualDensity;

  /// Mouse cursor used on desktop and web.
  final MouseCursor? mouseCursor;

  /// Optional focus node.
  final FocusNode? focusNode;

  /// Whether this button should receive focus automatically.
  final bool autofocus;

  /// Optional constraints.
  final BoxConstraints? constraints;

  /// Optional splash radius.
  final double? splashRadius;

  @override
  Widget build(BuildContext context) {
    final Widget iconWidget = AnimatedSwitcher(
      duration: const Duration(milliseconds: 180),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      child: isLoading
          ? SizedBox.square(
              key: const ValueKey('loading'),
              dimension: iconSize ?? 20,
              child: CircularProgressIndicator.adaptive(strokeWidth: 2),
            )
          : Icon(
              icon,
              key: const ValueKey('icon'),
              size: iconSize,
              color: iconColor,
            ),
    );

    final VoidCallback? effectiveOnPressed = isLoading ? null : onPressed;

    Widget button;

    switch (variant) {
      case CustomIconButtonVariant.standard:
        button = IconButton(
          icon: iconWidget,
          onPressed: effectiveOnPressed,
          style: style,
          visualDensity: visualDensity,
          mouseCursor: mouseCursor,
          focusNode: focusNode,
          autofocus: autofocus,
          constraints: constraints,
          splashRadius: splashRadius,
          tooltip: tooltip,
        );
        break;

      case CustomIconButtonVariant.filled:
        button = IconButton.filled(
          icon: iconWidget,
          onPressed: effectiveOnPressed,
          style: style,
          visualDensity: visualDensity,
          mouseCursor: mouseCursor,
          focusNode: focusNode,
          autofocus: autofocus,
          constraints: constraints,
          tooltip: tooltip,
        );
        break;

      case CustomIconButtonVariant.filledTonal:
        button = IconButton.filledTonal(
          icon: iconWidget,
          onPressed: effectiveOnPressed,
          style: style,
          visualDensity: visualDensity,
          mouseCursor: mouseCursor,
          focusNode: focusNode,
          autofocus: autofocus,
          constraints: constraints,
          tooltip: tooltip,
        );
        break;

      case CustomIconButtonVariant.outlined:
        button = IconButton.outlined(
          icon: iconWidget,
          onPressed: effectiveOnPressed,
          style: style,
          visualDensity: visualDensity,
          mouseCursor: mouseCursor,
          focusNode: focusNode,
          autofocus: autofocus,
          constraints: constraints,
          tooltip: tooltip,
        );
        break;
    }

    return Semantics(
      button: true,
      enabled: effectiveOnPressed != null,
      label: tooltip,
      child: button,
    );
  }
}
