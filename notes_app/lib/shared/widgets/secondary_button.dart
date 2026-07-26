import 'package:flutter/material.dart';

/// ============================================================================
/// File: secondary_button.dart
/// ============================================================================
///
/// Enterprise Material 3 secondary button.
///
/// A reusable wrapper around [OutlinedButton] that provides a consistent
/// secondary action button throughout the application.
///
/// Typical use cases:
///
/// • Register
/// • Cancel
/// • Skip
/// • Back
/// • Secondary actions
/// • Optional actions
///
/// Features:
///
/// • Material 3
/// • Theme aware
/// • Accessible
/// • Loading state
/// • Responsive
/// • Desktop/Web friendly
/// • Lightweight
/// • Reusable
///
/// Example:
///
/// ```dart
/// SecondaryButton(
///   text: 'Create Account',
///   onPressed: _register,
/// )
/// ```
///
/// ```dart
/// SecondaryButton(
///   text: 'Cancel',
///   icon: Icons.close_rounded,
///   onPressed: () {},
/// )
/// ```
/// ============================================================================
@immutable
final class SecondaryButton extends StatelessWidget {
  /// Creates a reusable secondary button.
  const SecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isExpanded = true,
    this.loadingText,
    this.iconOnTrailing = false,
    this.style,
    this.focusNode,
    this.autofocus = false,
    this.mouseCursor,
    this.semanticLabel,
  });

  /// Button label.
  final String text;

  /// Callback invoked when the button is pressed.
  final VoidCallback? onPressed;

  /// Optional icon.
  final IconData? icon;

  /// Whether to display the loading state.
  final bool isLoading;

  /// Whether the button expands to fill the available width.
  final bool isExpanded;

  /// Optional loading label.
  ///
  /// When omitted, [text] is displayed.
  final String? loadingText;

  /// Whether the icon should appear after the text.
  final bool iconOnTrailing;

  /// Optional button style.
  final ButtonStyle? style;

  /// Optional focus node.
  final FocusNode? focusNode;

  /// Whether the button should receive focus automatically.
  final bool autofocus;

  /// Optional desktop/web mouse cursor.
  final MouseCursor? mouseCursor;

  /// Optional accessibility label.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final effectiveOnPressed = isLoading ? null : onPressed;

    Widget button = Semantics(
      button: true,
      enabled: effectiveOnPressed != null,
      label: semanticLabel ?? text,
      child: OutlinedButton(
        onPressed: effectiveOnPressed,
        style: style,
        focusNode: focusNode,
        autofocus: autofocus,
        clipBehavior: Clip.antiAlias,
        child: _ButtonContent(
          text: text,
          loadingText: loadingText,
          icon: icon,
          isLoading: isLoading,
          iconOnTrailing: iconOnTrailing,
        ),
      ),
    );

    if (mouseCursor != null) {
      button = MouseRegion(cursor: mouseCursor!, child: button);
    }

    if (isExpanded) {
      button = SizedBox(width: double.infinity, child: button);
    }

    return button;
  }
}

/// Internal reusable button content.
///
/// Displays one of the following:
///
/// • Loading indicator
/// • Icon + text
/// • Text + icon
/// • Text only
@immutable
final class _ButtonContent extends StatelessWidget {
  /// Creates button content.
  const _ButtonContent({
    required this.text,
    required this.loadingText,
    required this.icon,
    required this.isLoading,
    required this.iconOnTrailing,
  });

  /// Button label.
  final String text;

  /// Optional loading label.
  final String? loadingText;

  /// Optional icon.
  final IconData? icon;

  /// Whether to display the loading state.
  final bool isLoading;

  /// Whether the icon should appear after the text.
  final bool iconOnTrailing;

  @override
  Widget build(BuildContext context) {
    final textWidget = Flexible(
      child: Text(
        isLoading ? (loadingText ?? text) : text,
        overflow: TextOverflow.ellipsis,
      ),
    );

    if (isLoading) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator.adaptive(strokeWidth: 2),
          ),
          const SizedBox(width: 12),
          textWidget,
        ],
      );
    }

    if (icon == null) {
      return textWidget;
    }

    final iconWidget = Icon(icon, size: 20);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!iconOnTrailing) ...[iconWidget, const SizedBox(width: 8)],
        textWidget,
        if (iconOnTrailing) ...[const SizedBox(width: 8), iconWidget],
      ],
    );
  }
}
