import 'package:flutter/material.dart';

/// ============================================================================
/// File: custom_icon_button.dart
/// ============================================================================
///
/// Enterprise Material 3 reusable icon button.
///
/// Standardizes icon button behavior throughout the application while keeping
/// the implementation lightweight and aligned with Flutter Material 3.
///
/// Features:
///
/// - Material 3 compliant
/// - Theme-aware
/// - Accessible
/// - Loading state
/// - Desktop/Web friendly
/// - Lightweight rendering
///
/// Common usage:
///
/// - Refresh
/// - Edit
/// - Delete
/// - Search
/// - Settings
/// - Navigation
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
    this.semanticHint,
    this.variant = CustomIconButtonVariant.standard,
    this.isLoading = false,
    this.enabled = true,
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

  /// Press callback.
  final VoidCallback? onPressed;

  /// Tooltip shown on hover/long press.
  final String? tooltip;

  /// Accessibility hint.
  final String? semanticHint;

  /// Button variant.
  final CustomIconButtonVariant variant;

  /// Loading state.
  final bool isLoading;

  /// Whether button is enabled.
  final bool enabled;

  /// Icon size.
  final double? iconSize;

  /// Icon color.
  final Color? iconColor;

  /// Custom button style.
  final ButtonStyle? style;

  /// Visual density.
  final VisualDensity? visualDensity;

  /// Desktop/web cursor.
  final MouseCursor? mouseCursor;

  /// Focus node.
  final FocusNode? focusNode;

  /// Autofocus.
  final bool autofocus;

  /// Constraints.
  final BoxConstraints? constraints;

  /// Splash radius.
  final double? splashRadius;

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = enabled && !isLoading;

    final VoidCallback? callback = isEnabled ? onPressed : null;

    final Widget iconWidget = isLoading
        ? SizedBox.square(
            dimension: iconSize ?? 20,
            child: const CircularProgressIndicator.adaptive(strokeWidth: 2),
          )
        : Icon(icon, size: iconSize, color: iconColor);

    final Widget button;

    switch (variant) {
      case CustomIconButtonVariant.standard:
        button = IconButton(
          icon: iconWidget,
          onPressed: callback,
          tooltip: tooltip,
          style: style,
          visualDensity: visualDensity,
          mouseCursor:
              mouseCursor ??
              (isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic),
          focusNode: focusNode,
          autofocus: autofocus,
          constraints: constraints,
          splashRadius: splashRadius,
        );

      case CustomIconButtonVariant.filled:
        button = IconButton.filled(
          icon: iconWidget,
          onPressed: callback,
          tooltip: tooltip,
          style: style,
          visualDensity: visualDensity,
          mouseCursor:
              mouseCursor ??
              (isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic),
          focusNode: focusNode,
          autofocus: autofocus,
          constraints: constraints,
        );

      case CustomIconButtonVariant.filledTonal:
        button = IconButton.filledTonal(
          icon: iconWidget,
          onPressed: callback,
          tooltip: tooltip,
          style: style,
          visualDensity: visualDensity,
          mouseCursor:
              mouseCursor ??
              (isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic),
          focusNode: focusNode,
          autofocus: autofocus,
          constraints: constraints,
        );

      case CustomIconButtonVariant.outlined:
        button = IconButton.outlined(
          icon: iconWidget,
          onPressed: callback,
          tooltip: tooltip,
          style: style,
          visualDensity: visualDensity,
          mouseCursor:
              mouseCursor ??
              (isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic),
          focusNode: focusNode,
          autofocus: autofocus,
          constraints: constraints,
        );
    }

    return Semantics(
      button: true,
      enabled: isEnabled,
      label: tooltip,
      hint: semanticHint,
      child: button,
    );
  }
}
