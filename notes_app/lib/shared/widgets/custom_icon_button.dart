import 'package:flutter/material.dart';

/// Defines the visual style of a [CustomIconButton].
enum CustomIconButtonVariant { standard, filled, filledTonal, outlined }

/// A reusable Material 3 icon button.
///
/// This widget provides a consistent API for icon buttons across the
/// application while supporting the Material 3 icon button variants.
///
/// Example:
/// ```dart
/// CustomIconButton(
///   icon: Icons.refresh_rounded,
///   tooltip: 'Refresh',
///   onPressed: _refresh,
/// )
/// ```
class CustomIconButton extends StatelessWidget {
  /// Creates a reusable icon button.
  const CustomIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.variant = CustomIconButtonVariant.standard,
    this.isLoading = false,
    this.iconSize,
  });

  /// Icon displayed by the button.
  final IconData icon;

  /// Called when the button is pressed.
  final VoidCallback? onPressed;

  /// Optional tooltip.
  final String? tooltip;

  /// Material 3 icon button style.
  final CustomIconButtonVariant variant;

  /// Whether to show a loading indicator instead of the icon.
  final bool isLoading;

  /// Size of the icon.
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    final Widget iconWidget = isLoading
        ? const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Icon(icon, size: iconSize);

    switch (variant) {
      case CustomIconButtonVariant.standard:
        return IconButton(
          tooltip: tooltip,
          onPressed: isLoading ? null : onPressed,
          icon: iconWidget,
        );

      case CustomIconButtonVariant.filled:
        return IconButton.filled(
          tooltip: tooltip,
          onPressed: isLoading ? null : onPressed,
          icon: iconWidget,
        );

      case CustomIconButtonVariant.filledTonal:
        return IconButton.filledTonal(
          tooltip: tooltip,
          onPressed: isLoading ? null : onPressed,
          icon: iconWidget,
        );

      case CustomIconButtonVariant.outlined:
        return IconButton.outlined(
          tooltip: tooltip,
          onPressed: isLoading ? null : onPressed,
          icon: iconWidget,
        );
    }
  }
}
